//
//  SDKStartJoinMeetingPresenter+CustomizedUIMeetingDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+CustomizedUIMeetingDelegate.h"
#import "OpenGLViewController.h"
#import "MeetingSettingsViewController.h"

@implementation SDKStartJoinMeetingPresenter (CustomizedUIMeetingDelegate)

- (void)onInitMeetingView
{
    NSLog(@"onInitMeetingView....");
    BOOL enbleRawdataUI = [[NSUserDefaults standardUserDefaults] boolForKey:Raw_Data_UI_Enable];
    
    UIViewController<MobileRTCMeetingServiceDelegate> * vc = nil;
    if (!enbleRawdataUI) {
        vc = [[CustomMeetingViewController alloc] init];
    } else { // RawData for Custom UI
        // Set raw data memory mode, The default is MobileRTCRawDataMemoryModeStack
//        [[MobileRTC sharedRTC] setVideoRawDataMemoryMode:MobileRTCRawDataMemoryModeHeap];
        vc = [[OpenGLViewController alloc] init];
    }
    self.customMeetingVC = vc;
    [self.rootVC addChildViewController:self.customMeetingVC];
    [self.rootVC.view addSubview:self.customMeetingVC.view];
    [self.customMeetingVC didMoveToParentViewController:self.rootVC];
    self.customMeetingVC.view.frame = self.rootVC.view.bounds;
}

- (void)onDestroyMeetingView
{
    NSLog(@"onDestroyMeetingView....");
    
    [self.customMeetingVC willMoveToParentViewController:nil];
    [self.customMeetingVC.view removeFromSuperview];
    [self.customMeetingVC removeFromParentViewController];
    self.customMeetingVC = nil;
}

@end
