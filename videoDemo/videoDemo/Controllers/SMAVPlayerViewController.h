//
//  SMAVPlayerViewController.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAVPlayerViewController : UIViewController{
    NSTimer *splashTimer;
}

@property (nonatomic,assign)float startTime;
@property (nonatomic, strong) NSMutableArray *arrVedio;
@end
