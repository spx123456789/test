//
//  PBJViewController.m
//  Vision
//
//  Created by Patrick Piemonte on 7/23/13.
//  Copyright (c) 2013 Patrick Piemonte. All rights reserved.
//

#import "PBJViewController.h"
#import "PBJVision.h"
#import "PBJStrobeView.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface UIButton (ExtendedHit)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end

@implementation UIButton (ExtendedHit)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  CGRect relativeFrame = self.bounds;
  UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-35, -35, -35, -35);
  CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
  return CGRectContainsPoint(hitFrame, point);
}

@end

@interface PBJViewController ()<UIGestureRecognizerDelegate, PBJVisionDelegate,
                                UIAlertViewDelegate> {
  PBJStrobeView *_strobeView;
  UIButton *_doneButton;
  UIButton *_flipButton;

  UIView *_previewView;
  AVCaptureVideoPreviewLayer *_previewLayer;

  UILongPressGestureRecognizer *_longPressGestureRecognizer;
  BOOL _recording;
  BOOL _isrecording;
  ALAssetsLibrary *_assetLibrary;
  __block NSDictionary *_currentVideo;
  UIImageView *eyeView;
  UILabel *wordLabel;
  UIImageView *auxiliaryView;

  UILabel *timeLabel;

  NSTimer *timer;
  NSInteger lasttime;
  NSTimer *blinktimer;
}

@end

@implementation PBJViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    [self _setup];
  }
  return self;
}

- (void)dealloc {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  _longPressGestureRecognizer.delegate = nil;
}

- (void)_setup {
  self.view.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  CGFloat viewWidth = CGRectGetWidth(self.view.frame);
  CGFloat viewHeigth = CGRectGetHeight(self.view.frame);
  // preview
  _previewView = [[UIView alloc] initWithFrame:CGRectZero];
  _previewView.backgroundColor = [UIColor blackColor];
  CGRect previewFrame = CGRectZero;
  previewFrame.origin = CGPointMake(0, 0);
  CGFloat previewWidth = self.view.frame.size.width;
  previewFrame.size = CGSizeMake(previewWidth, self.view.frame.size.height);
  _previewView.frame = previewFrame;

  // add AV layer
  _previewLayer = [[PBJVision sharedInstance] previewLayer];
  CGRect previewBounds = _previewView.layer.bounds;
  _previewLayer.bounds =
      CGRectMake(0, 0, previewBounds.size.height, previewBounds.size.width);
  _previewLayer.affineTransform = CGAffineTransformMakeRotation(-M_PI / 2);
  _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  _previewLayer.position =
      CGPointMake(CGRectGetMidX(previewBounds), CGRectGetMidY(previewBounds));
  [_previewView.layer addSublayer:_previewLayer];
  [self.view addSubview:_previewView];
  [self overlayClipping];

  UIButton *backButton =
      [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 0, 30, 30)];
  [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"]
                        forState:UIControlStateNormal];
  [self.view addSubview:backButton];
  [backButton addTarget:self
                 action:@selector(back:)
       forControlEvents:UIControlEventTouchUpInside];

  // done button
  _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _doneButton.frame =
      CGRectMake(viewWidth - 60.0f, viewHeigth - 60.0f, 40.0f, 40.0f);
  //    UIImage *buttonImage = [UIImage imageNamed:@"capture_yep"];
  //    [_doneButton setImage:buttonImage forState:UIControlStateNormal];
  _doneButton.layer.cornerRadius = 20;
  _doneButton.clipsToBounds = YES;
  [_doneButton setBackgroundColor:[UIColor redColor]];
  [_doneButton addTarget:self
                  action:@selector(_handleDoneButton:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_doneButton];

  // elapsed time and red dot
  _strobeView = [[PBJStrobeView alloc] initWithFrame:CGRectZero];
  CGRect strobeFrame = _strobeView.frame;
  strobeFrame.origin = CGPointMake(15.0f, 15.0f);
  _strobeView.frame = strobeFrame;
  //    [self.view addSubview:_strobeView];
  CGFloat width = 300;
  CGFloat height = 300;
  auxiliaryView = [[UIImageView alloc]
      initWithFrame:CGRectMake(ScreenWidth - width - 50, 30, width, height)];
  UIImageView *imgView1 =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [auxiliaryView addSubview:imgView1];
  imgView1.contentMode = UIViewContentModeTopLeft;
  imgView1.image = [UIImage imageNamed:@"ic_border_topleft"];

  UIImageView *imgView2 =
      [[UIImageView alloc] initWithFrame:CGRectMake(width - 44, 0, 44, 44)];
  [auxiliaryView addSubview:imgView2];
  imgView2.contentMode = UIViewContentModeTopRight;
  imgView2.image = [UIImage imageNamed:@"ic_border_topright"];

  UIImageView *imgView3 =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, height - 44, 44, 44)];
  [auxiliaryView addSubview:imgView3];
  imgView3.contentMode = UIViewContentModeBottomLeft;
  imgView3.image = [UIImage imageNamed:@"ic_border_bottomleft"];

  UIImageView *imgView4 = [[UIImageView alloc]
      initWithFrame:CGRectMake(width - 44, height - 44, 44, 44)];
  [auxiliaryView addSubview:imgView4];
  imgView4.contentMode = UIViewContentModeBottomRight;
  imgView4.image = [UIImage imageNamed:@"ic_border_bottomright"];
  [self.view addSubview:auxiliaryView];
  UILabel *PromptLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(ScreenWidth - width - 50, 330, width, 20)];
  PromptLabel.textAlignment = NSTextAlignmentCenter;
  PromptLabel.text = @"请保持脸在框中";
  [self.view addSubview:PromptLabel];
  UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [eyeButton setFrame:CGRectMake(0, 10, 40, 40)];
  [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye"]
                       forState:UIControlStateNormal];
  [eyeButton addTarget:self
                action:@selector(eyeButtonPressed:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:eyeButton];

  UIButton *wordButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [wordButton setFrame:CGRectMake(50, 10, 40, 40)];
  [wordButton setBackgroundImage:[UIImage imageNamed:@"script"]
                        forState:UIControlStateNormal];
  [wordButton addTarget:self
                 action:@selector(wordButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:wordButton];

  UIButton *auxiliaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [auxiliaryButton setFrame:CGRectMake(100, 10, 40, 40)];
  [auxiliaryButton setBackgroundImage:[UIImage imageNamed:@"time"]
                             forState:UIControlStateNormal];
  [auxiliaryButton addTarget:self
                      action:@selector(auxiliaryButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:auxiliaryButton];

  eyeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye"]];
  eyeView.contentMode = UIViewContentModeScaleAspectFit;
  [eyeView setFrame:CGRectMake(20, ScreenHeight - 120, 20, 20)];
  [self.view addSubview:eyeView];

  wordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(60, 60, 200, ScreenHeight - 60)];

  timeLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(20, ScreenHeight - 180, 30, 30)];
    timeLabel.layer.cornerRadius = 15;
    timeLabel.clipsToBounds = YES;
  timeLabel.textAlignment = NSTextAlignmentCenter;
  timeLabel.tag = 1;

  [self.view addSubview:timeLabel];
}

- (void)colorBlink {
  if (timeLabel.tag == 0) {
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.tag = 1;
  } else {
    timeLabel.tag = 0;
    timeLabel.backgroundColor = [UIColor greenColor];
  }
}
- (void)timeCountdown {
  lasttime--;
  if (lasttime == 0) {
    [timer invalidate];
    [blinktimer invalidate];
    timeLabel.text = [NSString stringWithFormat:@"%li'", (long)lasttime];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.tag = 1;
    [self _endCapture];

  } else {
    timeLabel.text = [NSString stringWithFormat:@"%li'", (long)lasttime];
  }
}

- (void)auxiliaryButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;
  timeLabel.hidden = btn.selected;
}

- (void)eyeButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;

  eyeView.hidden = btn.selected;
}

- (void)wordButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;

  wordLabel.hidden = btn.selected;
}

#pragma mark - view lifecycle
- (void)back:(UIButton *)btn {
  [timer invalidate];
  [blinktimer invalidate];

  [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.layer.cornerRadius = 20;
  self.view.clipsToBounds = YES;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  wordLabel.numberOfLines = 0;
  wordLabel.text = self.videoModel.videoWord;
  wordLabel.textColor = [UIColor blackColor];

  lasttime = self.videoModel.videoTime.integerValue;
  timeLabel.text =
      [NSString stringWithFormat:@"%@'", self.videoModel.videoTime];
  [self.view addSubview:wordLabel];

  [self _resetCapture];
  [[PBJVision sharedInstance] startPreview];
}
- (BOOL)prefersStatusBarHidden {
  return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[PBJVision sharedInstance] stopPreview];
}

#pragma mark - private start/stop helper methods

- (void)_startCapture {
  [UIApplication sharedApplication].idleTimerDisabled = YES;

  [[PBJVision sharedInstance] startVideoCapture];
}

- (void)_pauseCapture {
  [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)_resumeCapture {
  [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)_endCapture {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  [[PBJVision sharedInstance] endVideoCapture];
}

- (void)_resetCapture {
  [_strobeView stop];
  _longPressGestureRecognizer.enabled = YES;

  PBJVision *vision = [PBJVision sharedInstance];
  vision.delegate = self;
  [vision setCameraMode:PBJCameraModeVideo];
  [vision setCameraDevice:PBJCameraDeviceFront];
  [vision setCameraOrientation:PBJCameraOrientationLandscapeRight];
  [vision setFocusMode:PBJFocusModeAutoFocus];
}

#pragma mark - UIButton

- (void)_handleFlipButton:(UIButton *)button {
  PBJVision *vision = [PBJVision sharedInstance];
  if (vision.cameraDevice == PBJCameraDeviceBack) {
    [vision setCameraDevice:PBJCameraDeviceFront];
  } else {
    [vision setCameraDevice:PBJCameraDeviceBack];
  }
}

- (void)_handleDoneButton:(UIButton *)button {
  if (_isrecording) {
    [self _pauseCapture];
    [timer invalidate];
    [blinktimer invalidate];
    _isrecording = !_isrecording;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.tag = 1;
  } else {
    _isrecording = !_isrecording;
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timeCountdown)
                                           userInfo:nil
                                            repeats:YES];
    blinktimer = [NSTimer scheduledTimerWithTimeInterval:.5
                                                  target:self
                                                selector:@selector(colorBlink)
                                                userInfo:nil
                                                 repeats:YES];
    if (!_recording)
      [self _startCapture];
    else
      [self _resumeCapture];
  }
  _doneButton.hidden = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self _resetCapture];
  [timer invalidate];
  [blinktimer invalidate];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizer
- (void)overlayClipping {
  CGFloat height = 300;
  CGFloat width = 300;
  UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:overlayView];
  overlayView.backgroundColor = [UIColor grayColor];
  overlayView.alpha = .3f;
  auxiliaryView = [[UIImageView alloc]
      initWithFrame:CGRectMake(ScreenWidth - width - 50, 30, width, height)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  CGMutablePathRef path = CGPathCreateMutable();
  // Left side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0, 0, auxiliaryView.frame.origin.x,
                                      self.view.frame.size.height));
  // Right side of the ratio view
  CGPathAddRect(
      path, nil,
      CGRectMake(auxiliaryView.frame.origin.x + auxiliaryView.frame.size.width,
                 0, self.view.frame.size.width - auxiliaryView.frame.origin.x -
                        auxiliaryView.frame.size.width,
                 self.view.frame.size.height));
  // Top side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0, 0, self.view.frame.size.width,
                                      auxiliaryView.frame.origin.y));
  // Bottom side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0, auxiliaryView.frame.origin.y +
                                             auxiliaryView.frame.size.height,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height -
                                          auxiliaryView.frame.origin.y +
                                          auxiliaryView.frame.size.height));
  maskLayer.path = path;
  overlayView.layer.mask = maskLayer;
  CGPathRelease(path);
}

#pragma mark - PBJVisionDelegate

- (void)visionSessionWillStart:(PBJVision *)vision {
}

- (void)visionSessionDidStart:(PBJVision *)vision {
}

- (void)visionSessionDidStop:(PBJVision *)vision {
}

- (void)visionPreviewDidStart:(PBJVision *)vision {
  _longPressGestureRecognizer.enabled = YES;
}

- (void)visionPreviewWillStop:(PBJVision *)vision {
  _longPressGestureRecognizer.enabled = NO;
}

- (void)visionModeWillChange:(PBJVision *)vision {
}

- (void)visionModeDidChange:(PBJVision *)vision {
}

- (void)vision:(PBJVision *)vision
    cleanApertureDidChange:(CGRect)cleanAperture {
}

- (void)visionWillStartFocus:(PBJVision *)vision {
}

- (void)visionDidStopFocus:(PBJVision *)vision {
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision {
  [_strobeView start];
  _recording = YES;
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision {
  [_strobeView stop];
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision {
  [_strobeView start];
}

- (void)vision:(PBJVision *)vision
 capturedVideo:(NSDictionary *)videoDict
         error:(NSError *)error {
  _recording = NO;

  if (error) {
    NSLog(@"encounted an error in video capture (%@)", error);
    return;
  }

  _currentVideo = videoDict;

  NSString *videoPath = [_currentVideo objectForKey:PBJVisionVideoPathKey];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *strurl = [NSString stringWithFormat:@"%@.mov", [NSDate date]];
  NSString *toPath =
      [NSString stringWithFormat:@"%@/%@", documentsDirectory, strurl];
  _videoModel.strURL = strurl;

  BOOL isSuccess =
      [fileManager moveItemAtPath:videoPath toPath:toPath error:&error];
  if (isSuccess) {
    _videoModel.videoImage =
        [VideoModel getImage:[NSURL fileURLWithPath:toPath]];
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Saved!"
                                   message:@"Saved to the camera roll."
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
    [alert show];
  }
}

@end
