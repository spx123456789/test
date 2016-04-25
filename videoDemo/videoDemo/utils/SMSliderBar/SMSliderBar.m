//
//  SMSliderBar.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "SMSliderBar.h"
#import "Utils.h"

#define ViewFrameSizeW(vi) vi.frame.size.width
#define ViewFrameSizeH(vi) vi.frame.size.height

const int defaultProgressHeight=4;

@interface SMSliderBar()

@property(assign, nonatomic) int w;                 //当前view的宽

@property(assign, nonatomic) int h;                 //当前view的高

@property(strong, nonatomic) UIView *viewBg;        //背景条

@property(strong, nonatomic) UIView *viewProgress;  //进度条

@property(strong, nonatomic) UIView *viewBuffer;    //缓冲条

@property(assign, nonatomic) float progressTotalW;  //进度条宽

@property(assign, nonatomic) float lastX;           //初始值

@property(assign, nonatomic) BOOL islayout;         //是否给各个view赋初始值了

@end

@implementation SMSliderBar

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

-(void)initSelf{
    if (!self.viewPoint) {
        self.viewPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        self.viewPoint.layer.cornerRadius = 7;
        [self.viewPoint setAlpha:1];
        self.viewPoint.backgroundColor=[UIColor lightGrayColor];
    }
    
    self.viewBg = [[UIView alloc] init];
    self.viewBuffer = [[UIView alloc] init];
    self.viewProgress = [[UIView alloc] init];
    self.viewBg.userInteractionEnabled=YES;
    [self addSubview:self.viewBg];
    [self addSubview:self.viewBuffer];
    [self addSubview:self.viewProgress];
    [self addSubview:self.viewPoint];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)layoutSubviews{
    self.w = ViewFrameSizeW(self);
    self.h = ViewFrameSizeH(self);
    if (!self.islayout) {
        self.islayout = YES;
        int startX = ViewFrameSizeW(self.viewPoint);
        self.progressTotalW = self.w - 2 * ViewFrameSizeW(self.viewPoint);
        //最底部view
        self.viewBg.frame=CGRectMake(startX, self.h/2-defaultProgressHeight/2, self.progressTotalW, defaultProgressHeight);
        if (self.progressBgColor) {
            self.viewBg.backgroundColor = self.progressBgColor;
        }else{
            self.viewBg.backgroundColor = [UIColor redColor];
        }
        //缓冲条相关
        self.viewBuffer.frame = CGRectMake(startX, self.h/2-defaultProgressHeight/2, self.progressTotalW, defaultProgressHeight);
        if (self.bufferBgColor) {
            self.viewBuffer.backgroundColor = self.bufferBgColor;
        }else{
            self.viewBuffer.backgroundColor = [UIColor grayColor];
        }
        //进度条相关
        self.viewProgress.frame = CGRectMake(startX, self.h/2-defaultProgressHeight/2, self.value*self.progressTotalW, defaultProgressHeight);
        if (self.progressColor) {
            self.viewProgress.backgroundColor = self.progressColor;
        }else{
            self.viewProgress.backgroundColor = [UIColor greenColor];
        }
        //触摸点
        self.viewPoint.center = CGPointMake(self.value*self.progressTotalW+ViewFrameSizeW(self.viewPoint), self.h/2);
    }
}

- (void)setValue:(float)value{
    
    if (isnan(value)) {
        return;
    }
    
    _value = value;
    
    if (_value > 1) {
        _value = 1;
        
    }
    
    if (_value < 0) {
        _value = 0;
    }
//    NSLog(@"%f",value);
    self.viewPoint.center = CGPointMake(value*self.progressTotalW+ViewFrameSizeW(self.viewPoint), self.h/2);
    [Utils setViewWidth:self.viewProgress withWidth:self.value*self.progressTotalW];
}

- (void)setBufferValue:(float)bufferValue{
    if (isnan(bufferValue)) {
        return;
    }
    
    _bufferValue = bufferValue;
    
    if (_bufferValue > 1) {
        _bufferValue = 1;
        
    }
    
    if (_bufferValue < 0) {
        _bufferValue = 0;
    }
    //    NSLog(@"%f",bufferValue);
    [Utils setViewWidth:self.viewBuffer withWidth:self.bufferValue*self.self.w];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate SMSliderBarBeginTouch:self];
    if (self.isTouchBegin) {
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        CGPoint nowPoint = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
        [self calculate:nowPoint];
        [self.delegate SMSliderBar:self valueChanged:self.value];
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.isAllowDrag){
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        CGPoint nowPoint = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
        [self calculate:nowPoint];
        [self.delegate SMSliderBar:self valueChanged:self.value];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isAllowDrag) {
        [self.delegate SMSliderBarEndTouch:self];
    }
}

- (void)calculate:(CGPoint)nowPoint{
    if (self.type == SMSliderTypeHoz) {
        if (fabs(nowPoint.x-self.lastX) > self.changeDistance) {
            float valueNow = (nowPoint.x-ViewFrameSizeW(self.viewPoint))/self.progressTotalW;
            if (valueNow > 1) {
                valueNow = 1;
            }
            if (valueNow < 0) {
                valueNow = 0;
            }
            self.value = valueNow;
            self.lastX = nowPoint.x;
        }
        
    }
}

@end
