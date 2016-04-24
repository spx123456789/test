//
//  MBMessageTip.h
//  MuchMore
//
//  Created by zhangyu on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef enum  {
    MBMessageTipTypeOK = 0,
    MBMessageTipTypeLoading
}MBMessageTipType;

@protocol MBMessageTipDelegate;

@interface MBMessageTip : NSObject<MBProgressHUDDelegate>
@property (nonatomic,retain) id<MBMessageTipDelegate> delegate;
@property (nonatomic,retain) MBProgressHUD* HUD;

+ (void)messageWithTip:(UIView*)view withMessage:(NSString*)info;

+ (void)messageWithTip:(UIView*)view withDelegate:(id<MBMessageTipDelegate>)_delegate withMessage:(NSString*)info;
+ (void)messageAddedTo:(UIView*)view andMessage:(NSString*)str;

+(void)loadingStart:(UIView*)view withMessage:(NSString*)info;
+(void)loadingStop;
@end

@protocol MBMessageTipDelegate <NSObject>

- (void)MessageTipWasHidden:(MBMessageTip *)tip;
@end


@protocol MBViewControllerDelegate <NSObject>

-(void)finish:(UIViewController*)viewController withObject:(NSObject*) obj;

@end