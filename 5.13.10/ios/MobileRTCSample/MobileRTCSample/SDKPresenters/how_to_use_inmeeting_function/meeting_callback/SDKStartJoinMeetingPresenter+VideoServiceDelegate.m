//
//  SDKStartJoinMeetingPresenter+VideoServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+VideoServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (VideoServiceDelegate)

#pragma mark - Video Service Delegate

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingActiveVideo =>%@", @(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveVideo:userID];
    }
}

- (void)onSinkMeetingPreviewStopped
{
    NSLog(@"MobileRTC onSinkMeetingPreviewStopped");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingPreviewStopped];
    }
}


- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingVideoStatusChange=%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingVideoStatusChange:userID];
    }
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID videoStatus:(MobileRTC_VideoStatus)videoStatus
{
    NSLog(@"MobileRTC onSinkMeetingVideoStatusChange=%@, videoStatus=%@",@(userID), @(videoStatus));
}

- (void)onMyVideoStateChange
{
    NSLog(@"MobileRTC onMyVideoStateChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onMyVideoStateChange];
    }
}

- (void)onSinkMeetingVideoQualityChanged:(MobileRTCNetworkQuality)qality userID:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingVideoQualityChanged: %zd userID:%zd",qality,userID);
}

- (void)onSinkMeetingVideoRequestUnmuteByHost:(void (^)(BOOL Accept))completion
{
    NSLog(@"MobileRTC onSinkMeetingVideoRequestUnmuteByHost");
    if (completion)
    {
        completion(YES);
    }
}

- (void)onHostVideoOrderUpdated:(NSArray <NSNumber *>* _Nullable)orderArr;
{
    NSLog(@"[Video Order] callback onHostVideoOrderUpdated: %@", orderArr);
}

- (void)onLocalVideoOrderUpdated:(NSArray <NSNumber *>* _Nullable)localOrderArr
{
    NSLog(@"[Video Order] callback onLocalVideoOrderUpdated: %@", localOrderArr);
}

- (void)onFollowHostVideoOrderChanged:(BOOL)follow;
{
    NSLog(@"[Video Order] callback onFollowHostVideoOrderChanged: %@", @(follow));
}


@end
