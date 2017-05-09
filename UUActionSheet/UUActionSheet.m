//
//  UUActionSheet.m
//  UUActionSheet
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UUActionSheet.h"

#define kMainScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kRowHeight              50
#define kBlank                  5
#define RGBColor(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UUActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIView            *tableHeaderView;
@property (nonatomic, strong) UIView            *sheetView;
@property (nonatomic, strong) UIView            *alphaView;
@property (nonatomic, strong) NSMutableArray    *titles;
@property (nonatomic, copy) NSString            *cancelButtonTitle;
@property (nonatomic, copy) NSString            *destructiveButtonTitle;

@end

@implementation UUActionSheet

#pragma mark - init
- (UUActionSheet *)initWithTitle:(NSString *)title delegate:(id<UUActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        
        if (delegate) {
            self.delegate = delegate;
        }
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        va_list ap;
        NSString *other = nil;
        if(otherButtonTitles)
        {
            [self.titles addObject:otherButtonTitles];
            va_start(ap, otherButtonTitles);
            while((other = va_arg(ap, NSString*))){
                [self.titles addObject:other];
            }
            va_end(ap);
        }
        if ([destructiveButtonTitle length]) {
            [self.titles insertObject:destructiveButtonTitle atIndex:0];
            self.destructiveButtonIndex = 0;
        }
        if ([cancelButtonTitle length]) {
            [self.titles addObject:cancelButtonTitle];
            self.cancelButtonIndex = [self.titles count]-1;
        }
        
        [self setupUI];
    }
    return self;
}

- (void)tapGestureCallback
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alphaView.alpha = 0;
                         [self.sheetView setFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.sheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alphaView.alpha = 0.5;
                         [self.sheetView setFrame:CGRectMake(0, kMainScreenHeight-self.sheetView.frame.size.height, kMainScreenWidth, self.sheetView.frame.size.height)];
                     }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UI
- (void)setupUI
{
    [self addSubview:self.alphaView];
    [self sendSubviewToBack:self.alphaView];
    
    [self addSubview:self.sheetView];
    [self.sheetView addSubview:self.tableView];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_sheetView.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceHorizontal = NO;
        _tableView.alwaysBounceVertical = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, [self getHeadHeight])];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGSize textSize = [_title boundingRectWithSize:CGSizeMake(kMainScreenWidth-40, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dict
                                               context:nil].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kMainScreenWidth-40, textSize.height)];
        label.text = _title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.numberOfLines = 0;
        [_tableHeaderView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableHeaderView.frame.size.height, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:self.bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.0;
        
        UITapGestureRecognizer *tapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback)];
        [_alphaView addGestureRecognizer:tapGestureRecognizer];
    }
    return _alphaView;
}

- (UIView *)sheetView
{
    if (!_sheetView) {
        CGFloat addH = [_cancelButtonTitle length]?5:0;
        CGFloat viewH = [self getHeadHeight]+kRowHeight*[self.titles count]+addH;
        _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, viewH)];
        _sheetView.backgroundColor =  RGBColor(232.0, 232.0, 239.0, 1.0);
    }
    return _sheetView;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

#pragma mark - methods
- (CGFloat)getHeadHeight
{
    CGFloat height = 0;
    if ([_title length])
    {
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGSize textSize = [_title boundingRectWithSize:CGSizeMake(kMainScreenWidth-40, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dict
                                               context:nil].size;
        height += textSize.height+40;
    }
    return height;
}

#pragma mark - tableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        return kRowHeight + kBlank;
    }
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kRowHeight)];
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@",[self.titles objectAtIndex:indexPath.row]];
        label.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    if ([_destructiveButtonTitle length] && indexPath.row == 0) {
        label.textColor = [UIColor redColor];//RGBColor(225.0, 59.0, 60.0, 1.0);
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        label.frame = CGRectMake(0, kBlank, kMainScreenWidth, kRowHeight);
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self tapGestureCallback];
}

@end
