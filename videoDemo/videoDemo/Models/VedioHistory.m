//
//  VedioHistory.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "VedioHistory.h"
@implementation VedioHistory

- (id)init
{
    self = [super init];
    if (self) {
        _arrDataSource = [[NSMutableArray alloc] init];
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"videolist.sqlite"];
        
        //2.获得数据库
        FMDatabase *db=[FMDatabase databaseWithPath:fileName];
        
        //3.打开数据库
        if ([db open]) {
            //4.创表
            BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS videolist (id integer PRIMARY KEY AUTOINCREMENT, title varchar(100), create_time varchar(50),userid integer,video_type integer,play_time integer,video_url varchar(100),pic_url varchar(100));"];
            if (result) {
                NSLog(@"创表成功");
            }else
            {
                NSLog(@"创表失败");
            }
        }
        self.db=db;
    }
    
    return self;
}


//删除路演
-(void)deleteLuyanUserId:(NSString *)userid{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM videolist where video_type =1 and userid=%li;",[userid integerValue]];
    [self.db executeUpdate:sqlstr];
    
}


//删除课程
-(void)deleteKechengUserId:(NSString *)userid{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM videolist where video_type =2 and userid=%li;",[userid integerValue]];
    [self.db executeUpdate:sqlstr];
}


//插入数据
-(void)insertTitle:(NSString *)title createTime:(NSString *)create_time userId:(NSInteger )userid videoType:(NSInteger )video_type playTime:(NSInteger )play_time videoUrl:(NSString *)video_url picUrl:(NSString *)pic_url
{
    // 1.执行查询语句
    NSUInteger count = [self.db intForQuery:@"select count(*) from videolist where video_url =?;",video_url];
    //NSLog(@"%li",count);
    if(count>0){
        [self.db executeUpdate:@"update videolist set play_time =?,create_time=? where video_url=?",play_time,create_time,video_url];
    }else{
        [self.db executeUpdate:@"INSERT INTO videolist (title,create_time,userid,video_type,play_time,video_url,pic_url) VALUES (?, ?, ?, ?, ?, ?, ?);",title,create_time,userid,video_type,play_time,video_url,pic_url];
    }
    
}

//删除单条数据
-(void)deleteoneVideoUrl:(NSString *)video_url{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM videolist where video_url=%@;",video_url];
    [self.db executeUpdate:sqlstr];
}

//

//删除数据
-(void)deletesql
{
    [self.db executeUpdate:@"DELETE FROM videolist;"];
    //         [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
    //         [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
}


//查询路演
- (NSMutableArray *)queryLuyanUserId:(NSString *)userid page:(NSInteger )page
{
    _arrsql = [NSMutableArray array];
    
    if(!page){
        page = 1;
    }
    int pagenum = 3;
   // NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM video_list where video_type =1 and userid=%li",userid];
    
    NSString *sqlstr = [NSString stringWithFormat:@"select * from videolist where video_type=1 and userid=%li limit %ld,%d;",[userid integerValue],(page-1)*pagenum,pagenum];
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:sqlstr];
    // 2.遍历结果
    while ([resultSet next]) {
        UserVideo *uservideo = [[UserVideo alloc] init];
        
        int ID = [resultSet intForColumn:@"id"];
        uservideo.title = [resultSet stringForColumn:@"title"];
        uservideo.createTime = [resultSet stringForColumn:@"create_time"];
        uservideo.userid = [resultSet intForColumn:@"userid"];
        uservideo.videoType = [resultSet intForColumn:@"video_type"];
        uservideo.playTime = [resultSet intForColumn:@"play_time"];
        uservideo.videoUrl = [resultSet stringForColumn:@"video_url"];
        uservideo.picUrl= [resultSet stringForColumn:@"pic_url"];
        [_arrsql addObject: uservideo];
    }
    return _arrsql;
}

//查询课程
- (NSMutableArray *)queryKechengUserId:(NSString *)userid page:(NSInteger )page
{
    // 1.执行查询语句
    _arrsql = [NSMutableArray array];
    
    if(!page){
        page = 1;
    }
    int pagenum = 3;
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM videolist where video_type=2 and userid=%li limit %ld,%d;",[userid integerValue],(page-1)*pagenum,pagenum];
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:sqlstr];
    
    // 2.遍历结果
    while ([resultSet next]) {
        UserVideo *uservideo = [[UserVideo alloc] init];
        
        int ID = [resultSet intForColumn:@"id"];
        uservideo.title = [resultSet stringForColumn:@"title"];
        uservideo.createTime = [resultSet stringForColumn:@"create_time"];
        uservideo.userid = [resultSet intForColumn:@"userid"];
        uservideo.videoType = [resultSet intForColumn:@"video_type"];
        uservideo.playTime = [resultSet intForColumn:@"play_time"];
        uservideo.videoUrl = [resultSet stringForColumn:@"video_url"];
        uservideo.picUrl= [resultSet stringForColumn:@"pic_url"];
        [_arrsql addObject:uservideo];
        
        // NSLog(@"%@,%@,%i,%i,%i,%i,%@",title,create_time,userid,video_type,play_time,times,pic_url);
    }
    //NSLog(@"%@",_arrsql);
    return _arrsql;
}

//关闭方法

-(void)closesql{
    [self.db close];
}
@end
