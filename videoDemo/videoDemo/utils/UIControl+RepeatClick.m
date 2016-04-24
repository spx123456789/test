//
//  UIControl+RepeatClick.m
//  AVPlayerDemo
//
//  Created by Yx on 15/9/8.
//  Copyright © 2015年 WuhanBttenMobileTechnologyCo.,Ltd. All rights reserved.
//
//防止按钮重复点击
#import "UIControl+RepeatClick.h"
#import <objc/runtime.h>
static char *const kShouldBeIgnoreEvent = "kShouldIgnoreEvent";
@implementation UIControl (RepeatClick)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
#pragma mark - PropertyAddition

- (void)setIgnoreEvent:(BOOL)ignoreEvent
{
    objc_setAssociatedObject(self, kShouldBeIgnoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent
{
    NSNumber *shouldBeEvent = objc_getAssociatedObject(self, kShouldBeIgnoreEvent);
    if (shouldBeEvent) {
        self.ignoreEvent = NO;
        return NO;
    }
    return [shouldBeEvent integerValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}


+ (void)load
{
    //单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method b = class_getInstanceMethod(self, @selector(reSendAction:to:forEvent:));
        method_exchangeImplementations(a, b);
    });
}

- (void)reSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    if ([className isEqualToString:@"UISegmentedControl"]) {
         [self reSendAction:action to:target forEvent:event];
        return;
    }
    if (self.ignoreEvent) return;
    if (self.acceptEventInterval > 0)
    {
        NSLog(@"来找我吧，嘿嘿");
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.acceptEventInterval];
    }
    [self reSendAction:action to:target forEvent:event];
}

@end
