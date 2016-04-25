//
//  AppDelegate.m
//  videoDemo
//
//  Created by SHANPX on 16/4/15.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "AppDelegate.h"
#import "SMAVPlayerViewController.h"
#import "VedioModel.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor clearColor];
    ViewController *viewcontroller=[[ViewController alloc]init];
    SMAVPlayerViewController *playerVC = [[SMAVPlayerViewController alloc] initWithNibName:@"SMAVPlayerViewController" bundle:nil];
    NSMutableArray *arrVedio = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 2; i++) {
        VedioModel *vedioModel = [[VedioModel alloc] init];
        switch (i) {
            case  0:
                vedioModel.strURL = @"http://221.229.165.31:80/play/274CF5C996AFCE2C751D315B5D1BF131B8C08208/298088%5Fstandard.mp4";
                vedioModel.strTitle = @"娲石集团：人品铸产品";
                break;
            case  1:
                vedioModel.strURL = @"http://7xoour.com2.z0.glb.qiniucdn.com/fdbe32614a1167756be2a65721e15c59";
                vedioModel.strTitle = @"精伦电子";
                break;
            case  2:
                vedioModel.strURL = @"http://7xoour.com2.z0.glb.qiniucdn.com/0ca32443a48076a75e6b534b64a4c221";
                vedioModel.strTitle = @"德骼拜尔";
                break;
            default:
                break;
        }
        vedioModel.vedioType = 1;
        vedioModel.strUserID = @"1";
        [arrVedio addObject:vedioModel];
    }
    playerVC.arrVedio = arrVedio;

    UINavigationController *navaController=[[UINavigationController alloc]initWithRootViewController:playerVC];
    self.window.rootViewController=navaController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
