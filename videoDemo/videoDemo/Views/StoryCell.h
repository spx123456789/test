//
//  StoryCell.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@protocol StoryCellDelegate;

@interface StoryCell : UITableViewCell

@property (nonatomic,strong) UIButton *videoPreviewButton;
@property (nonatomic,strong) UIButton  *videorecordButton;
@property (nonatomic,weak) id<StoryCellDelegate>  Delegate;
@property (nonatomic,strong) StoryModel  *model;
@property (nonatomic,strong) UILabel *titleLabel;
-(void)configCellWithModel:(StoryModel*)model;

@end


@protocol StoryCellDelegate <NSObject>
@optional
-(void)videorecordButtonDidSelected:(StoryCell*)cell;
-(void)videoPreviewButtonDidSelected:(StoryCell*)cell;

@end