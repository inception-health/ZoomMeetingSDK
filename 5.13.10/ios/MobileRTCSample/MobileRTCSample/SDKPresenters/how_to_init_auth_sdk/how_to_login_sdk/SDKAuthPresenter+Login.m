//
//  SDKAuthPresenter+Login.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/19.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKAuthPresenter+Login.h"

@implementation SDKAuthPresenter (Login)

- (NSString *)getSSODomainWithVanityURL:(NSString *)vanityURL
{
    return [[[MobileRTC sharedRTC] getAuthService] generateSSOLoginWebURL:vanityURL];
}

- (BOOL)ssoLoginWithWebUriProtocol:(NSString *)protocolURL
{
    MobileRTCLoginFailReason ret = [[[MobileRTC sharedRTC] getAuthService] ssoLoginWithWebUriProtocol:protocolURL];
    return ret != MobileRTCLoginFailReason_Success;
}

@end
