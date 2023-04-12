//
//  SDKMeetingSettingPresenter.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/27.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKMeetingSettingPresenter.h"

@implementation SDKMeetingSettingPresenter

- (void)setAutoConnectInternetAudio:(BOOL)connected
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setAutoConnectInternetAudio:connected];
}

- (void)setMuteAudioWhenJoinMeeting:(BOOL)muted
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setMuteAudioWhenJoinMeeting:muted];
}

- (void)setMuteVideoWhenJoinMeeting:(BOOL)muted
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setMuteVideoWhenJoinMeeting:muted];
}

- (void)disableDriveMode:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableDriveMode:disabled];
}

- (void)disableGalleryView:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableGalleryView:disabled];
}

- (void)disableCloudWhiteboard:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableCloudWhiteboard:disabled];
}

- (void)onDisableVideoPreview:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableShowVideoPreviewWhenJoinMeeting:disabled];
}

- (void)onDisableVirtualBackground:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableVirtualBackground:disabled];
}

- (void)onDisableCopyMeetinUrl:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableCopyMeetingUrl:disabled];
}

- (void)onProximityMonitoring:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setProximityMonitoringDisable:disabled];
}

- (void)onSpeakerWhenInMeeting:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setSpeakerOffWhenInMeeting:disabled];
}

- (void)onDisableClearWeb:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableClearWebKitCache:disabled];
}

- (void)disableCallIn:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableCallIn:disabled];
}

- (void)disableCallOut:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableCallOut:disabled];
}

- (void)disableMinimizeMeeting:(BOOL)disabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] disableMinimizeMeeting:disabled];
}

- (void)faceBeautyEnable:(BOOL)enable
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setFaceBeautyEnabled:enable];
}

- (void)videoMirrorEnable:(BOOL)enable
{
    [[[MobileRTC sharedRTC] getMeetingSettings] enableMirrorEffect:enable];
}

- (void)enableMicOriginalInput:(BOOL)enable
{
    [[[MobileRTC sharedRTC] getMeetingSettings] enableMicOriginalInput:enable];
}

- (void)setMeetingTitleHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingTitleHidden = hidden;
}

- (void)setHiddenMySelfView:(BOOL)hidden
{
    [[[MobileRTC sharedRTC] getMeetingSettings] enableHideSelfView:hidden];
}


- (void)setMeetingPasswordHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingPasswordHidden = hidden;
}

- (void)setMeetingLeaveHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingLeaveHidden = hidden;
}

- (void)setMeetingAudioHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingAudioHidden = hidden;
}

- (void)setMeetingVideoHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingVideoHidden = hidden;
}

- (void)setMeetingInviteHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingInviteHidden = hidden;
}

- (void)setMeetingInviteUrlHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingInviteUrlHidden = hidden;
}

- (void)setMeetingChatHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingChatHidden = hidden;
}

- (void)setMeetingParticipantHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingParticipantHidden = hidden;
}

- (void)setMeetingShareHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingShareHidden = hidden;
}

- (void)setMeetingMoreHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].meetingMoreHidden = hidden;
}

- (void)setTopBarHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].topBarHidden = hidden;
}

- (void)setBottomBarHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].bottomBarHidden = hidden;
}

- (void)setQaButtonHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].qaButtonHidden = hidden;
}

- (void)setCallinRoomSystemHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].callinRoomSystemHidden = hidden;
}

- (void)setCalloutRoomSystemHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].calloutRoomSystemHidden = hidden;
}

- (void)setClaimHostWithHostKeyHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].claimHostWithHostKeyHidden = hidden;
}

- (void)setCloseCaptionHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].closeCaptionHidden = hidden;
}

- (void)setPromoteToPanelistHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].promoteToPanelistHidden = hidden;
}

- (void)setChangeToAttendeeHiddenHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].changeToAttendeeHidden = hidden;
}

- (void)setReactionsOnMeetingUI:(BOOL)hidden
{
    [[[MobileRTC sharedRTC] getMeetingSettings] hideReactionsOnMeetingUI:hidden];
}

- (void)setRecordButtonHidden:(BOOL)hidden
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setRecordButtonHidden:hidden];
}

- (void)setHideNoVideoUsersEnabled:(BOOL)enabled
{
    [[[MobileRTC sharedRTC] getMeetingSettings] setHideNoVideoUsersEnabled:enabled];
}

- (void)setEnableKubi:(BOOL)enabled
{
    [[MobileRTC sharedRTC] getMeetingSettings].enableKubi = enabled;
}

- (void)setThumbnailInShare:(BOOL)changed
{
    [[MobileRTC sharedRTC] getMeetingSettings].thumbnailInShare = changed;
}

- (void)setHostLeaveHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].hostLeaveHidden = hidden;
}

- (void)setHintHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].hintHidden = hidden;
}

- (void)setDisconnectAudioHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].disconnectAudioHidden = hidden;
}

- (void)setWaitingHUDHidden:(BOOL)hidden
{
    [[MobileRTC sharedRTC] getMeetingSettings].waitingHUDHidden = hidden;
}

- (void)setEnableCustomMeeting:(BOOL)enableCustomMeeting
{
    [[MobileRTC sharedRTC] getMeetingSettings].enableCustomMeeting = enableCustomMeeting;
}

- (void)enableShowMyMeetingElapseTime:(BOOL)enable;
{
    [[[MobileRTC sharedRTC] getMeetingSettings] enableShowMyMeetingElapseTime:enable];
}


@end
