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
#import "SMAVPlayerViewController.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"

#define TOP_CELL_WIDTH 200
#define TOP_CELL_LINE_SPACE 80

#define BOTTOM_CELL_WIDTH 50
@interface RecoadListViewController ()<UICollectionViewDelegate,
                                       UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *topCollection;
@property(nonatomic, strong) UICollectionView *bottomCollection;
@property (nonatomic,strong) NSMutableArray *videos;

@end

@implementation RecoadListViewController

- (UICollectionView *)topCollection {
  if (!_topCollection) {
    UICollectionViewFlowLayout *flowLayout =
        [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = TOP_CELL_LINE_SPACE;

    _topCollection = [[UICollectionView alloc]
               initWithFrame:CGRectMake(0, 20, ScreenWidth, 240)
        collectionViewLayout:flowLayout];
    _topCollection.dataSource = self;
    _topCollection.delegate = self;
    [_topCollection setBackgroundColor:[UIColor clearColor]];
    [_topCollection registerClass:[TopCollectionCell class]
        forCellWithReuseIdentifier:@"TopCollectionCell"];
    _topCollection.showsHorizontalScrollIndicator = NO;
  }
  return _topCollection;
}

- (UICollectionView *)bottomCollection {
  if (!_bottomCollection) {
    UICollectionViewFlowLayout *flowLayout =
        [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _bottomCollection = [[UICollectionView alloc]
               initWithFrame:CGRectMake(0, 260, ScreenWidth, 60)
        collectionViewLayout:flowLayout];
    _bottomCollection.dataSource = self;
    _bottomCollection.delegate = self;
    [_bottomCollection setBackgroundColor:[UIColor clearColor]];
    [_bottomCollection registerClass:[BottomCollectionCell class]
          forCellWithReuseIdentifier:@"BottomCollectionCell"];
    _bottomCollection.showsHorizontalScrollIndicator = NO;
  }
  return _bottomCollection;
}
- (void)viewDidLoad {
  [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(combine:) name:@"combine" object:nil];
   self.view.layer.cornerRadius = CornerRadius;
  NSString *materialplistPath =
      [[NSBundle mainBundle] pathForResource:@"material" ofType:@"plist"];
  NSMutableArray *materialdata =
      [[NSMutableArray alloc] initWithContentsOfFile:materialplistPath];
  NSString *scriptplistPath =
      [[NSBundle mainBundle] pathForResource:@"script" ofType:@"plist"];
  NSMutableArray *scriptData =
      [[NSMutableArray alloc] initWithContentsOfFile:scriptplistPath];
  NSMutableArray *mutArr = [[NSMutableArray alloc] init];
  for (NSDictionary *dic in self.datasoure) {
    if ([[dic objectForKey:@"type"] integerValue] == 0) {
      for (NSDictionary *materialdic in materialdata) {
        if ([[materialdic objectForKey:@"id"]
                isEqualToString:[dic objectForKey:@"id"]]) {
          VideoModel *model = [[VideoModel alloc] init];
          model.vedioID = [materialdic objectForKey:@"id"];
          model.strURL = [materialdic objectForKey:@"video"];
          model.strImage = [materialdic objectForKey:@"thumb"];
          model.vedioType = 1;
          [mutArr addObject:model];
        }
      }
    } else {
      for (NSDictionary *scriptdic in scriptData) {
        if ([[scriptdic objectForKey:@"id"]
                isEqualToString:[dic objectForKey:@"id"]]) {
          VideoModel *model = [[VideoModel alloc] init];
          model.vedioID = [scriptdic objectForKey:@"id"];
          model.strURL = [scriptdic objectForKey:@"video"];
          model.strImage = [scriptdic objectForKey:@"thumb"];
          model.vedioType = 2;
          model.videoWord = [scriptdic objectForKey:@"word"];
          model.videoTime = [scriptdic objectForKey:@"time"];

          [mutArr addObject:model];
        }
      }
    }
  }
  VideoModel *model = [[VideoModel alloc] init];
  model.strImage = @"capture_yep";
  [mutArr addObject:model];
  self.datasoure = mutArr;
  UIButton *backButton =
      [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, 0, 30, 30)];
  [backButton setBackgroundImage:[UIImage imageNamed:@"return"]
              forState:UIControlStateNormal];
  [self.view addSubview:backButton];
  [backButton addTarget:self
                 action:@selector(playButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.topCollection];
  [self.view addSubview:self.bottomCollection];
}
- (void)playButtonPressed:(UIButton *)btn {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark-- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (collectionView == _topCollection) {
    return self.datasoure.count - 1;
  } else {
    return self.datasoure.count;
  }
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  VideoModel *model = [self.datasoure objectAtIndex:indexPath.item];
  if (collectionView == _topCollection) {
    static NSString *CellIdentifier1 = @"TopCollectionCell";
    TopCollectionCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1
                                                  forIndexPath:indexPath];
    [cell configCellWithModel:model];
    return cell;
  } else {
    static NSString *CellIdentifier = @"BottomCollectionCell";
    BottomCollectionCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                  forIndexPath:indexPath];
    [cell configCellWithModel:model];
    return cell;
  }
}

#pragma mark--UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView == _topCollection) {
    return CGSizeMake(TOP_CELL_WIDTH, TOP_CELL_WIDTH);
  } else {
    return CGSizeMake(BOTTOM_CELL_WIDTH, BOTTOM_CELL_WIDTH);
  }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  if (collectionView == _topCollection) {
    return UIEdgeInsetsMake(5, 5, 5, 5);
  } else {
    return UIEdgeInsetsMake(5, 5, 5, 5);
  }
}

-(void)combine:(NSNotification *)obj
{
    NSLog(@"11111111111111111111111111111%lu",(unsigned long)_videos.count);

    if (_videos.count==1) {
        [SVProgressHUD dismiss];
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString*path=[paths  objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"story.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *array;
        if (![fileManager fileExistsAtPath:filename]) {
            array =[[NSMutableArray alloc]init];
        }else{
        array=[[NSMutableArray alloc]initWithContentsOfFile:filename];
        }
        [array addObject:obj.object];
        [array writeToFile:filename atomically:YES];
    }else{
        if (!obj.object) {
            NSArray *videos=[NSArray arrayWithObjects:_videos[0],_videos[1], nil];
            [_videos removeObjectAtIndex:0];
            [_videos removeObjectAtIndex:0];
            [VideoModel mergeAndSave:videos];
        }else{
            VideoModel *model=[[VideoModel alloc]init];
            model.strURL=obj.object;
            model.vedioType=2;
            NSArray *videos=[NSArray arrayWithObjects:model,_videos[0], nil];
            [_videos removeObjectAtIndex:0];
            [VideoModel mergeAndSave:videos];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _topCollection) {
        VideoModel *model = [self.datasoure objectAtIndex:indexPath.item];
        if (model.vedioType == 1) {
            //预制视频
            SMAVPlayerViewController *playerVC = [[SMAVPlayerViewController alloc]
                                                  initWithNibName:@"SMAVPlayerViewController"
                                                  bundle:nil];
            NSMutableArray *arrVedio = [NSMutableArray array];
            VideoModel *vedioModel = [[VideoModel alloc] init];
            vedioModel.strURL = model.strURL;
            vedioModel.vedioType = 1;
            vedioModel.strUserID = @"1";
            [arrVedio addObject:vedioModel];
            playerVC.arrVedio = arrVedio;
            [self presentViewController:playerVC animated:YES completion:nil];
        } else {
            PBJViewController *controller = [[PBJViewController alloc] init];
            controller.videoModel = model;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else
    {
        BOOL isComplete=YES;
        if (indexPath.item == (self.datasoure.count - 1)) {
            //拼接这些视频
            _videos=[NSMutableArray arrayWithArray:self.datasoure];
            for (int i=0; i<7;i++ ) {
                VideoModel *vedioModel=_videos[i];
                if (!vedioModel.strURL) {
                    isComplete=NO;
                    break;
                }
            }
            if (isComplete) {
                [SVProgressHUD showWithStatus:@"合成中。。。"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"combine" object:nil];
                
            }else{
                UIAlertView *aleart=[[UIAlertView alloc]initWithTitle:@"还有未录制的视频，请录制" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil, nil];
                [aleart show];
            }
        }else{
            NSInteger offset = (TOP_CELL_WIDTH + TOP_CELL_LINE_SPACE)*indexPath.item - (ScreenWidth - TOP_CELL_WIDTH)/2;
            if (offset > 0) {
                [_topCollection setContentOffset:CGPointMake(offset, 0) animated:YES];
            }else{
                [_topCollection setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
