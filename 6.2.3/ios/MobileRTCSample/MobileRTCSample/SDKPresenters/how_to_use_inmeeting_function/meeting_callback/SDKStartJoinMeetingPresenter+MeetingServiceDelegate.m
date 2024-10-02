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


- (void)onIndicatorItemReceived:(MobileRTCIndicatorHandler *)inMeetingIndicatorHandler {
    NSLog(@"inMeetingIndicatorHandler  %@ \n %@\n %@@",inMeetingIndicatorHandler.getIndicatorItemId,inMeetingIndicatorHandler.getIndicatorName,inMeetingIndicatorHandler.getIndicatorIcon);
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onIndicatorItemReceived:)]) {
        [self.customMeetingVC onIndicatorItemReceived:inMeetingIndicatorHandler];
    }
}
- (void)onIndicatorItemRemoved:(MobileRTCIndicatorHandler *)inMeetingIndicatorHandler {
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onIndicatorItemRemoved:)]) {
        [self.customMeetingVC onIndicatorItemRemoved:inMeetingIndicatorHandler];
    }
}
#pragma mark -- For CustomUI Meeting
- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onWaitingRoomStatusChange:)])
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
    
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onMeetingStateChange:)]) {
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

- (void)onUserConfirmToStartArchive:(MobileRTCArchiveConfrimHandle * _Nullable)handler
{
    if (!handler) return;
    NSString *content = [handler getArchiveConfirmContent];
    NSLog(@"MobileRTC onUserConfirmToStartArchive %@, content %@",handler, content);
    [handler joinWithArchive:YES];
    
}
- (void)onMeetingTopicChanged:(NSString *_Nullable)meetingTopic {
    NSLog(@"MobileRTC onMeetingTopicChanged %@", meetingTopic);
}

- (void)onMuteOnEntryStatusChange:(BOOL)bEnabled {
    NSLog(@"MobileRTC onMuteOnEntryStatusChange %@", @(bEnabled));
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

#if 1
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
    if ([ms isMeetingChatLegalNoticeAvailable]
        && MobileRTCRecording_Start == status
        && [[MobileRTC sharedRTC] isEnabledCustomizeMeetingUI]) {
        NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
        NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onLocalRecordingStatus:(NSInteger)userId status:(MobileRTCRecordingStatus)status {
    NSLog(@"MobileRTC onLocalRecordingStatus==%@==%@", @(status),@(userId));
    
}

- (void)onAllowParticipantsRequestCloudRecordingNotification:(BOOL)allow {
    NSLog(@"%s allow:%@",__FUNCTION__,@(allow));
}

- (void)onRequestStartCloudRecordingResponse:(MobileRTCRequestStartCloudRecordingStatus)status {
    NSLog(@"%s MobileRTCRequestStartCloudRecordingStatus:%@",__FUNCTION__,@(status));
}

- (void)onStartCloudRecordingRequested:(MobileRTCRequestStartCloudRecordingPrivilegeHandler*_Nullable) handler {
    NSLog(@"%s handler:%@",__FUNCTION__,handler);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MobileRTCRequestStartCloudRecordingPrivilegeHandler"
                                                                             message:[NSString stringWithFormat:@"RequesterId:%@ RequesterName:%@",@([handler getRequesterId]),[handler getRequesterName]]
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Grant" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler grant];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Deny" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [handler deny:NO];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Deny all" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler deny:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cannel" style:UIAlertActionStyleDefault handler:nil]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
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

- (void)onSpotlightVideoUserChange:(NSArray <NSNumber *>*)spotlightedUserList;
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *spotList = [ms getSpotLightedVideoUserList];
    NSLog(@"MobileRTC onSpotlightVideoUserChange==%@", spotlightedUserList);
}

- (void)onActiveSpeakerVideoUserChanged:(NSUInteger)userID
{
    NSLog(@"MobileRTC onActiveSpeakerVideoUserChanged==%@", @(userID));
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


- (void)onSuspendParticipantsActivities{
    NSLog(@"---%s ",__FUNCTION__);
}

/**
* Sink the event that participants start video
*
* @param allow true allow false disallow
*/
- (void)onAllowParticipantsStartVideoNotification:(BOOL)allow{NSLog(@"---%s %d",__FUNCTION__,allow);}

/**
* Sink the event that participants rename self
*
* @param allow true allow false disallow
*/
- (void)onAllowParticipantsRenameNotification:(BOOL)allow {
    NSLog(@"---%s %d",__FUNCTION__,allow);
}

/**
* Sink the event that participants allow unmute self
*
* @param allow true allow false disallow
*/
- (void)onAllowParticipantsUnmuteSelfNotification:(BOOL)allow{NSLog(@"---%s %d",__FUNCTION__,allow);
    
}

/**
* Sink the event that participants allow share new white board
*
* @param allow true allow false disallow
*/
- (void)onAllowParticipantsShareWhiteBoardNotification:(BOOL)allow{
    NSLog(@"---%s %d",__FUNCTION__,allow);
}

/**
 * Sink the event that participants allow to share
 *
 * @param allow true allow false disallow
 */
- (void)onAllowParticipantsShareStatusNotification:(BOOL)allow{
    NSLog(@"---%s %d",__FUNCTION__,allow);
}
/**
* Sink the event that meeting lock status change
*
* @param isLock true locked false unlock
*/
- (void)onMeetingLockStatus:(BOOL)isLock{
    NSLog(@"---%s %d",__FUNCTION__,isLock);
}


- (void)onWhiteboardStatusChanged:(MobileRTCWhiteboardStatus)status {
    NSLog(@"%d %s %@",__LINE__,__func__,status?@"MobileRTCWhiteboardStatus_Stopped":@"MobileRTCWhiteboardStatus_Started");
}
- (void)onWhiteboardSettingsChanged:(MobileRTCWhiteboardShareOption)shareOption createOption:(MobileRTCWhiteboardCreateOption)createOption enable:(BOOL)enable {
    NSLog(@"%d %s %@ %@",__LINE__,__func__,@(shareOption),@(createOption));
}
- (void)onAICompanionFeatureTurnOffByParticipant:(MobileRTCAICompanionTurnOnAgainHandler * _Nullable)handler {
    NSLog(@"---%s",__FUNCTION__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"MobileRTCAICompanionTurnOnAgainHandler"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"turnOnAgain" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler turnOnAgain ];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"agreeTurnOff", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [handler agreeTurnOff];
    }]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}
- (void)onAICompanionFeatureSwitchRequested:(MobileRTCAICompanionSwitchHandler *_Nullable)handler {
    NSLog(@"---%s",__FUNCTION__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:[NSString stringWithFormat:@"MobileRTCAICompanionSwitchHandler %@  isTurnOn:%@",@([handler getRequestUserID]),@([handler isTurnOn]) ]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Agree YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler agree:YES ];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Agree NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler agree:NO ];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"decline", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [handler decline];
    }]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}
- (void)onAICompanionFeatureSwitchRequestResponse:(BOOL)timeout agree:(BOOL)agree turn:(BOOL)turnOn {
    NSLog(@"---%s  timeout:%@ agree:%@ turnOn:%@",__FUNCTION__,@(timeout),@(agree),@(turnOn));
}
- (void)onAICompanionFeatureCanNotBeTurnedOff:(NSArray *_Nullable)featuresArr {
    NSLog(@"---%s  %@",__FUNCTION__,featuresArr.description);
}

- (void)onSmartSummaryStateNotSupported;
{
    NSLog(@"");
}

- (void)onSmartSummaryStateSupportedButDisabled;
{
    NSLog(@"");
}

- (void)onSmartSummaryStateEnabledButNotStarted:(MobileRTCStartSmartSummaryHandler *_Nullable)handler
{
    NSLog(@"MobileRTCStartSmartSummaryHandler isForRequest(non host cohost) %@", @(handler.isForRequest));
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MobileRTCStartSmartSummaryHandler"
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"startSmartSummary" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [handler startSmartSummary];
//    }]];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }]];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)onSmartSummaryStateStarted:(MobileRTCStopSmartSummaryHandler *_Nullable)handler;
{
    NSLog(@"onSmartSummaryStateStarted handler(host/cohost have) %@", handler);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MobileRTCStopSmartSummaryHandler"
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"stopSmartSummary" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [handler stopSmartSummary];
//    }]];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }]];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)onFailedToStartSmartSummary:(BOOL)bTimeout
{
    NSLog(@"onFailedToStartSmartSummary bTimeout %@", @(bTimeout));
}

- (void)onSmartSummaryStartRequestReceived:(MobileRTCApproveStartSmartSummaryHandler *_Nullable)handler
{
    NSLog(@"onSmartSummaryStartRequestReceived getSenderUserID %@", @(handler.getSenderUserID));
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"MobileRTCApproveStartSmartSummaryHandler"
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"approve" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [handler approve];
//    }]];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"decline" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [handler decline];
//    }]];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)onFileSendStart:(MobileRTCFileSender * _Nullable)sender
{
    NSLog(@"onFileSendStart fileName: %@", sender.transferInfo.fileName);
}

- (void)onFileReceived:(MobileRTCFileReceiver * _Nullable)receiver
{
    NSLog(@"onFileReceived fileName: %@", receiver.transferInfo.fileName);
    NSString *tmpDirectory = NSTemporaryDirectory();
    [receiver startReceive:[NSString stringWithFormat:@"%@/%@", tmpDirectory, receiver.transferInfo.fileName]];
}

- (void)onFileTransferProgress:(MobileRTCFileTransferInfo * _Nullable)info
{
    NSLog(@"onFileTransferProgress fileName: %@, status: %@, ratio: %@, com: %@, bps: %@", info.fileName, @(info.transStatus), @(info.completePercentage), @(info.completeSize), @(info.bitPerSecond));
}
@end
