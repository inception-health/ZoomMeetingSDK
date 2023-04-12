//
//  SDKStartJoinMeetingPresenter+MeetingServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/21.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+MeetingServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "MainViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (MeetingServiceDelegate)

#pragma mark - Meeting Service Delegate

- (void)onJoinMeetingConfirmed
{
    NSString *meetingNo = [[MobileRTCInviteHelper sharedInstance] ongoingMeetingNumber];
//    NSString *meetingPsw = [[[MobileRTC sharedRTC] getMeetingService] getMeetingPassword];
    NSLog(@"MobileRTC onJoinMeetingConfirmed MeetingNo: %@", meetingNo);
}

- (void)onJoinMeetingInfo:(MobileRTCJoinMeetingInfo)info
               completion:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion
{
    if (self.mainVC) {
        [self.mainVC onJoinMeetingInfo:info completion:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion];
    }
}

#pragma mark -- For CustomUI Meeting
- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onWaitingRoomStatusChange:needWaiting];
    }
}

- (void)onSinkWebinarNeedRegister:(NSString *)registerURL
{
    NSLog(@"MobileRTC onSinkWebinarNeedRegister %@",registerURL);
}

- (void)onSinkJoinWebinarNeedUserNameAndEmailWithCompletion:(BOOL (^_Nonnull)(NSString * _Nonnull username, NSString * _Nonnull email, BOOL cancel))completion
{
    if (completion)
    {
        NSString *username = @"zoomtest";
        NSString *email = @"zoomtest@zoom.us";
        BOOL ret = completion(username,email,NO);
        NSLog(@"MobileRTC onSinkJoinWebinarNeedUserNameAndEmailWithCompletion %@",@(ret));
    }
}

- (void)onSinkPanelistCapacityExceed
{
    NSLog(@"MobileRTC onSinkPanelistCapacityExceed");
}

- (void)onMeetingError:(MobileRTCMeetError)error message:(NSString*)message
{
    NSLog(@"MobileRTC onMeetingError:%zd, message:%@", error, message);
    
    if (error != 0) {
        NSString *errorCode = [NSString stringWithFormat:@"Error Code:%@",@(error)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorCode message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onMeetingStateChange:(MobileRTCMeetingState)state
{
    NSLog(@"MobileRTC onMeetingStateChange:%@", @(state));
    if (self.mainVC) {
        [self.mainVC onMeetingStateChange:state];
    }
    
    if (self.customMeetingVC) {
        [self.customMeetingVC onMeetingStateChange:state];
    }
}

- (void)onMeetingParameterNotification:(MobileRTCMeetingParameter *_Nullable)meetingParam
{
    NSLog(@"MobileRTC onMeetingParameterNotification===> meetingType:%@ isViewOnly:%@ isAutoRecordingLocal:%@ isAutoRecordingCloud:%@ meetinNumber:%@ meetingTopic:%@ meetingHost:%@", @(meetingParam.meetingType), @(meetingParam.isViewOnly), @(meetingParam.isAutoRecordingLocal), @(meetingParam.isAutoRecordingCloud), @(meetingParam.meetingNumber), meetingParam.meetingTopic, meetingParam.meetingHost);
}

- (void)onMeetingReady
{
    NSLog(@"MobileRTC onMeetingReady");
    if (self.mainVC) {
        [self.mainVC onMeetingReady];
    }
}

- (BOOL)onClickedShareButton:(UIViewController*)parentVC addShareActionItem:(NSMutableArray *)array
{
    return [self.mainVC onClickedShareButton:parentVC addShareActionItem:array];
}

- (void)onOngoingShareStopped
{
    NSLog(@"There does not exist ongoing share");
    //    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    //    if (ms)
    //    {
    //        [ms startAppShare];
    //    }
}

- (BOOL)onClickedAudioButton:(UIViewController*)parentVC {
    
    return NO; // will show the default SDK UI
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) {
        return NO;
    }
    
    MobileRTCAudioType audioType = [ms myAudioType];
    switch (audioType)
    {
        case MobileRTCAudioType_VoIP: //voip
        case MobileRTCAudioType_Telephony: //phone
        {
            if (![ms canUnmuteMyAudio])
            {
                break;
            }
            BOOL isMuted = [ms isMyAudioMuted];
            [ms muteMyAudio:!isMuted];
            break;
        }
        case MobileRTCAudioType_None:
        {
            //Supported VOIP
            if ([ms isSupportedVOIP])
            {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"To hear others\n please join audio", @"")
                                                                                             message:nil
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Call via Internet", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //Join VOIP
                        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
                        if (ms)
                        {
                            [ms connectMyAudio:YES];
                        }
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
                }
            }
            break;
        }
    }
    
    return YES;
}

- (void)onSinkMeetingShowMinimizeMeetingOrBackZoomUI:(MobileRTCMinimizeMeetingState)state
{
    NSLog(@"MobileRTC onSinkMeetingShowMinimizeMeetingOrBackZoomUI %@",@(state));
}

- (void)onSinkAttendeeChatPriviledgeChanged:(MobileRTCMeetingChatPriviledgeType)currentPrivilege
{
    NSLog(@"MobileRTC onSinkAttendeeChatPriviledgeChanged %@",@(currentPrivilege));
}

- (void)onSinkPanelistChatPrivilegeChanged:(MobileRTCPanelistChatPrivilegeType)privilege
{
    NSLog(@"MobileRTC onSinkPanelistChatPrivilegeChanged %@",@(privilege));
}

#if 0
- (void)onMeetingEndedReason:(MobileRTCMeetingEndReason)reason
{
    NSLog(@"MobileRTC onMeetingEndedReason %d", reason);
}
#endif

#if 0
- (void)onMicrophoneStatusError:(MobileRTCMicrophoneError)error
{
    NSLog(@"MobileRTC onMicrophoneStatusError %d", error);
}
#endif

#if 0
- (void)onJBHWaitingWithCmd:(JBHCmd)cmd
{
    NSLog(@"MobileRTC onJBHWaitingWithCmd->%@",@(cmd));
    if (self.mainVC) {
        [self.mainVC onJBHWaitingWithCmd:cmd];
    }
}
#endif

#if 0
- (BOOL)onClickedInviteButton:(UIViewController*)parentVC addInviteActionItem:(NSMutableArray *)array
{
    return [self.mainVC onClickedInviteButton:parentVC addInviteActionItem:array];
}
#endif

#if 0
- (BOOL)onClickedParticipantsButton:(UIViewController*)parentVC;
{
    return [self.mainVC onClickedParticipantsButton:parentVC];
}
#endif

#if 0
- (BOOL)onClickedEndButton:(UIViewController*)parentVC endButton:(UIButton *)endButton
{
    return [self.mainVC onClickedEndButton:parentVC endButton:endButton];
}
#endif

#if 0
- (void)onClickedDialOut:(UIViewController*)parentVC isCallMe:(BOOL)me
{
    if (self.mainVC) {
        [self.mainVC onClickedDialOut:parentVC isCallMe:me];
    }
}

- (void)onDialOutStatusChanged:(DialOutStatus)status
{
    NSLog(@"MobileRTC onDialOutStatusChanged: %zd", status);
}
#endif

#pragma mark - H.323/SIP call state changed
#if 0
- (void)onSendPairingCodeStateChanged:(MobileRTCH323ParingStatus)state MeetingNumber:(unsigned long long)meetingNumber
{
    NSLog(@"MobileRTC onSendPairingCodeStateChanged %zd", state);
}

- (void)onCallRoomDeviceStateChanged:(H323CallOutStatus)state
{
    NSLog(@"MobileRTC onCallRoomDeviceStateChanged %zd", state);
}
#endif

#pragma mark - ZAK expired
#if 0
- (void)onZoomIdentityExpired
{
    NSLog(@"MobileRTC onZoomIdentityExpired");
}

#pragma mark - Closed Caption
- (void)onClosedCaptionReceived:(NSString *)message speakerId:(NSUInteger)speakerID msgTime:(NSDate *)msgTime
{
    NSLog(@"MobileRTC onClosedCaptionReceived msg:%@-speaker_id:%@-msgTime:%@",message, @(speakerID), msgTime);
}
#endif

#if 0
- (void)onSubscribeUserFail:(MobileRTCSubscribeFailReason)errorCode size:(NSInteger)size userId:(NSUInteger)userId
{
    NSLog(@"MobileRTC onSubscribeUserFail: %@ size:%@ userId:%@",@(errorCode),@(size),@(userId));
}
#endif

- (void)onCheckCMRPrivilege:(MobileRTCCMRError)result {
    NSLog(@"MobileRTC onCheckCMRPrivilege==%@", @(result));
}

- (void)onRecordingStatus:(MobileRTCRecordingStatus)status {
    NSLog(@"MobileRTC onRecordingStatus==%@", @(status));
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if ([ms isMeetingChatLegalNoticeAvailable]
        && MobileRTCRecording_Start == status
        && [settings enableCustomMeeting]) {
        NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
        NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onLocalRecordingStatus:(NSInteger)userId status:(MobileRTCRecordingStatus)status {
    NSLog(@"MobileRTC onLocalRecordingStatus==%@==%@", @(status),@(userId));
    
}

#if 0
- (void)onAskToEndOtherMeeting:(void (^_Nonnull)(BOOL cancel))completion {
    NSLog(@"MobileRTC onAskToEndOtherMeeting");
    completion(NO);
}
#endif

- (void)onLiveStreamStatusChange:(MobileRTCLiveStreamStatus)liveStreamStatus {
    NSLog(@"MobileRTC onLiveStreamStatusChange==%lu", liveStreamStatus);
}

- (void)onSpotlightVideoChange:(BOOL)on
{
    NSLog(@"MobileRTC onSpotlightVideoChange==%@", @(on));
}

- (void)onSpotlightVideoUserChange:(NSArray <NSNumber *>* _Nonnull)spotlightedUserList;
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *spotList = [ms getSpotLightedVideoUserList];
    NSLog(@"MobileRTC onSpotlightVideoUserChange==%@", spotlightedUserList);
}

- (void)onShareMeetingChatStatusChanged:(BOOL)isStart
{
    NSLog(@"MobileRTC onShareMeetingChatStatusChanged : %@", @(isStart));
}

- (void)onSinkMeetingActiveVideoForDeck:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingActiveVideoForDeck==%@", @(userID));
}

- (void)onSinkLowerAllHands
{
    NSLog(@"MobileRTC onSinkLowerAllHands");
}

- (void)on3DAvatarItemThumbnailsDownloaded
{
    NSLog(@"on3DAvatarItemThumbnailsDownloaded");
}

- (void)on3DAvatarItemDataDownloading:(int)index
{
    NSLog(@"on3DAvatarItemDataDownloading:%@", @(index));
}

- (void)on3DAvatarItemDataDownloaded:(bool)success andIndex:(int)index
{
    NSLog(@"on3DAvatarItemDataDownloaded:%@ andIndex:%@", @(success), @(index));
}

- (void)onRawLiveStreamPrivilegeChanged:(BOOL)hasPrivilege {
    NSString *logStr = [NSString stringWithFormat:@"MobileRTC onRawLiveStreamPrivilegeChanged:%@", @(hasPrivilege)];
    NSLog(@"%@", logStr);
}

- (void)onRawLiveStreamPrivilegeRequestTimeout {
    NSString *logStr = @"MobileRTC onRawLiveStreamPrivilegeRequestTimeout";
    NSLog(@"%@", logStr);
}

- (void)onUserRawLiveStreamPrivilegeChanged:(NSUInteger)userid hasPrivilege:(bool)hasPrivilege {
    NSString *logStr = [NSString stringWithFormat:@"MobileRTC onUserRawLiveStreamPrivilegeChanged:%@ hasPrivilege:%@", @(userid), @(hasPrivilege)];
    NSLog(@"%@", logStr);
}

- (void)onRawLiveStreamPrivilegeRequested:(MobileRTCRequestRawLiveStreamPrivilegeHandler*_Nullable)handler {
    NSString *logStr = [NSString stringWithFormat:@"MobileRTC onRawLiveStreamPrivilegeRequested:%@", handler];
    NSLog(@"%@", logStr);
}

- (void)onUserRawLiveStreamingStatusChanged:(NSArray<MobileRTCRawLiveStreamInfo *>*_Nullable)livingList {
    NSString *logStr = [NSString stringWithFormat:@"MobileRTC onUserRawLiveStreamingStatusChanged:%@", livingList];
    NSLog(@"%@", logStr);
}

- (void)onRequestLocalRecordingPrivilegeReceived:(MobileRTCRequestLocalRecordingPrivilegeHandler * _Nullable)handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Receive the local recording request"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSLog(@"The Request Id:%@, requester id:%@ and name:%@", [handler getRequestId], @([handler getRequesterId]), [handler getRequesterName]);
    [alertController addAction:[UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler grantLocalRecordingPrivilege];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"disagree", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [handler denyLocalRecordingPrivilege];
    }]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}
@end
