//
//  SDKStartJoinMeetingPresenter+WebinarServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+WebinarServiceDelegate.h"

@implementation SDKStartJoinMeetingPresenter (SmartSummary)

- (void)onSmartSummaryStatusChange:(BOOL)isStarted
{
    NSLog(@"onSmartSummaryStatusChange:%@", @(isStarted));
}

- (void)onSmartSummaryPrivilegeRequested:(NSInteger)userId handler:(MobileRTCSmartSummaryPrivilegeHandler *_Nullable)handler
{
    NSLog(@"onSmartSummaryPrivilegeRequested:%@", @(userId));
    [handler decline];
}

- (void)onSmartSummaryStartReqResponse:(BOOL)timeout decline:(BOOL)isDecline
{
    NSLog(@"onSmartSummaryStartReqResponse:%@, decline:%@", @(timeout), @(isDecline));
}

@end
