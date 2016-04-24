//
//  StoryCell.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "StoryCell.h"

@implementation StoryCell

-(StoryCell*)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setupSubviews];
    }
    return self;
}
-(void)configCellWithModel:(StoryModel *)model
{
    _model=model;
    self.videorecordButton.backgroundColor=[UIColor greenColor];
    self.videoThumbnailView.backgroundColor=[UIColor greenColor];

}
-(void)setupSubviews
{
    @weakify(self);

    self.videorecordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.videorecordButton addTarget:self action:@selector(videorecordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.videorecordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.videorecordButton];
    self.videoThumbnailView=[[UIImageView alloc]init];
    [self.contentView addSubview:self.videoThumbnailView];

    [self.videoThumbnailView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(@100);
    }];
    
    [self.videorecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
}

-(void)videorecordButtonPressed:(UIButton *)btn
{
    if (_Delegate&&[_Delegate respondsToSelector:@selector(videorecordButtonDidSelected:)]) {
        [_Delegate videorecordButtonDidSelected:self];
    }
    
}
@end
