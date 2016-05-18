//
//  VedioModel.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "VideoModel.h"
#import "GPUImageFramework.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoModel ()
//@property(nonatomic, strong) NSURL *mixURL;
@property(nonatomic, copy) NSString *videoPath;
//@property(nonatomic, copy) NSString *videoPath2;
//@property(nonatomic, copy) NSURL *theEndVideoURL;
//@property(nonatomic, strong) NSMutableArray *audioMixParams;
//@property(nonatomic, strong) AVAsset *firstAsset;
//@property(nonatomic, strong) AVAsset *secondAsset;
//@property(nonatomic, strong) AVAsset *audioAsset;

@end

@implementation VideoModel
//@synthesize audioMixParams, firstAsset, secondAsset, audioAsset;
+ (void)combineVideo:(NSString *)videourl1 toVideo:(NSString *)videourl2 {
  NSString *urlStr1 = [videourl1
      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *url1 =
      [[NSBundle mainBundle] URLForResource:urlStr1 withExtension:@".mp4"];
  GPUImageMovie *_movieFile = [[GPUImageMovie alloc] initWithURL:url1];

  _movieFile.runBenchmark = YES;
  _movieFile.playAtActualSpeed = NO;
  NSString *urlStr2 = [videourl2
      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *url2 =
      [[NSBundle mainBundle] URLForResource:urlStr2 withExtension:@".mp4"];
  GPUImageMovie *_movieFile2 = [[GPUImageMovie alloc] initWithURL:url2];
  _movieFile2.runBenchmark = YES;
  _movieFile2.playAtActualSpeed = NO;
  GPUImageScreenBlendFilter *_filter = [[GPUImageScreenBlendFilter alloc] init];
  //    filter = [[GPUImageUnsharpMaskFilter alloc] init];
  [_movieFile addTarget:_filter];
  [_movieFile2 addTarget:_filter];
  // Only rotate the video for display, leave orientation the same for recording
  // In addition to displaying to the screen, write out a processed version of
  // the movie to disk
  NSString *pathToMovie =
      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/last.mov"];
  unlink([pathToMovie UTF8String]);  // If a file already exists, AVAssetWriter
                                     // won't let you record new frames, so
                                     // delete the old movie

  NSLog(@"file = %@", pathToMovie);
  NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];

  GPUImageMovieWriter *movieWriter =
      [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL
                                               size:CGSizeMake(640.0, 360.0)];
  [_filter addTarget:movieWriter];
  // Configure this for video from the movie file, where we want to preserve all
  // video frames and audio samples
  movieWriter.shouldPassthroughAudio = YES;
  // movieFile.audioEncodingTarget = self.movieWriter;
  [_movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];

  [movieWriter startRecording];
  [_movieFile startProcessing];
  [_movieFile2 startProcessing];
  __block GPUImageMovie *file1 = _movieFile;
  __block GPUImageMovie *file2 = _movieFile2;
  __block GPUImageScreenBlendFilter *blockfilter = _filter;
  __block GPUImageMovieWriter *blockmovieWriter = movieWriter;

  [movieWriter setCompletionBlock:^{
    [blockfilter removeTarget:blockmovieWriter];
    [file1 endProcessing];
    [file2 endProcessing];
    [blockmovieWriter finishRecording];
    NSLog(@"ok");
  }];
}

+ (void)mergeAndSave:(NSArray *)videos {
  NSMutableArray *videoAssets = [[NSMutableArray alloc] init];
  for (VideoModel *model in videos) {
    if (model.vedioType == 2) {
      NSArray *paths = NSSearchPathForDirectoriesInDomains(
          NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *myPathDocs = [NSString
          stringWithFormat:@"%@/%@", documentsDirectory, model.strURL];
      NSURL *video_url = [NSURL fileURLWithPath:myPathDocs];
      AVAsset *asset = [AVAsset assetWithURL:video_url];
      [videoAssets addObject:asset];
    } else {
      NSURL *video_url = [NSURL
          fileURLWithPath:[[NSBundle mainBundle] pathForResource:model.videoPath
                                                          ofType:@"mp4"]];
      AVAsset *asset = [AVAsset assetWithURL:video_url];
      [videoAssets addObject:asset];
    }
  }

  AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
  AVMutableCompositionTrack *firstTrack = [mixComposition
      addMutableTrackWithMediaType:AVMediaTypeVideo
                  preferredTrackID:kCMPersistentTrackID_Invalid];

  AVAsset *firstAsset = videoAssets[0];
  [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                      ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo]
                                  objectAtIndex:0]
                       atTime:kCMTimeZero
                        error:nil];

  AVAsset *secondAsset = videoAssets[1];

  [firstTrack
      insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
              ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo]
                          objectAtIndex:0]
               atTime:CMTimeSubtract(firstAsset.duration, CMTimeMake(10, 60))
                error:nil];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *dateStr = [NSString stringWithFormat:@"%@.mov", [NSDate date]];
  NSString *myPathDocs =
      [documentsDirectory stringByAppendingPathComponent:dateStr];
  NSURL *url = [NSURL fileURLWithPath:myPathDocs];
  AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
      initWithAsset:mixComposition
         presetName:AVAssetExportPresetHighestQuality];
  exporter.outputURL = url;
  exporter.outputFileType = AVFileTypeQuickTimeMovie;
  exporter.shouldOptimizeForNetworkUse = YES;
  __block NSString *outputURL = dateStr;
  [exporter exportAsynchronouslyWithCompletionHandler:^{
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{

          NSLog(@"%ld", (long)exporter.status);
          if (exporter.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"33333333333333333333333333");
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"combine"
                              object:outputURL];
          }
        });

  }];
  NSLog(@"2222222222222222222222");
}
+ (UIImage *)getImage:(NSURL *)videoURL {
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];

  AVAssetImageGenerator *gen =
      [[AVAssetImageGenerator alloc] initWithAsset:asset];

  gen.appliesPreferredTrackTransform = YES;

  CMTime time = CMTimeMakeWithSeconds(0.0, 600);

  NSError *error = nil;

  CMTime actualTime;

  CGImageRef image =
      [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];

  UIImage *thumb = [[UIImage alloc] initWithCGImage:image];

  CGImageRelease(image);

  return thumb;
}

@end
