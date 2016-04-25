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
        return 20;
    } else {
        return 18;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _topCollection) {
        static NSString * CellIdentifier1 = @"TopCollectionCell";
        TopCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"stop"];
        return cell;
    } else {
        static NSString * CellIdentifier = @"BottomCollectionCell";
        BottomCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"start"];
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PBJViewController *controller = [[PBJViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
