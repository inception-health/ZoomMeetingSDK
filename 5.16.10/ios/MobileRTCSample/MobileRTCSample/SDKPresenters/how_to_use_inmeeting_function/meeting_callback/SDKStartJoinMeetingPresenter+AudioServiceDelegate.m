//
//  SDKStartJoinMeetingPresenter+AudioServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+AudioServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (AudioServiceDelegate)

#pragma mark - Audio Service Delegate

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingAudioStatusChange=%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:userID];
    }
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID audioStatus:(MobileRTC_AudioStatus)audioStatus
{
    NSLog(@"MobileRTC onSinkMeetingAudioStatusChange=%@, audioStatus=%@",@(userID), @(audioStatus));
}

- (void)onSinkMeetingMyAudioTypeChange
{
    NSLog(@"MobileRTC onSinkMeetingMyAudioTypeChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingMyAudioTypeChange];
    }
}

- (void)onSinkMeetingAudioTypeChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingAudioTypeChange:%@",@(userID));
}

- (void)onMyAudioStateChange
{
    NSLog(@"MobileRTC onMyAudioStateChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:0];
    }
}

- (void)onSinkMeetingAudioRequestUnmuteByHost
{
    NSLog(@"MobileRTC onSinkMeetingAudioRequestUnmuteByHost");
}

- (void)onAudioOutputChange
{
    NSLog(@"MobileRTC onAudioOutputChange");
}

@end
