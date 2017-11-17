//
//  ViewController.m
//  UUActionSheetDemo
//
//  Created by LEA on 2017/5/9.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "ViewController.h"
#import "UUActionSheet.h"

@interface ViewController ()<UUActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, (self.view.bounds.size.height-50)/2, self.view.bounds.size.width-100, 50)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"Click Here" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)handleBtClicked:(UIButton *)bt
{
    UUActionSheet *actionSheet = [[UUActionSheet alloc] initWithTitle:@"After the exit will not delete any historical data, the next login can still use this account.After the exit will not delete any historical data, the next login can still use this account.After the exit will not delete any historical data, the next login can still use this account.After the exit will not delete any historical data, the next login can still use this account.After the exit will not delete any historical data, the next login can still use this account."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Logout"
                                                    otherButtonTitles:@"Okay",nil];
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
