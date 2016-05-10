//
//  BaseViewController.m
//  videoDemo
//
//  Created by SHANPX on 16/4/19.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewWillLayoutSubviews {
  self.view.frame = CGRectMake(10, 10, ScreenWidth, ScreenHeight);
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  self.view.clipsToBounds = YES;

  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//隐藏导航条
- (void)hideNavigationBar {
  [self.navigationController setNavigationBarHidden:YES];
}

//显示导航条
- (void)showNavigationBar {
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)showStatusBar {
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)hideStatusBar {
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)setExtraCellLineHidden:(UITableView *)tableView {
  if (tableView != nil) {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
  }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
