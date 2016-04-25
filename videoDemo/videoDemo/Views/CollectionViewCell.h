//
//  CollectionViewCell.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@end

@interface TopCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@end

@interface BottomCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@end