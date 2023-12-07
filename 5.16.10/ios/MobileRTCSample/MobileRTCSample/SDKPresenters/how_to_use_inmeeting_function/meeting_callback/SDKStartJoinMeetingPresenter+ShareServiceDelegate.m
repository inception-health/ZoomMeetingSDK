//
//  SDKStartJoinMeetingPresenter+ShareServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+ShareServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "MainViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (ShareServiceDelegate)

- (void)onSinkSharingStatus:(MobileRTCSharingStatus)status userID:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkSharingStatus==%@ userID==%@", @(status),@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveShare:status userID:userID];
    }
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkShareSizeChange==%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkShareSizeChange:userID];
    }
}

- (void)onAppShareSplash
{
    NSLog(@"MobileRTC onAppShareSplash");
    if (self.mainVC) {
        [self.mainVC onAppShareSplash];
    }
}

- (void)onSinkShareSettingTypeChanged:(MobileRTCShareSettingType)shareSettingType {
    NSLog(@"MobileRTC onSinkShareSettingTypeChanged==%lu", shareSettingType);
}

@end
