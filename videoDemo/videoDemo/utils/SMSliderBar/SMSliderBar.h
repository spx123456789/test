//
//  SMSliderBar.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SMSliderType){
    SMSliderTypeVer=0,
    SMSliderTypeHoz
};

@protocol SMSliderDelegate <NSObject>

@optional
-(void)SMSliderBar:(UIView*)slider valueChanged:(float)value;
-(void)SMSliderBarBeginTouch:(UIView *)slider;
-(void)SMSliderBarEndTouch:(UIView *)slider;
@end

@interface SMSliderBar : UIView


/**
 *  @author StoneMover, 15-12-07 14:12:59
 *
 *  @brief 圆点view
 */
@property(strong ,nonatomic) UIView * viewPoint;


/**
 *  @author StoneMover, 15-12-07 14:12:53
 *
 *  @brief 进度颜色
 */
@property(strong ,nonatomic) UIColor * progressColor;

/**
 *  @author StoneMover, 15-12-14 14:12:48
 *
 *  @brief 缓冲条颜色
 */
@property(strong ,nonatomic) UIColor * bufferBgColor;


/**
 *  @author StoneMover, 15-12-07 14:12:48
 *
 *  @brief 进度背景色
 */
@property(strong ,nonatomic) UIColor * progressBgColor;


/**
 *  @author StoneMover, 15-12-07 14:12:42
 *
 *  @brief 改变值的触摸间距,大于这个值认为进度改变
 */
@property(assign, nonatomic) float changeDistance;

/**
 *  @author StoneMover, 15-12-07 14:12:21
 *
 *  @brief 类型,垂直或者水平
 */
@property(assign, nonatomic) SMSliderType type;

/**
 *  @author StoneMover, 15-12-07 14:12:07
 *
 *  @brief 进度条的值
 */
@property(assign, nonatomic) float value;

/**
 *  @author StoneMover, 15-12-12 14:12:07
 *
 *  @brief 缓冲条的值
 */
@property(assign, nonatomic) float bufferValue;


@property(weak, nonatomic)id<SMSliderDelegate> delegate;


/**
 *  @author StoneMover, 15-12-07 14:12:50
 *
 *  @brief 是否在按下的时候也可以改变value
 */
@property(assign, nonatomic) BOOL isTouchBegin;

/**
 *  @author StoneMover, 15-12-07 14:12:50
 *
 *  @brief 是否允许拖动进度条
 */
@property(assign, nonatomic) BOOL isAllowDrag;
@end
