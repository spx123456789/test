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

@interface ViewController ()<AVPlayerViewControllerDelegate>
@property (nonatomic,strong) AVPlayerViewController *avPlayer;
@property(strong, nonatomic) AVPlayer *player;
@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *forwardButton;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSTimer *timer;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.avPlayer.view];
    self.avPlayer.view.frame = self.view.frame;
    
    _startButton = [self createButtonWithImageName:@"start.png" action:@selector(startClick) frame:CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height-70, 60, 60)];
    _backButton = [self createButtonWithImageName:@"back.png" action:@selector(backClick) frame:CGRectMake(_startButton.frame.origin.x-80, _startButton.frame.origin.y, 60, 60)];
    _forwardButton = [self createButtonWithImageName:@"forward.png" action:@selector(forwardClick) frame:CGRectMake(_startButton.frame.origin.x+60+20, _startButton.frame.origin.y, 60, 60)];
    

    [self.view addSubview:_startButton];
    [self.view addSubview:_backButton];
    [self.view addSubview:_forwardButton];
    [self.view addSubview:self.progressView];
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
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"%lld---%lld",time.value , self.player.currentItem.duration.value);
        self.progressView.progress = time.value/self.player.currentItem.duration.value;
    }];
}

- (void)backClick {

}

- (void)forwardClick {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVPlayerViewControllerDelegate
@end
