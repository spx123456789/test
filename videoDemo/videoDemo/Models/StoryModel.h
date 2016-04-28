//
//  StoryModel.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryModel : NSObject
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *localID;
@property (nonatomic,strong) NSMutableArray *itemArray;

@property (nonatomic,assign) BOOL ifDesk;

@end
