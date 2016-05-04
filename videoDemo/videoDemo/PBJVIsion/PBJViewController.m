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
  UIImageView *starView;
  UILabel *wordLabel;
  UIImageView *auxiliaryView;

  UILabel *timeLabel;

  NSTimer *timer;
  NSInteger lasttime;
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

  //  // press to record gesture
  //  _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
  //  _longPressGestureRecognizer.delegate = self;
  //  _longPressGestureRecognizer.minimumPressDuration = 0.05f;
  //  _longPressGestureRecognizer.allowableMovement = 10.0f;
  //  [_longPressGestureRecognizer
  //      addTarget:self
  //         action:@selector(_handleLongPressGestureRecognizer:)];

//  // gesture view to record
//  UIView *gestureView = [[UIView alloc] initWithFrame:CGRectZero];
//  CGRect gestureFrame = self.view.bounds;
//  gestureFrame.origin = CGPointMake(0, 60.0f);
//  gestureFrame.size.height -= 10.0f;
//  gestureView.frame = gestureFrame;
//  [self.view addSubview:gestureView];
//  [gestureView addGestureRecognizer:_longPressGestureRecognizer];

  // flip button
  _flipButton = [UIButton buttonWithType:UIButtonTypeCustom];

  UIImage *flipImage = [UIImage imageNamed:@"capture_flip"];
  [_flipButton setImage:flipImage forState:UIControlStateNormal];

  CGRect flipFrame = _flipButton.frame;
  flipFrame.size = CGSizeMake(25.0f, 20.0f);
  flipFrame.origin = CGPointMake(20.0f, ScreenHeight - 30.0f);
  _flipButton.frame = flipFrame;

  [_flipButton addTarget:self
                  action:@selector(_handleFlipButton:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_flipButton];

  UIButton *backButton =
      [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 160, 0, 60, 60)];
  [backButton setTitle:@"返回" forState:UIControlStateNormal];
  [self.view addSubview:backButton];
  [backButton addTarget:self
                 action:@selector(back:)
       forControlEvents:UIControlEventTouchUpInside];

  // done button
  _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _doneButton.frame =
      CGRectMake(viewWidth - 20.0f - 20.0f, 20.0f, 20.0f, 20.0f);

  UIImage *buttonImage = [UIImage imageNamed:@"capture_yep"];
  [_doneButton setImage:buttonImage forState:UIControlStateNormal];

  [_doneButton addTarget:self
                  action:@selector(_handleDoneButton:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_doneButton];
  // elapsed time and red dot
  _strobeView = [[PBJStrobeView alloc] initWithFrame:CGRectZero];
  CGRect strobeFrame = _strobeView.frame;
  strobeFrame.origin = CGPointMake(15.0f, 15.0f);
  _strobeView.frame = strobeFrame;
  [self.view addSubview:_strobeView];

  CGFloat width = 300;
  CGFloat height = 300;
  auxiliaryView = [[UIImageView alloc]
      initWithFrame:CGRectMake(ScreenWidth - width - 50, 70, width, height)];
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

  UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [starButton setFrame:CGRectMake(50, 10, 40, 40)];
  [starButton setImage:[UIImage imageNamed:@"star.jpg"]
              forState:UIControlStateNormal];
  [starButton addTarget:self
                 action:@selector(starButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:starButton];

  UIButton *wordButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [wordButton setFrame:CGRectMake(100, 10, 40, 40)];
  [wordButton setImage:[UIImage imageNamed:@"default_image_road"]
              forState:UIControlStateNormal];
  [wordButton addTarget:self
                 action:@selector(wordButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:wordButton];

  UIButton *auxiliaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [auxiliaryButton setFrame:CGRectMake(150, 10, 40, 40)];
  [auxiliaryButton setImage:[UIImage imageNamed:@"star.jpg"]
                   forState:UIControlStateNormal];
  [auxiliaryButton addTarget:self
                      action:@selector(auxiliaryButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:auxiliaryButton];

  starView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.jpg"]];
  starView.contentMode = UIViewContentModeScaleAspectFit;
  [starView setFrame:CGRectMake(20, ScreenHeight - 150, 40, 40)];
  [self.view addSubview:starView];
    timeLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth,
                                          40)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:timeLabel];

    
}

- (void)timeCountdown {
  lasttime--;
  if (lasttime == 0) {
      [timer invalidate];

    [self _endCapture];

  } else {
    timeLabel.text = [NSString stringWithFormat:@"%li:00", (long)lasttime];
  }
}

- (void)auxiliaryButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;
  auxiliaryView.hidden = btn.selected;
}

- (void)starButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;

  starView.hidden = btn.selected;
}

- (void)wordButtonPressed:(UIButton *)btn {
  btn.selected = !btn.selected;

  wordLabel.hidden = btn.selected;
}

#pragma mark - view lifecycle
- (void)back:(UIButton *)btn {
  [timer invalidate];
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
  wordLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(60, 60, 200, ScreenHeight - 60)];
  wordLabel.numberOfLines = 0;
  wordLabel.text = self.videoModel.videoWord;
  wordLabel.textColor = [UIColor blackColor];
  lasttime = self.videoModel.videoTime.integerValue;
  timeLabel.text =
      [NSString stringWithFormat:@"%@:00", self.videoModel.videoTime];
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
  // resets long press
  //  _longPressGestureRecognizer.enabled = NO;
  //  _longPressGestureRecognizer.enabled = YES;
  //    [self _endCapture];

  if (_isrecording) {
    [self _pauseCapture];
      [timer invalidate];
    _isrecording = !_isrecording;
  } else {
    _isrecording = !_isrecording;
      timer = [NSTimer scheduledTimerWithTimeInterval:1
                                      target:self
                                    selector:@selector(timeCountdown)
                                    userInfo:nil
                                     repeats:YES];
    if (!_recording)
      [self _startCapture];
    else
      [self _resumeCapture];
    
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self _resetCapture];
}

#pragma mark - UIGestureRecognizer
//- (void)_handleLongPressGestureRecognizer:
//    (UIGestureRecognizer *)gestureRecognizer {
//    switch (gestureRecognizer.state) {
//      case UIGestureRecognizerStateBegan: {
//        if (!_recording)
//          [self _startCapture];
//        else
//          [self _resumeCapture];
//        break;
//      }
//      case UIGestureRecognizerStateEnded:
//      case UIGestureRecognizerStateCancelled:
//      case UIGestureRecognizerStateFailed: {
//        [self _pauseCapture];
//        break;
//      }
//      default:
//        break;
//    }
//}

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
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Saved!"
                                   message:@"Saved to the camera roll."
                                  delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
    [alert show];
  }
  //  [_assetLibrary
  //      writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath]
  //                         completionBlock:^(NSURL *assetURL, NSError *error1)
  //                         {
  ////                           UIAlertView *alert = [[UIAlertView alloc]
  ////                                   initWithTitle:@"Saved!"
  ////                                         message:@"Saved to the camera
  /// roll."
  ////                                        delegate:self
  ////                               cancelButtonTitle:nil
  ////                               otherButtonTitles:@"OK", nil];
  ////                           [alert show];
  //                         }];
}

@end
