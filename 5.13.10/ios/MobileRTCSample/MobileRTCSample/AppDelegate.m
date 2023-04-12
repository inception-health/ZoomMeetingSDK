//
//  AppDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 3/17/14.
//  Copyright (c) 2014 Zoom Video Communications, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SDKInitPresenter.h"
#import "BaseNavigationController.h"
#import "SDKAuthPresenter+Login.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", paths[0]);
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    navVC.navigationBarHidden = YES;
    
    self.window.rootViewController = navVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // SDK init
    [SDKInitPresenter SDKInit:navVC];
    
    // MobileRTC Authorize
    self.authPresenter = [[SDKAuthPresenter alloc] init];
    [self.authPresenter SDKAuth:KjwtToken];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[MobileRTC sharedRTC] appWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[MobileRTC sharedRTC] appDidEnterBackgroud];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[MobileRTC sharedRTC] appDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[MobileRTC sharedRTC] appWillTerminate];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:<#Your URL scheme#>] && [self isSSOLoginURL:url]) {
        [self.authPresenter ssoLoginWithWebUriProtocol:url.absoluteString];
    } else {
        [[[MobileRTC sharedRTC] getMeetingService] handZoomWebUrl:url.absoluteString];
    }
    
    return YES;
}

- (BOOL)isSSOLoginURL:(NSURL *)url
{
    BOOL isSSOLogin = NO;
    
    NSString *urlString = [url absoluteString];
    
    NSRange range = [urlString rangeOfString:@"sso?"];
    
    if(range.location != NSNotFound)
    {
        isSSOLogin = YES;
    }
    
    return isSSOLogin;
}

- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
