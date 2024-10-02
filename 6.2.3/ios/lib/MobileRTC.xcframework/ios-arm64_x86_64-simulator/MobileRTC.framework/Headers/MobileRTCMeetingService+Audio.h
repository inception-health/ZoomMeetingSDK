//
//  MobileRTCMeetingService+Audio.h
//  MobileRTC
//
//  Created by Zoom Video Communications on 2018/6/6.
//  Copyright © 2019 Zoom Video Communications, Inc. All rights reserved.
//

#import <MobileRTC/MobileRTC.h>

@interface MobileRTCMeetingService (Audio)

/*!
 @brief Get the in-meeting audio type of the current user.
 @return The audio type.
 */
- (MobileRTCAudioType)myAudioType;


/**
 * @brief Determine if the meeting has third party telephony audio enabled.
 * @return YES means enabled, otherwise it is not enabled.
 */
 - (BOOL)is3rdPartyTelephonyAudioOn;

/*!
 @brief Set whether to connect the audio in the meeting.
 @param on YES means to connect, otherwise not.
 @return YES means that the method is called successfully, otherwise not.
 */
- (BOOL)connectMyAudio:(BOOL)on;

/*!
 @brief Set to retrieve the audio output type of the current user.
 @return The descriptions of audio output types.
 */
- (MobileRTCAudioOutput)myAudioOutputDescription;

/*!
 @brief Query if the audio of the current user is muted.
 @return YES means muted, otherwise not.
 */
- (BOOL)isMyAudioMuted;

/*!
 @brief Query if the user can unmute his audio.
 @return YES means that he can unmute his audio, otherwise not.
 */
- (BOOL)canUnmuteMyAudio;

/*!
@brief Check if the host/cohost can enable mute on entry.
@return YES  indicates that the host/cohost can enable mute on entry. Otherwise not.
@remarks Valid for both ZOOM style and user custom interface mode.
*/
- (BOOL)canEnableMuteOnEntry;
/*!
@brief Mute or umute the user after joining the meeting.
@param bEnable YES  indicates to mute the user after joining the meeting.
@param allowUnmuteBySelf YES means allow to mute self
@return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed. To get extended error information, see \link MobileRTCSDKError \endlink enum.
@remarks Valid for both ZOOM style and user custom interface mode.
 */
- (MobileRTCSDKError)enableMuteOnEntry:(BOOL)bEnable allowUnmuteBySelf:(BOOL)allowUnmuteBySelf;

/*!
 @brief Query if is enabled to mute attendees when they join the meeting. 
 @return YES means enabled, otherwise not.
 */
- (BOOL)isMuteOnEntryOn;

/*!
 @brief Query if the user's audio is muted.
 @param userID The ID of user to be checked.
 @return YES means muted, otherwise not.
 */
- (BOOL)isUserAudioMuted:(NSUInteger)userID;

/*!
 @brief Set whether to mute user's audio.
 @param mute YES means to mute, otherwise not.
 @param userID The ID of user.
 @return YES means that the method is called successfully, otherwise not.
 @warning Only meeting host can run the function.
 */
- (BOOL)muteUserAudio:(BOOL)mute withUID:(NSUInteger)userID;

/*!
 @brief Set to mute audio of all attendees.
 @param allowSelfUnmute YES means that attendee can unmute the audio himself, otherwise not.
 @return YES means that the method is called successfully, otherwise not.
 @warning Only meeting host/co-host can run the function.
 */
- (BOOL)muteAllUserAudio:(BOOL)allowSelfUnmute;

/*!
@brief Ask to unmute audio of all attendees.
@return YES means that the method is called successfully, otherwise not.
@warning Only meeting host/co-host can run the function.
*/
- (BOOL)askAllToUnmute;

/*!
 @brief Query if the meeting supports VoIP.
 @return YES means supported, otherwise not.
 */
- (BOOL)isSupportedVOIP;

/*!
 @brief Query if chime is enabled when user joins/leaves meeting.
 @return YES means enabled, otherwise not.
 */
- (BOOL)isPlayChimeOn;

/*!
 @brief Set whether chime are enabled when the user joins/leaves meeting.
 @return YES means enabled, otherwise not.
 @warning Only meeting host/cohost can run the function when in meeting.
 */
- (BOOL)playChime:(BOOL)on;

/*!
 @brief Set to mute the audio of the current user.
 @param mute YES means the audio is muted, otherwise not.
 @return The result of operation, muted or not.
 */
- (MobileRTCAudioError)muteMyAudio:(BOOL)mute;

/*!
 @brief switch my audio output(receiver/speaker).
 */
- (MobileRTCAudioError)switchMyAudioSource;

/*!
 @brief Reset Meeting Audio Session including Category and Mode.
 */
- (void)resetMeetingAudioSession;

/*!
 @brief Reset Meeting Audio Session including Category and Mode. When the call comes in or goes out, click hold or swap in the dial-up UI to restore the zoom sound.
 */
- (void)resetMeetingAudioForCallKitHeld;

/*!
@brief Determine if the incoming audio is stopped.
@return YES indicates that the incoming audio is stopped.
*/
- (BOOL)isIncomingAudioStopped;

/*!
@brief Stop the incoming audio.
@param enabled YES means enabled. NO not.
@return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise the function fails and returns an error. To get extended error information, see [MobileRTCSDKError] enum.
*/
- (MobileRTCSDKError)stopIncomingAudio:(BOOL)enabled;

/*!
@brief Get the audio type supported by the current meeting. See [MobileRTCInMeetingSupportAudioType].
@return If the function succeeds, it will return the type. The value is the 'bitwise OR' of each supported audio type.
*/
- (NSInteger)getSupportedMeetingAudioType;
@end
