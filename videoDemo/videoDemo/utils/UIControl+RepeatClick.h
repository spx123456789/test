//
//  UIControl+RepeatClick.h
//  AVPlayerDemo
//
//  Created by Yx on 15/9/8.
//  Copyright © 2015年 WuhanBttenMobileTechnologyCo.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (RepeatClick)
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;   // 可以用这个给重复点击加间隔
@property (nonatomic, assign) BOOL ignoreEvent;//是否被点击了
@end
