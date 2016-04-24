//
//  menuViewController.h
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "BaseViewController.h"
#import "StoryCell.h"


@interface menuViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,StoryCellDelegate>
@property (nonatomic,strong) TPKeyboardAvoidingTableView * tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
