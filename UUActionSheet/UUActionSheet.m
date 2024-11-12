//
//  UUActionSheet.m
//  UUActionSheet
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UUActionSheet.h"

CG_INLINE CGFloat UUSafeAreaHeight() {
    
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow * mainWindow = [[[UIApplication sharedApplication] delegate] window];
        height = mainWindow.safeAreaInsets.bottom;
    }
    return height;
}
#define kSafeAreaHeight     UUSafeAreaHeight() // 安全区域高度
#define kMargin             5  // 间距
#define kRowHeight          54 // 行高

@interface UUActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *titles;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *destructiveButtonTitle;

@end

@implementation UUActionSheet

- (UUActionSheet *)initWithTitle:(NSString *)title
                        delegate:(id<UUActionSheetDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;

        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        _titles = [[NSMutableArray alloc] init];
        va_list ap;
        NSString *other = nil;
        if(otherButtonTitles) {
            [_titles addObject:otherButtonTitles];
            va_start(ap, otherButtonTitles);
            while((other = va_arg(ap, NSString*))){
                [_titles addObject:other];
            }
            va_end(ap);
        }
        if ([destructiveButtonTitle length]) {
            [_titles insertObject:destructiveButtonTitle atIndex:0];
            self.destructiveButtonIndex = 0;
        }
        if ([cancelButtonTitle length]) {
            [_titles addObject:cancelButtonTitle];
            self.cancelButtonIndex = [self.titles count] - 1;
        }
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    CGFloat h = 0;
    if ([_cancelButtonTitle length] > 0) {
        h += kMargin;
    }
    h += [_titles count] * kRowHeight + kSafeAreaHeight;

    // 承载按钮
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0.0;
    }
    [self addSubview:tableView];
    
    // 承载标题
    if ([_title length] > 0) {
        CGFloat title_h = [_title boundingRectWithSize:CGSizeMake(self.bounds.size.width - 50, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]}
                                               context:NULL].size.height + 40;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, title_h)];
        header.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        // 标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, header.frame.size.width - 50, title_h)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor colorWithWhite:0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _title;
        [header addSubview:label];
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 0.5, header.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.07];
        [header addSubview:line];
        
        tableView.frame = CGRectMake(0, self.frame.size.height, self.bounds.size.width, h + title_h);
        tableView.tableHeaderView = header;
    } else {
        tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, h);
    }
    
    CGRect bounds = tableView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    tableView.layer.mask = maskLayer;
    self.tableView = tableView;
}

#pragma mark - 显示|隐藏
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.frame.size.height - self.tableView.frame.size.height;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.frame.size.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:buttonIndex];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.tableView.frame, currentPoint) == NO) {
        [self dismiss];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kRowHeight)];
        label.tag = 2017;
        label.font = [UIFont systemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        CGFloat rowHeight = kRowHeight;
        if ([_cancelButtonTitle length] && indexPath.row == [_titles count] - 1) {
            rowHeight = kRowHeight + kSafeAreaHeight;
        }
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, rowHeight)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        cell.selectedBackgroundView = bgView;
    }
    
    UILabel *label = [cell.contentView viewWithTag:2017];
    label.text = [self.titles objectAtIndex:indexPath.section];
    if ([_destructiveButtonTitle length] && indexPath.section == 0) {
        label.textColor = [UIColor colorWithRed:227/255.0 green:83/255.0 blue:76/255.0 alpha:1.0];
    } else {
        label.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_cancelButtonTitle.length > 0 && section == [_titles count] - 2) {
        return kMargin;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    if (_cancelButtonTitle.length > 0 && section == [_titles count] - 2) {
        footer.frame = CGRectMake(0, 0, self.bounds.size.width, kMargin);
        footer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    } else {
        footer.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
        footer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.07];
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.section == [_titles count] - 1) {
        return kRowHeight + kSafeAreaHeight;
    }
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.section];
    }
    [self dismiss];
}

@end
