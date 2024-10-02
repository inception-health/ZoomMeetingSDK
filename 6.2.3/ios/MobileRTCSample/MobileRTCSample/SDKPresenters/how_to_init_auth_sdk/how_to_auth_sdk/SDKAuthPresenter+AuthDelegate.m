//
//  SDKAuthPresenter+authDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/21.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKAuthPresenter+AuthDelegate.h"
#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCConstants.h>

@implementation SDKAuthPresenter (AuthDelegate)
    
- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue
{
    NSLog(@"MobileRTC onMobileRTCAuthReturn %@", returnValue == 0 ? @"Success" : @(returnValue));
    
    if (returnValue != MobileRTCAuthError_Success)
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"SDK authentication failed, error code: %zd", @""), returnValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:NSLocalizedString(@"Retry", @""), nil];
        [alert show];
    }
//    else {
//        MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];
//        [authService enableAutoRegisterNotificationServiceForLogin:YES];
//        MobileRTCNotificationServiceHelper *notifS = [authService getNotificationServiceHelper];
//        notifS.delegate = self;
//        [notifS getPresenceHelper].delegate = self;
//    }
}

- (void)onMobileRTCLoginResult:(MobileRTCLoginFailReason)resultValue
{
    NSLog(@"MobileRTC onMobileRTCLoginResult result: %@", resultValue == MobileRTCLoginFailReason_Success ? @"Success" : @(resultValue));
    if (resultValue == MobileRTCLoginFailReason_Success) {
        MobileRTCAccountInfo *accoutInfo = [[[MobileRTC sharedRTC] getAuthService] getAccountInfo];
        MobileRTCUserType userType = [[[MobileRTC sharedRTC] getAuthService] getUserType];
        NSLog(@"accoutInfo:%@, User Type:%@", accoutInfo.debugDescription, @(userType));
    }
}

- (void)onMobileRTCLogoutReturn:(NSInteger)returnValue
{
    NSLog(@"MobileRTC onMobileRTCLogoutReturn result=%zd", returnValue);
}



- (void)onMeetingDeviceListChanged:(NSArray<MobileRTCInMeetingDeviceInfo*>*_Nullable)deviceList {
    NSLog(@"---- %s %d",__FUNCTION__,deviceList.count);
    for(MobileRTCInMeetingDeviceInfo*info in deviceList ) {
        NSLog(@"MobileRTCInMeetingDeviceInfo: %@",info.description);
    }
}
- (void)onTransferMeetingStatus:(BOOL)bSuccess {
    NSLog(@"---- %s %ld",__FUNCTION__,bSuccess);
}



- (void)onRequestStarContact:(NSArray <NSString *> *_Nullable)contactIDList {
    NSLog(@"---- %s %@",__FUNCTION__,contactIDList.description);
    MobileRTCPresenceHelper *pHepler = [[[[MobileRTC sharedRTC] getAuthService] getNotificationServiceHelper] getPresenceHelper];
    NSLog(@"[pHepler subscribeContactPresence] :%d",[pHepler subscribeContactPresence:contactIDList]);
    
}


- (void)onRequestContactDetailInfo:(NSArray <MobileRTCContactInfo *> *_Nullable)contactList {
    NSLog(@"---- %s %@",__FUNCTION__,@(contactList.count));
    for(MobileRTCContactInfo *info in contactList) {
        NSLog(@"info:%@ %@  status :%@",info.contactID,info.contactName,@(info.presenceStatus));
    }
}
- (void)onUserPresenceChanged:(NSString *_Nullable)contactID presenceStatus:(MobileRTCPresenceStatus)status {
    NSLog(@"---- %s %@  status: %@",__FUNCTION__,contactID,@(status));
}

- (void)onStarContactListChanged:(NSArray <NSString *> *_Nullable)contactIDList isAdd:(BOOL)add {
    NSLog(@"--%s  %@     %d",__func__,contactIDList.description,@(add));
}

- (void)onReceiveInvitationToMeeting:(MobileRTCInvitationMeetingHandler *_Nullable)handler {
    NSLog(@"--%s  %@     ",__func__,handler);
    NSString *message = [NSString stringWithFormat: @"senderName:%@  meetingNumber:%@  isChannelInvitation:%@  channelName:%@ channelMemberCount：%@", handler.senderName,handler.meetingNumber,@(handler.isChannelInvitation),handler.channelName,@(handler.channelMemberCount)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MobileRTCInvitationMeetingHandler" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *zoomuiAction = [UIAlertAction actionWithTitle:@"accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [handler accept];
    }];
    [alertController addAction:zoomuiAction];
    
    UIAlertAction *customUIAction = [UIAlertAction actionWithTitle:@"decline" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [handler decline];;
    }];
    [alertController addAction:customUIAction];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}


- (void)onMeetingInvitationCanceled:(long long)meetingNumber {
    NSLog(@"--%s  %@     ",__func__,@(meetingNumber));
}
- (void)onMeetingAcceptedByOtherDevice:(long long)meetingNumber {
    NSLog(@"--%s  %@     ",__func__,@(meetingNumber));
}
- (void)onMeetingInvitationDeclined:(NSString *_Nullable)contactID {
    NSLog(@"--%s  %@     ",__func__,contactID);
}
- (void)onMeetingDeclinedByOtherDevice:(long long)meetingNumber {
    NSLog(@"--%s  %@     ",__func__,@(meetingNumber));
}

@end
