//
//  VedioModel.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, strong) NSString *strUserID;      //用户ID
@property (nonatomic, strong) NSString *strSchedule;    //播放进度
@property (nonatomic, strong) NSString *strURL;         //视频地址
@property (nonatomic, strong) NSString *strTitle;       //视频标题
@property (nonatomic, strong) NSString *strImage;       //视频图片
@property (nonatomic, assign) int vedioType;            //当前视频类型 1是预置视频 2是用户可录视频
@property (nonatomic, assign) NSInteger strIndex;       //当前视频位置
@property (nonatomic, strong) NSString *vedioID;        //当前视频ID




@end
