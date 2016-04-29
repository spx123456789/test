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
        [self addSubview:_imageView];
    }
    return self;
}
-(void)configCellWithModel:(VideoModel *)model
{
    _videoModel=model;
    self.imageView.image=[UIImage imageNamed:model.strImage];
    
}

@end

@implementation BottomCollectionCell
-(void)configCellWithModel:(VideoModel *)model
{
    _videoModel=model;
    self.imageView.image=[UIImage imageNamed:model.strImage];
    if (_videoModel.vedioType != 2) {
        [_markView setHidden:YES];
    }else{
        [_markView setHidden:NO];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [_markView setBackgroundColor:[UIColor redColor]];
        [self addSubview:_imageView];
        [self addSubview:_markView];
    }
    return self;
}

@end