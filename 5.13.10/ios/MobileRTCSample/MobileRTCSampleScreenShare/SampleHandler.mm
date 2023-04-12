//
//  SampleHandler.m
//  ExtensionReplayKit
//
//  Created by Zoom Video Communications on 2018/5/11.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//


#import "SampleHandler.h"
#import <MobileRTCScreenShare/MobileRTCScreenShareService.h>

@interface SampleHandler () <MobileRTCScreenShareServiceDelegate>

@property (strong, nonatomic) MobileRTCScreenShareService * screenShareService;

@end

@implementation SampleHandler

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.screenShareService = [[MobileRTCScreenShareService alloc]init];
        /**
         * if you need use screen share feature, Here are a few things to note:
         * <1> Create your own groupid on the Apple Developer Web site, and fill the group ID in here and in the AppDelegate.m
         * <2> Create an "App Groups" Capability in the main project target and the replayKit project target, and select the groupId correctly.
         * <3> If you can't select groupId correctly in "App Groups" Capability, Please check MobileRTCSample.Entitlements and MobileRTCSampleScreenShare.entitlements this two files, here also need to configure the correct group id.
         *   <key>com.apple.security.application-groups</key>
             <array>
                <string> your group id </string>
             </array
         *
         * For details, please refer: https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/mastering-zoom-sdk/in-meeting-function/screen-share
         *
         * if you don't need screen share, please delete MobileRTCSampleScreenShare target.
         *
         */
        self.screenShareService.appGroup = <#Group ID#>;
        self.screenShareService.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.screenShareService = nil;
}


- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        [self.screenShareService broadcastStartedWithSetupInfo:setupInfo];
    
}

- (void)broadcastPaused {
        [self.screenShareService broadcastPaused];
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
        [self.screenShareService broadcastResumed];
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
        [self.screenShareService broadcastFinished];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    [self.screenShareService processSampleBuffer:sampleBuffer withType:sampleBufferType];
}

- (void)MobileRTCScreenShareServiceFinishBroadcastWithError:(NSError *)error
{
    [self finishBroadcastWithError:error];
}

@end
