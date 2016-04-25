//
//  ViewController.m
//  videoDemo
//
//  Created by SHANPX on 16/4/15.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PBJViewController.h"
#import "menuViewController.h"


#define BUTTON_SPACE 60
#define FRAME_WIDTH self.view.frame.size.width
#define FRAME_HEIGHT self.view.frame.size.height
@interface ViewController ()<AVPlayerViewControllerDelegate>
{
    UIButton *_startButton;
    UIButton *_backButton;
    UIButton *_forwardButton;
    UIButton *_recordButton;
}
@property (nonatomic,strong) AVPlayerViewController *avPlayer;
@property(strong, nonatomic) AVPlayer *player;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSTimer *timer;
@property (strong, nonatomic) id timeObserver;                      //视频播放时间观察者
@property (assign, nonatomic) float totalTime;                      //视频总时长
@property (assign, nonatomic) BOOL isHasMovie;                      //是否进行过移动
@property (assign, nonatomic) BOOL isBottomViewHide;                //底部的view是否隐藏
@property (assign, nonatomic) NSInteger subscript;                  //数组下标，记录当前播放视频
@property (assign, nonatomic) NSInteger currentTime;                //当前视频播放时间位置


@end

@implementation ViewController

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-90, self.view.frame.size.width-20*2, 10)];
    }
    return _progressView;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithURL:[self getNetworkUrl]];
    }
    return _player;
}

-( AVPlayerViewController*)avPlayer{
    if (!_avPlayer) {
        _avPlayer=[[AVPlayerViewController alloc]init];
        _avPlayer.view.translatesAutoresizingMaskIntoConstraints = true;
        _avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _avPlayer.delegate = self;
        _avPlayer.allowsPictureInPicturePlayback = true;    //画中画，iPad可用
        _avPlayer.showsPlaybackControls = false;
        _avPlayer.player = self.player;
        _avPlayer.view.layer.masksToBounds = YES;
        _avPlayer.view.layer.cornerRadius = 8.f;
    }
    return _avPlayer;
}

-(NSURL *)getNetworkUrl{
    return [[NSBundle mainBundle] URLForResource:@"ora_startup_movie" withExtension:@".mp4"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView {
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.avPlayer.view];
    self.avPlayer.view.frame = self.view.frame;
    
    //开始、快进、后退、进度条
    _startButton = [self createButtonWithImageName:@"start.png" action:@selector(startClick) frame:CGRectMake(FRAME_WIDTH/2-30, FRAME_HEIGHT-70, 60, 60)];
    _backButton = [self createButtonWithImageName:@"back.png" action:@selector(backClick) frame:CGRectMake(_startButton.frame.origin.x-60-BUTTON_SPACE, _startButton.frame.origin.y, 60, 60)];
    _forwardButton = [self createButtonWithImageName:@"forward.png" action:@selector(forwardClick) frame:CGRectMake(_startButton.frame.origin.x+60+BUTTON_SPACE, _startButton.frame.origin.y, 60, 60)];
    
    [self.view addSubview:_startButton];
    [self.view addSubview:_backButton];
    [self.view addSubview:_forwardButton];
    [self.view addSubview:self.progressView];
    
    //录制按钮
    _recordButton = [self createButtonWithImageName:@"record.png" action:@selector(recordClick) frame:CGRectMake(FRAME_WIDTH-70, 20, 60, 60) ];
    [self.view addSubview:_recordButton];
}

- (UIButton *)createButtonWithImageName:(NSString *)imageName action:(SEL)action frame:(CGRect)frame {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)startClick {
    if (self.player.rate == 0.0) {
        [self.player play];
        [_startButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [_startButton setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.progressView.progress = CMTimeGetSeconds(time)/CMTimeGetSeconds(weakSelf.player.currentItem.duration);
    }];
}
- (void)videoSlierChangeValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value change:%f",slider.value);
    
    if (slider.value == 0.000000) {
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.player play];
        }];
    }
}
- (void)videoSlierChangeValueEnd:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value end:%f",slider.value);
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [weakSelf.player play];
//        [weakSelf.stateButton setTitle:@"Stop" forState:UIControlStateNormal];
    }];
}
- (void)customVideoSlider:(CMTime)duration {
//    self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
//    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
//    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
//    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}


- (void)backClick {
}

- (void)forwardClick {

}

- (void)recordClick {
    
//    menuViewController *menu=[[menuViewController alloc]init];
    
    PBJViewController *controller = [[PBJViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - AVPlayerViewControllerDelegate
@end
