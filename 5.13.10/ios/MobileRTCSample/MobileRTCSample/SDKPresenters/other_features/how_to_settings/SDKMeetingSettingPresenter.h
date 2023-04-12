//
//  SDKMeetingSettingPresenter.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/27.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKMeetingSettingPresenter : NSObject

- (void)setAutoConnectInternetAudio:(BOOL)connected;

- (void)setMuteAudioWhenJoinMeeting:(BOOL)muted;

- (void)setMuteVideoWhenJoinMeeting:(BOOL)muted;

- (void)disableDriveMode:(BOOL)disabled;

- (void)disableGalleryView:(BOOL)disabled;

- (void)disableCloudWhiteboard:(BOOL)disabled;

- (void)onDisableVideoPreview:(BOOL)disabled;

- (void)onDisableVirtualBackground:(BOOL)disabled;

- (void)onDisableCopyMeetinUrl:(BOOL)disabled;

- (void)onProximityMonitoring:(BOOL)disabled;

- (void)onSpeakerWhenInMeeting:(BOOL)disabled;

- (void)onDisableClearWeb:(BOOL)disabled;

- (void)disableCallIn:(BOOL)disabled;

- (void)disableCallOut:(BOOL)disabled;

- (void)disableMinimizeMeeting:(BOOL)disabled;

- (void)faceBeautyEnable:(BOOL)enable;

- (void)videoMirrorEnable:(BOOL)enable;

- (void)enableMicOriginalInput:(BOOL)enable;

- (void)setMeetingTitleHidden:(BOOL)hidden;

- (void)setHiddenMySelfView:(BOOL)hidden;

- (void)setMeetingPasswordHidden:(BOOL)hidden;

- (void)setMeetingLeaveHidden:(BOOL)hidden;

- (void)setMeetingAudioHidden:(BOOL)hidden;

- (void)setMeetingVideoHidden:(BOOL)hidden;

- (void)setMeetingInviteHidden:(BOOL)hidden;

- (void)setMeetingInviteUrlHidden:(BOOL)hidden;

- (void)setMeetingChatHidden:(BOOL)hidden;

- (void)setMeetingParticipantHidden:(BOOL)hidden;

- (void)setMeetingShareHidden:(BOOL)hidden;

- (void)setMeetingMoreHidden:(BOOL)hidden;

- (void)setTopBarHidden:(BOOL)hidden;

- (void)setBottomBarHidden:(BOOL)hidden;

- (void)setQaButtonHidden:(BOOL)hidden;

- (void)setCallinRoomSystemHidden:(BOOL)hidden;

- (void)setCalloutRoomSystemHidden:(BOOL)hidden;

- (void)setClaimHostWithHostKeyHidden:(BOOL)hidden;

- (void)setCloseCaptionHidden:(BOOL)hidden;

- (void)setPromoteToPanelistHidden:(BOOL)hidden;

- (void)setChangeToAttendeeHiddenHidden:(BOOL)hidden;

- (void)setReactionsOnMeetingUI:(BOOL)hidden;

- (void)setRecordButtonHidden:(BOOL)hidden;

- (void)setHideNoVideoUsersEnabled:(BOOL)enabled;

- (void)setEnableKubi:(BOOL)enabled;

- (void)setThumbnailInShare:(BOOL)changed;

- (void)setHostLeaveHidden:(BOOL)hidden;

- (void)setHintHidden:(BOOL)hidden;

- (void)setWaitingHUDHidden:(BOOL)hidden;

- (void)setEnableCustomMeeting:(BOOL)enableCustomMeeting;

- (void)enableShowMyMeetingElapseTime:(BOOL)enable;

- (void)setDisconnectAudioHidden:(BOOL)hidden;

@end
