//
//  ViewController.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 16/5/18.
//  Copyright © 2016年 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMeetingViewController.h"
#import "IntroViewController.h"
#import "InviteViewController.h"
#import "SplashViewController.h"
#import "WebViewController.h"

typedef void (^RTCJoinMeetingActionBlock)(NSString * _Nullable, NSString * _Nullable, BOOL);


#define kSDKUserName    @""
#define kSDKUserToken   @""
#define kSDKMeetNumber  @""
#define kZAK @""
//the following parameters are optional, just for login user
#define kCustomerKey  @""
#define kWebinarToken   @""

@interface MainViewController : UIViewController

@property (strong, nonatomic) UIButton * _Nullable meetButton;
@property (strong, nonatomic) UIButton * _Nullable joinButton;

@property (strong, nonatomic) UIButton * _Nullable shareButton;
@property (strong, nonatomic) UIButton * _Nullable expandButton;
@property (strong, nonatomic) UIButton * _Nullable settingButton;

@property (strong, nonatomic) IntroViewController  * _Nullable introVC;
@property (strong, nonatomic) SplashViewController * _Nullable splashVC;
@property (strong, nonatomic) WebViewController    * _Nullable webVC;

@property (assign, nonatomic) BOOL isSharingWebView;

@property (copy, nonatomic) RTCJoinMeetingActionBlock _Nullable  joinMeetingBlock;
- (void)startClockTimer;

@end

