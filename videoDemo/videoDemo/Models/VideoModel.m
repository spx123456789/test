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
@property(nonatomic, strong) NSURL *mixURL;
@property(nonatomic, copy) NSString *videoPath;
@property(nonatomic, copy) NSString *videoPath2;
@property(nonatomic, copy) NSURL *theEndVideoURL;
@property(nonatomic, strong) NSMutableArray *audioMixParams;
@property(nonatomic, strong) AVAsset *firstAsset;
@property(nonatomic, strong) AVAsset *secondAsset;
@property(nonatomic, strong) AVAsset *audioAsset;

@end

@implementation VideoModel
@synthesize audioMixParams, firstAsset, secondAsset, audioAsset;
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

+ (void)mergeAndSave:(NSArray *)videos
            callback:(void (^)(BOOL isSucceed, NSString *videoUrl))block {
  NSMutableArray *videoAssets = [[NSMutableArray alloc] init];
  for (VideoModel *model in videos) {
    if (model.vedioType == 2) {
      NSArray *paths = NSSearchPathForDirectoriesInDomains(
          NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *myPathDocs = [documentsDirectory
          stringByAppendingPathComponent:
              [NSString stringWithFormat:@"%@", model.videoPath]];
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
  // 2 - Video track
  AVMutableCompositionTrack *firstTrack = [mixComposition
      addMutableTrackWithMediaType:AVMediaTypeVideo
                  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAsset * tmpAVAsset;
    int count=0;
    CMTime *timer;
    for (AVAsset *asset in videoAssets) {
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo]
                                     objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        
    }
  
  [firstTrack
      insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
              ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo]
                          objectAtIndex:0]
               atTime:CMTimeSubtract(firstAsset.duration, CMTimeMake(10, 60))
                error:nil];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *myPathDocs = [documentsDirectory
      stringByAppendingPathComponent:[NSString
                                         stringWithFormat:@"mergeVideo-%d.mov",
                                                          arc4random() % 1000]];
  NSURL *url = [NSURL fileURLWithPath:myPathDocs];
  // 5 - Create exporter
  AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
      initWithAsset:mixComposition
         presetName:AVAssetExportPresetHighestQuality];
  exporter.outputURL = url;
  exporter.outputFileType = AVFileTypeQuickTimeMovie;
  exporter.shouldOptimizeForNetworkUse = YES;
  [exporter exportAsynchronouslyWithCompletionHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self exportDidFinish:exporter];
    });
  }];
}
- (void)exportDidFinish:(AVAssetExportSession *)session {
  if (session.status == AVAssetExportSessionStatusCompleted) {
    NSURL *outputURL = session.outputURL;
  }
}

@end
