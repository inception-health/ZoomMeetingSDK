//
//  SDKStartJoinMeetingPresenter+JoinMeetingOnly.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/20.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+JoinMeetingOnly.h"

@implementation SDKStartJoinMeetingPresenter (JoinMeetingOnly)

- (void)joinMeeting:(NSString*)meetingNo withPassword:(NSString*)pwd
{
    if (![meetingNo length])
        return;
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms)
    {
#if 0
        //customize meeting title
        [ms customizeMeetingTitle:@"Sample Meeting Title"];
#endif
        
        //For Join a meeting with password
        MobileRTCMeetingJoinParam * joinParam = [[MobileRTCMeetingJoinParam alloc] init];
        joinParam.userName = [UIDevice currentDevice].name;
        joinParam.meetingNumber = meetingNo;
        joinParam.password = pwd;
//        joinParam.isMyVoiceInMix = YES;
//        joinParam.zak = kZAK;
//        joinParam.customerKey = kCustomerKey;
//        joinParam.webinarToken = kWebinarToken;
//        joinParam.noAudio = YES;
//        joinParam.noVideo = YES;
        
        MobileRTCMeetError ret = [ms joinMeetingWithJoinParam:joinParam];
        
        NSLog(@"MobileRTC onJoinaMeeting ret: %@", ret == MobileRTCMeetError_Success ? @"Success" : @(ret));

    }
}

@end
