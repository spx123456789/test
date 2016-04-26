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
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

@end