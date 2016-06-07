//
//  CollectionViewCell.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@protocol BottomCollectionCellDelegate;

@interface CollectionViewCell : UICollectionViewCell

@end

@interface TopCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *markView;
@property (nonatomic,strong) VideoModel *videoModel;
-(void)configCellWithModel:(VideoModel*)model;

@end

@interface BottomCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *markView;
@property (nonatomic,strong) UILabel *intervalLabel;
@property (nonatomic,strong) VideoModel *videoModel;
@property (nonatomic,weak) id<BottomCollectionCellDelegate> bottomCelldelegate;
-(void)configCellWithModel:(VideoModel*)model;

@end
@protocol BottomCollectionCellDelegate <NSObject>
@optional
-(void)cellLongPressGestureRecognizerpressed:(BottomCollectionCell*)cell;

@end

