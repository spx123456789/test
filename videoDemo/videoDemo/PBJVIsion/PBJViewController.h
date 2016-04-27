//
//  PBJViewController.h
//  Vision
//
//  Created by Patrick Piemonte on 7/23/13.
//  Copyright (c) 2013 Patrick Piemonte. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "VideoModel.h"
#import "BaseViewController.h"
@interface PBJViewController : BaseViewController
@property (nonatomic,strong) VideoModel *videoModel;
@end
