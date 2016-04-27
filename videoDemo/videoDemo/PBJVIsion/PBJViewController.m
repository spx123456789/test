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

  ALAssetsLibrary *_assetLibrary;
  __block NSDictionary *_currentVideo;
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

  // press to record gesture
  _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
  _longPressGestureRecognizer.delegate = self;
  _longPressGestureRecognizer.minimumPressDuration = 0.05f;
  _longPressGestureRecognizer.allowableMovement = 10.0f;
  [_longPressGestureRecognizer
      addTarget:self
         action:@selector(_handleLongPressGestureRecognizer:)];

  // gesture view to record
  UIView *gestureView = [[UIView alloc] initWithFrame:CGRectZero];
  CGRect gestureFrame = self.view.bounds;
  gestureFrame.origin = CGPointMake(0, 60.0f);
  gestureFrame.size.height -= 10.0f;
  gestureView.frame = gestureFrame;
  [self.view addSubview:gestureView];
  [gestureView addGestureRecognizer:_longPressGestureRecognizer];

  // flip button
  _flipButton = [UIButton buttonWithType:UIButtonTypeCustom];

  UIImage *flipImage = [UIImage imageNamed:@"capture_flip"];
  [_flipButton setImage:flipImage forState:UIControlStateNormal];

  CGRect flipFrame = _flipButton.frame;
  flipFrame.size = CGSizeMake(25.0f, 20.0f);
  flipFrame.origin =
      CGPointMake(20.0f, ScreenHeight - 30.0f);
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
}

#pragma mark - view lifecycle
- (void)back:(UIButton *)btn {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];

  [self _resetCapture];
  [[PBJVision sharedInstance] startPreview];
  UILabel *label = [[UILabel alloc]
      initWithFrame:CGRectMake(60, 60, 200, ScreenHeight - 60)];
  label.numberOfLines = 0;
  label.text = self.videoModel.videoWord;
  label.textColor = [UIColor blackColor];
  [self.view addSubview:label];
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
  [vision setCameraDevice:PBJCameraDeviceBack];
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
  _longPressGestureRecognizer.enabled = NO;
  _longPressGestureRecognizer.enabled = YES;

  [self _endCapture];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self _resetCapture];
}

#pragma mark - UIGestureRecognizer

- (void)_handleLongPressGestureRecognizer:
    (UIGestureRecognizer *)gestureRecognizer {
  switch (gestureRecognizer.state) {
    case UIGestureRecognizerStateBegan: {
      if (!_recording)
        [self _startCapture];
      else
        [self _resumeCapture];
      break;
    }
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateFailed: {
      [self _pauseCapture];
      break;
    }
    default:
      break;
  }
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
  [_assetLibrary
      writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath]
                         completionBlock:^(NSURL *assetURL, NSError *error1) {
                           UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"Saved!"
                                         message:@"Saved to the camera roll."
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"OK", nil];
                           [alert show];
                         }];
}

@end
