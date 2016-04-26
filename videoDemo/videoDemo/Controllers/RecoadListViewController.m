//
//  RecoadListViewController.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "RecoadListViewController.h"
#import "CollectionViewCell.h"
#import "PBJViewController.h"

@interface RecoadListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *topCollection;
@property (nonatomic,strong) UICollectionView *bottomCollection;
@end

@implementation RecoadListViewController

- (UICollectionView *)topCollection {
    if (!_topCollection) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing=100;

        _topCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 150) collectionViewLayout:flowLayout];
        _topCollection.dataSource=self;
        _topCollection.delegate=self;
        [_topCollection setBackgroundColor:[UIColor clearColor]];
        [_topCollection registerClass:[TopCollectionCell class] forCellWithReuseIdentifier:@"TopCollectionCell"];
        _topCollection.showsHorizontalScrollIndicator = NO;
    }
    return _topCollection;
}

- (UICollectionView *)bottomCollection {
    if (!_bottomCollection) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _bottomCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 210, ScreenWidth, 60) collectionViewLayout:flowLayout];
        _bottomCollection.dataSource=self;
        _bottomCollection.delegate=self;
        [_bottomCollection setBackgroundColor:[UIColor clearColor]];
        [_bottomCollection registerClass:[BottomCollectionCell class] forCellWithReuseIdentifier:@"BottomCollectionCell"];
        _bottomCollection.showsHorizontalScrollIndicator = NO;
    }
    return _bottomCollection;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *materialplistPath = [[NSBundle mainBundle] pathForResource:@"material" ofType:@"plist"];
    NSMutableArray *materialdata = [[NSMutableArray alloc] initWithContentsOfFile:materialplistPath];
    NSString *scriptplistPath = [[NSBundle mainBundle] pathForResource:@"script" ofType:@"plist"];
    NSMutableArray *scriptData = [[NSMutableArray alloc] initWithContentsOfFile:scriptplistPath];
    NSMutableArray *mutArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.datasoure) {
        if ([[dic objectForKey:@"type"] integerValue]==0) {
            for (NSDictionary *materialdic in materialdata) {
                if ([[materialdic objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                    VideoModel *model=[[VideoModel alloc]init];
                    model.vedioID=[materialdic objectForKey:@"id"];
                    model.strURL=[materialdic objectForKey:@"video"];
                    model.strImage=[materialdic objectForKey:@"thumb"];
                    model.vedioType=1;
                    [mutArr addObject:model];
                }
            }
        }else{
            for (NSDictionary *scriptdic in scriptData) {
                if ([[scriptdic objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                    VideoModel *model=[[VideoModel alloc]init];
                    model.vedioID=[scriptdic objectForKey:@"id"];
                    model.strURL=[scriptdic objectForKey:@"video"];
                    model.strImage=[scriptdic objectForKey:@"thumb"];
                    model.vedioType=2;
                    [mutArr addObject:model];
                }
            }

        }
        
        
    }
    VideoModel *model=[[VideoModel alloc]init];
    model.strImage=@"capture_yep";
    [mutArr addObject:model];
    self.datasoure=mutArr;
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.topCollection];
    [self.view addSubview:self.bottomCollection];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNavigationBar];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _topCollection) {
        return self.datasoure.count;
    } else {
        return self.datasoure.count-1;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model=[self.datasoure objectAtIndex:indexPath.item];
    if (collectionView == _topCollection) {
        static NSString * CellIdentifier1 = @"TopCollectionCell";
        TopCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];
        [cell configCellWithModel:model];
        return cell;
    } else {
        static NSString * CellIdentifier = @"BottomCollectionCell";
        BottomCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell configCellWithModel:model];
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _topCollection) {
        return CGSizeMake(100, 100);
    } else {
        return CGSizeMake(50, 50);
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == _topCollection) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item==(self.datasoure.count-1)) {
       //拼接这些视频
    }else{
    PBJViewController *controller = [[PBJViewController alloc] init];
    controller.videoModel=[self.datasoure objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
