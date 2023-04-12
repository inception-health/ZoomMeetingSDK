//
//  SDKStartJoinMeetingPresenter+UserServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/30.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+UserServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (UserServiceDelegate)

#pragma mark - User Service Delegate

- (void)onMyHandStateChange
{
    NSLog(@"MobileRTC onMyHandStateChange");
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingUserJoin==%@", @(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingUserJoin:userID];
    }
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingUserLeft==%@", @(userID));
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetingUserInfo *leftUser = [ms userInfoByID:userID];
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingUserLeft:userID];
    }
}

#pragma mark - In meeting users' state updated
- (void)onInMeetingUserUpdated
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *users = [ms getInMeetingUserList];
    NSLog(@"MobileRTC onInMeetingUserUpdated:%@", users);
}

- (void)onInMeetingChat:(NSString *)messageID
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"MobileRTC onInMeetingChat:%@ content:%@", messageID, [ms meetingChatByID:messageID]);
    MobileRTCMeetingChat *chat = [ms meetingChatByID:messageID];
    NSLog(@"MobileRTC MobileRTCMeetingChat-->%@",chat);
}

- (void)onChatMsgDeleteNotification:(NSString *_Nonnull)msgID deleteBy:(MobileRTCChatMessageDeleteType)deleteBy
{
    NSLog(@"MobileRTC onChatMsgDeleteNotification-->%@ deleteBy-->%@",msgID,@(deleteBy));
}

- (void)onSinkUserNameChanged:(NSUInteger)userID userName:(NSString *_Nonnull)userName
{
    NSLog(@"onSinkUserNameChanged:%@ userName:%@", @(userID), userName);
}

- (void)onSinkUserNameChanged:(NSArray <NSNumber *>* _Nullable)userNameChangedArr
{
    NSLog(@"onSinkUserNameChanged:%@", userNameChangedArr);
}

- (void)onSinkMeetingUserRaiseHand:(NSUInteger)userID {
    NSLog(@"MobileRTC onSinkMeetingUserRaiseHand==%@", @(userID));
}

- (void)onSinkMeetingUserLowerHand:(NSUInteger)userID {
    NSLog(@"MobileRTC onSinkMeetingUserLowerHand==%@", @(userID));
}

- (void)onMeetingHostChange:(NSUInteger)hostId {
    NSLog(@"MobileRTC onMeetingHostChange==%@", @(hostId));
}

- (void)onMeetingCoHostChange:(NSUInteger)userID isCoHost:(BOOL)isCoHost {
    NSLog(@"MobileRTC onMeetingCoHostChange==%@ isCoHost===%@", @(userID), @(isCoHost));
}

- (void)onClaimHostResult:(MobileRTCClaimHostError)error
{
    NSLog(@"MobileRTC onClaimHostResult==%@", @(error));
}
@end
