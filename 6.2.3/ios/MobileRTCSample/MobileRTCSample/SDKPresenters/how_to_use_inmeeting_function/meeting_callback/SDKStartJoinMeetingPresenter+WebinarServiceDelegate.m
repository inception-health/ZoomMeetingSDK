//
//  SDKStartJoinMeetingPresenter+WebinarServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+WebinarServiceDelegate.h"

@implementation SDKStartJoinMeetingPresenter (WebinarServiceDelegate)

- (void)onSinkAllowAttendeeChatNotification:(MobileRTCChatAllowAttendeeChat)currentPrivilege
{
    NSLog(@"onSinkAllowAttendeeChatNotification %zd",currentPrivilege);
}

- (void)onSinkQAAllowAskQuestionAnonymouslyNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAskQuestionAnonymouslyNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeViewAllQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeViewAllQuestionNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeUpVoteQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeUpVoteQuestionNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeAnswerQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeAnswerQuestionNotification %@",@(beAllowed));
}

- (void)onSinkPromptAttendee2PanelistResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode
{
    NSLog(@"onSinkPromptAttendee2PanelistResult %@",@(errorCode));
}

- (void)onSinkDePromptPanelist2AttendeeResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode
{
    NSLog(@"onSinkDePromptPanelist2AttendeeResult %@",@(errorCode));
}

- (void)onSinkSelfAllowTalkNotification
{
    NSLog(@"onSinkSelfAllowTalkNotification");
}

- (void)onSinkSelfDisallowTalkNotification
{
    NSLog(@"onSinkSelfDisallowTalkNotification");
}

#if 1
#pragma mark - Webinar Q&A
- (void)onSinkQAConnectStarted
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"Webinar Q&A--onSinkQAConnectStarted QA Enable:%d...", [ms isQAEnabled]);
}

- (void)onSinkQAConnected:(BOOL)connected
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"Webinar Q&A--onSinkQAConnected %d, QA Enable:%d...", connected, [ms isQAEnabled]);
}

- (void)onSinkQAOpenQuestionChanged:(NSInteger)count
{
    NSLog(@"Webinar Q&A--onSinkQAOpenQuestionChanged %zd...", count);
}

#endif

- (void)onSinkAttendeePromoteConfirmResult:(BOOL)agree userId:(NSUInteger)userId
{
    NSLog(@"MobileRTC onSinkAttendeePromoteConfirmResult %d userId=%@", agree, @(userId));
}

@end
