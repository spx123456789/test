//
//  BaseViewController.h
//  videoDemo
//
//  Created by SHANPX on 16/4/19.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//显示/隐藏导航
- (void)hideNavigationBar;
- (void)showNavigationBar;
//显示/隐藏状态栏
- (void)showStatusBar;
- (void)hideStatusBar;

@end
