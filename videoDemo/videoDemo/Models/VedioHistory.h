//
//  VedioHistory.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "UserVideo.h"

@interface VedioHistory : NSObject
@property(nonatomic,strong) FMDatabase *db;
@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong,nonatomic) NSMutableArray *arrsql;


//插入数据
-(void)insertTitle:(NSString *)title createTime:(NSString *)create_time userId:(NSInteger )userid videoType:(NSInteger )video_type playTime:(NSInteger )play_time videoUrl:(NSString *)video_url picUrl:(NSString *)pic_url;

//删除数据
-(void)deletesql;

//删除全部路演数据
-(void)deleteLuyanUserId:(NSString *)userid;

//删除全部课程数据
-(void)deleteKechengUserId:(NSString *)userid;

//删除单条数据
-(void)deleteoneVideoUrl:(NSString *)video_url;


//查询路演
- (NSMutableArray *)queryLuyanUserId:(NSString *)userid page:(NSInteger )page;


//关闭数据库
-(void)closesql;


//查询课程
- (NSMutableArray *)queryKechengUserId:(NSString *)userid page:(NSInteger)page;
@end
