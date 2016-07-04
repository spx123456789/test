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
    [self.videoPreviewButton setImage:[UIImage imageNamed:model.thumb] forState:UIControlStateNormal];
    [self.videorecordButton setContentMode:UIViewContentModeScaleAspectFit];
    if ([model.title hasSuffix:@".mov"]) {
        self.titleLabel.text = [model.title substringWithRange:NSMakeRange(0, [model.title length] - 9)];
    } else {
        self.titleLabel.text = model.title;
    }
//    self.videorecordButton.hidden=model.ifDesk;
    if (model.ifDesk) {
        [self.videorecordButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }else{
        [self.videorecordButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    }
}
-(void)setupSubviews
{
    @weakify(self);

    self.videorecordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.videorecordButton addTarget:self action:@selector(videorecordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.videoPreviewButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.videoPreviewButton addTarget:self action:@selector(videoPreviewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.textColor=[UIColor blackColor];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.videorecordButton];
    [self.contentView addSubview:self.videoPreviewButton];

    [self.videoPreviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(@100);
    }];
    
    [self.videorecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(-40);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.width.equalTo(@60);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.videoPreviewButton.mas_right).offset(50);
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        make.right.equalTo(self.videorecordButton.mas_left).offset(10);
    }];
    
}

-(void)videorecordButtonPressed:(UIButton *)btn
{
    if (_Delegate&&[_Delegate respondsToSelector:@selector(videorecordButtonDidSelected:)]&&(!self.model.ifDesk)) {
        [_Delegate videorecordButtonDidSelected:self];
    }
    
}

-(void)videoPreviewButtonPressed:(UIButton *)btn
{
    if (_Delegate&&[_Delegate respondsToSelector:@selector(videoPreviewButtonDidSelected:)]) {
        [_Delegate videoPreviewButtonDidSelected:self];
    }
}
@end
