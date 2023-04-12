//
//  SDKInitPresenter.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/19.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKInitPresenter.h"

@implementation SDKInitPresenter

+ (void)SDKInit:(UINavigationController *)navVC
{
    //1. initSDK
//    [MobileRTC initializeWithDomain:kSDKDomain enableLog:YES];
//    [[MobileRTC sharedRTC] setMobileRTCDomain:kSDKDomain];
    
    MobileRTCSDKInitContext *context = [[MobileRTCSDKInitContext alloc] init];
    context.domain = kSDKDomain;
    context.enableLog = YES;
    context.locale = MobileRTC_ZoomLocale_Default;

    /**
     * if you need use screen share feature, Here are a few things to note:
     * <1> Create your own groupId on the Apple Developer Web site, and fill the group ID in here and in the SampleHandler.mm
     * <2> Create an "App Groups" Capability in the main project target and the replayKit project target, and select the groupId correctly.
     * <3> If you can't select groupId correctly in "App Groups" Capability, Please check MobileRTCSample.Entitlements and MobileRTCSampleScreenShare.entitlements this two files, here also need to configure the correct group id. etc:
     *   <key>com.apple.security.application-groups</key>
         <array>
             <string> your group id </string>
         </array
     *
     * For details, please refer: https://marketplace.zoom.us/docs/sdk/native-sdks/iOS/mastering-zoom-sdk/in-meeting-function/screen-share
     *
     * if you don't need screen share feature, appGroupId can fill an empty string, or delete the bottom line. And delete MobileRTCSampleScreenShare target.
     */
    context.appGroupId = <#Group ID#>;
    BOOL initializeSuc = [[MobileRTC sharedRTC] initialize:context];
    NSLog(@"MobileRTC initialize======>%@",initializeSuc ? @"success" : @"Fail");
    
    NSLog(@"MobileRTC Version: %@", [[MobileRTC sharedRTC] mobileRTCVersion]);
    
//    // 2.This method is optional, MobileRTC will read Custom Localizable file from App’s main bundle first.
//       [[MobileRTC sharedRTC] setMobileRTCCustomLocalizableName:@"Custom"];
//   //3. Set Root Navigation Controller
//   //Note: This step is optional, If app’s rootViewController is not a UINavigationController, just ignore this step.
    [[MobileRTC sharedRTC] setMobileRTCRootController:navVC];
}

//- (BOOL)isChinaLocale
//{
//    NSString *localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//    return (localeIdentifier.length > 0 && ([localeIdentifier hasSuffix:@"_CN"] || ([localeIdentifier rangeOfString:@"_CN_"].location != NSNotFound)));
//}

@end
