//
//  UUActionSheet.m
//  UUActionSheet
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UUActionSheet.h"

#define kDeviceHeight   [UIScreen mainScreen].bounds.size.height // 屏幕高度
#define kDeviceWidth    [UIScreen mainScreen].bounds.size.width // 屏幕宽度
#define k_iPhoneX       (kDeviceHeight >= 812.0f) // iPhone X系列
#define kMargin         5 // 边距
#define kRowHeight      50 // 行高

@interface UUActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * titles;
@property (nonatomic, copy) NSString * cancelButtonTitle;
@property (nonatomic, copy) NSString  * destructiveButtonTitle;

@end

@implementation UUActionSheet

#pragma mark - 初始化
- (UUActionSheet *)initWithTitle:(NSString *)title delegate:(id<UUActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        _titles = [[NSMutableArray alloc] init];
        va_list ap;
        NSString * other = nil;
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
    // 表头 ↓↓
    UIView * tableHeaderView = [[UIView alloc] init];
    tableHeaderView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    // 标题
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 40, 0)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _title;
    [label sizeToFit];
    [label setFrame:CGRectMake(20, 20, self.frame.size.width - 40, ceil(label.frame.size.height))];
    [tableHeaderView addSubview:label];
    [tableHeaderView setFrame:CGRectMake(0, 0, self.frame.size.width, label.frame.size.height + 40)];
    // 分割线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, tableHeaderView.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [tableHeaderView addSubview:line];
    // 表格 ↓↓
    CGFloat h = tableHeaderView.frame.size.height;
    if ([_cancelButtonTitle length]) {
        h += kMargin;
    }
    h += [self.titles count] * kRowHeight;
    if (k_iPhoneX) {
        h += 30;
    }
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, h)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.userInteractionEnabled = YES;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:237.0/255.0 blue:243.0/255.0 alpha:0.9];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = tableHeaderView;
    [self addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - 显示|隐藏
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.frame.size.height - self.tableView.frame.size.height;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.frame.size.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];

        UILabel * label = [[UILabel alloc] init];
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        [cell.contentView addSubview:label];
        
        UIView * line = [[UIView alloc] init];
        line.tag = 200;
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [cell.contentView addSubview:line];
    }
    
    UILabel * label = [cell.contentView viewWithTag:100];
    label.frame = CGRectMake(0, 0, self.frame.size.width, kRowHeight);
    label.text = [self.titles objectAtIndex:indexPath.row];

    UIView * line = [cell.contentView viewWithTag:200];
    line.frame = CGRectMake(0, kRowHeight - 0.5, self.frame.size.width, 0.5);
    line.hidden = NO;
    if ([_destructiveButtonTitle length] && indexPath.row == 0) {
        label.textColor = [UIColor redColor];
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count] - 2) {
        line.hidden = YES;
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count] - 1) {
        label.frame = CGRectMake(0, kMargin, self.frame.size.width, kRowHeight);
        line.frame = CGRectMake(0, kRowHeight + kMargin - 0.5, self.frame.size.width, 0.5);
    }
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y, self.frame.size.width, kRowHeight - 1)];
    bgView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.8];
    cell.selectedBackgroundView = bgView;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [_titles count] - 1) {
        return kRowHeight + kMargin;
    }
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self dismiss];
}

@end
