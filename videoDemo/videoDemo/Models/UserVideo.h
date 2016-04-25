//
//  UserVideo.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UserVideo : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger userid;
@property (assign, nonatomic) NSInteger videoType;
@property (assign, nonatomic) NSInteger playTime;
@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *picUrl;
@end
