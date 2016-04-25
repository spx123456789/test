//
//  menuViewController.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "menuViewController.h"
#import "RecoadListViewController.h"
@interface menuViewController ()
@property (nonatomic,assign) NSInteger selectIndex;
@end
@implementation menuViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}
-(void)viewDidLoad
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"S",@"W",@"P",@"D",@"ME",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20, 0,self.view.frame.size.width-80 , 30);
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    _selectIndex=0;
    segmentedControl.tintColor = [UIColor redColor];
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [self.view addSubview:self.tableView];
    
    UIButton *playButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 0, 50, 30)];
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    [playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)playButtonPressed:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(TPKeyboardAvoidingTableView*)tableView{
    if (!_tableView) {
      TPKeyboardAvoidingTableView  *tableView=[[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 30,ScreenWidth , ScreenHeight) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        _tableView=tableView;
    }
    
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"111"];
    if (cell==nil) {
        cell=[[StoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.Delegate=self;
    }
    [cell configCellWithModel:nil];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70.0f;

}

-(void)videorecordButtonDidSelected:(StoryCell*)cell
{
    RecoadListViewController *controller=[[RecoadListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    

}


-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    //判断rootView是有已经有页面，如果有，应为删掉该页面然后在添加新页面
    if (Index==_selectIndex) {
        
    }else{
    switch (Index) {
        case 0:
            [self.view addSubview:self.tableView];
            break;
        case 1:

            break;
        case 2:

            break;
        case 3:

            break;
        default:
            break;
    }
    }

}





@end
