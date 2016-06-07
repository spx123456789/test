//
//  CollectionViewCell.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

@end

@implementation TopCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _markView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 85, 30, 30)];
        [_markView setImage:[UIImage imageNamed:@"add"]];
        _markView.contentMode=UIViewContentModeCenter;
        [self addSubview:_imageView];
        [self addSubview:_markView];
    }
    return self;
}
-(void)configCellWithModel:(VideoModel *)model
{
    _videoModel=model;
//    NSURL *url;
    if (model.vedioType==2) {
        if (model.videoImage) {
            self.imageView.image=model.videoImage;
        }else{
            self.imageView.image=[UIImage imageNamed:model.strImage];
        }
    }else{
//        NSString *urlStr =[model.strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        url =[[NSBundle mainBundle] URLForResource:urlStr withExtension:@".mp4"];
        self.imageView.image=[UIImage imageNamed:model.strImage];

    }
    if (_videoModel.vedioType != 2) {
        [_markView setHidden:YES];
    }else{
        [_markView setHidden:NO];
    }
}
@end

@implementation BottomCollectionCell
-(void)configCellWithModel:(VideoModel *)model
{
    _videoModel=model;
    
    //    NSURL *url;
    if (model.vedioType==2) {
        if (model.videoImage) {
            self.imageView.image=model.videoImage;
        }else{
            self.imageView.image=[UIImage imageNamed:model.strImage];
        }
    }else{
        //        NSString *urlStr =[model.strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        url =[[NSBundle mainBundle] URLForResource:urlStr withExtension:@".mp4"];
        self.imageView.image=[UIImage imageNamed:model.strImage];
        
    }
    if (_videoModel.vedioType != 2) {
        [_markView setHidden:YES];
    }else{
        [_markView setHidden:NO];
    }
    if ([@"capture_yep" isEqualToString:model.strImage]) {
        _intervalLabel.hidden=YES;
    }else{
        _intervalLabel.hidden=NO;

    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-30, self.bounds.size.height)];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _markView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _markView.contentMode=UIViewContentModeCenter;
        [_markView setImage:[UIImage imageNamed:@"add"]];
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerpressed:)];
        [self.contentView addGestureRecognizer:longPress];
        _intervalLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-20, 15, 20, 20)];
        _intervalLabel.textColor=[UIColor whiteColor];
        _intervalLabel.textAlignment=NSTextAlignmentCenter;
        _intervalLabel.text=@"...";
        [self addSubview:_intervalLabel];
        [self addSubview:_imageView];
        [self addSubview:_markView];
    }
    return self;
}

-(void)longPressGestureRecognizerpressed:(UILongPressGestureRecognizer*)longPress
{
    if (_bottomCelldelegate&&[
        _bottomCelldelegate respondsToSelector:@selector(cellLongPressGestureRecognizerpressed:)]) {
        [_bottomCelldelegate cellLongPressGestureRecognizerpressed:self];
    }
    
}
@end