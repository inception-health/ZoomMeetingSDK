//
//  SDKStartJoinMeetingPresenter+LiveTranscription.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2021/10/27.
//  Copyright © 2021 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+LiveTranscription.h"

@implementation SDKStartJoinMeetingPresenter (LiveTranscription)
- (void)onCaptionStatusChanged:(BOOL)enable {
    NSLog(@"onCaptionStatusChanged --- %@",enable?@"YES":@"NO");
}

- (void)onSinkLiveTranscriptionStatus:(MobileRTCLiveTranscriptionStatus)status;
{
    NSLog(@"LiveTranscription: onSinkLiveTranscriptionStatus = %@",@(status));
}

- (void)onLiveTranscriptionMsgInfoReceived:(MobileRTCLiveTranscriptionMessageInfo*_Nullable)messageInfo {
    NSLog(@"---- %s   %@",__FUNCTION__,messageInfo.description);
}

- (void)onOriginalLanguageMsgReceived:(MobileRTCLiveTranscriptionMessageInfo*_Nullable)messageInfo {
    NSLog(@"---- %s   %@",__FUNCTION__,messageInfo.description);
}

- (void)onSinkRequestForLiveTranscriptReceived:(NSUInteger)requesterUserId bAnonymous:(BOOL)bAnonymous
{
    NSLog(@"LiveTranscription: onSinkRequestForLiveTranscriptReceived = %@  bAnonymous = %@",@(requesterUserId), @(bAnonymous));
}

- (void)onLiveTranscriptionMsgError:(MobileRTCLiveTranscriptionLanguage * _Nullable)speakLanguage
                 transcriptLanguage:(MobileRTCLiveTranscriptionLanguage * _Nullable)transcriptLanguage {
    NSLog(@"LiveTranscription: onLiveTranscriptionMsgError %@-%@", speakLanguage, transcriptLanguage);
}

@end
