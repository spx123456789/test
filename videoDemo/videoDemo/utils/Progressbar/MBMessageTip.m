//
//  MBMessageTip.m
//  MuchMore
//
//  Created by zhangyu on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MBMessageTip.h"

@implementation MBMessageTip
@synthesize delegate;
@synthesize HUD;


static MBMessageTip* MBMessageTipShareInstance;
static const int MBMessageTipTag = 200120313;
-(void)showTipView:(UIView*)view withDelegate:(id<MBMessageTipDelegate>)_delegate withMessage:(NSString*)info withTyepe:(MBMessageTipType)type{
    
    if (!view) {
        return;
    }
    
    self.delegate = _delegate;
    if(!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:view];
    }
    self.HUD.tag = MBMessageTipTag;
	[view addSubview:self.HUD];
	 
    if(type == MBMessageTipTypeLoading){
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [activity sizeToFit];
        self.HUD.customView = activity;
        [activity startAnimating];
        
    }else{
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
	
	
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
	
    self.HUD.delegate = self;
    self.HUD.labelText = info;
	
    [self.HUD show:YES];
    
    if(type == MBMessageTipTypeLoading){
        
    }else{
        [self.HUD hide:YES afterDelay:1];
    }
	
}

-(void)showTipView:(UIView*)view withDelegate:(id<MBMessageTipDelegate>)_delegate withMessage:(NSString*)info {
    [self showTipView:view withDelegate:_delegate withMessage:info withTyepe:MBMessageTipTypeOK];
}

-(void)showTipView:(UIView*)view withMessage:(NSString*)info {
    [self showTipView:view withDelegate:nil withMessage:info];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    if(self.delegate){
        [self.delegate MessageTipWasHidden:self];
    }
}


- (void)showHUDAddedTo:(UIView*)view andMessageStr:(NSString*)str
{
    self.HUD = nil;
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = str;
    self.HUD.margin = 10.f;
    self.HUD.yOffset = 180.f;
    self.HUD.delegate = self;
    self.HUD.labelFont = [UIFont systemFontOfSize:14];
    [self.HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

}

- (void)myTask
{
    sleep(1.5);
    MBMessageTipShareInstance = nil;
}

+ (void)messageWithTip:(UIView*)view withMessage:(NSString*)info {
    MBMessageTip* tip = [[MBMessageTip alloc]init] ;
    [tip showTipView:view withMessage:info];

}

+ (void)messageAddedTo:(UIView*)view andMessage:(NSString*)str
{
    MBMessageTip* tip = [[MBMessageTip alloc]init] ;
    [tip showHUDAddedTo:view andMessageStr:str];
}

+ (void)messageWithTip:(UIView*)view withDelegate:(id<MBMessageTipDelegate>)_delegate withMessage:(NSString*)info{
    MBMessageTip* tip = [[MBMessageTip alloc]init] ;
    [tip showTipView:view withDelegate:_delegate withMessage:info];
}

+(void)loadingStart:(UIView*)view withMessage:(NSString*)info{
    if(MBMessageTipShareInstance){
        [self loadingStop];
    }
    MBMessageTipShareInstance = [[MBMessageTip alloc]init];
    [MBMessageTipShareInstance showTipView:view withDelegate:nil withMessage:info withTyepe:MBMessageTipTypeLoading];

}
+(void)loadingStop{
    if(MBMessageTipShareInstance){
        //[MBMessageTipShareInstance.HUD  hide:YES];
        [MBMessageTipShareInstance hudWasHidden:MBMessageTipShareInstance.HUD];
        MBMessageTipShareInstance = nil;
    }
}
@end
