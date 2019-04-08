//
//  ViewController.m
//  UUActionSheetDemo
//
//  Created by LEA on 2017/5/9.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "ViewController.h"
#import "UUActionSheet.h"

@interface ViewController () <UUActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.center = self.view.center;
    [btn setTitle:@"点击这里" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)handleClicked:(UIButton *)bt
{
    UUActionSheet * actionSheet = [[UUActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"退出登录"
                                                     otherButtonTitles:@"换账号登录",nil];
    [actionSheet showInView:self.view.window];
}

#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",buttonIndex);
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
