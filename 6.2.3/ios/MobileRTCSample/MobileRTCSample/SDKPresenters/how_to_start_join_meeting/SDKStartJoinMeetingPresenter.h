//
//  SDKStartJoinMeetingPresenter.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/15.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "CustomMeetingViewController.h"

@interface SDKStartJoinMeetingPresenter : NSObject 

- (void)startMeeting:(BOOL)appShare rootVC:(UIViewController *)rootVC;

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd rootVC:(UIViewController *)rootVC;

@property (strong, nonatomic) UIViewController *rootVC;

@property (strong, nonatomic) UIViewController<MobileRTCMeetingServiceDelegate> *customMeetingVC;

@property (strong, nonatomic) MainViewController *mainVC;


@end

