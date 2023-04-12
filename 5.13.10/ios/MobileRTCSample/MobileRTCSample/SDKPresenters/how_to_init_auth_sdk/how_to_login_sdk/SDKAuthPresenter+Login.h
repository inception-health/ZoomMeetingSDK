//
//  SDKAuthPresenter+Login.h
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/19.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKAuthPresenter.h"

@interface SDKAuthPresenter (Login)

- (NSString *)getSSODomainWithVanityURL:(NSString *)vanityURL;

- (BOOL)ssoLoginWithWebUriProtocol:(NSString *)protocolURL;

@end
