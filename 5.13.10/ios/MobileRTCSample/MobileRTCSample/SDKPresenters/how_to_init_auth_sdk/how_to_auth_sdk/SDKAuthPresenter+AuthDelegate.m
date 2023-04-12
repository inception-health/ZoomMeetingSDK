//
//  SDKAuthPresenter+authDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/21.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKAuthPresenter+AuthDelegate.h"

@implementation SDKAuthPresenter (AuthDelegate)
    
- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue
{
    NSLog(@"MobileRTC onMobileRTCAuthReturn %@", returnValue == 0 ? @"Success" : @(returnValue));
    
    if (returnValue != MobileRTCAuthError_Success)
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"SDK authentication failed, error code: %zd", @""), returnValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:NSLocalizedString(@"Retry", @""), nil];
        [alert show];
    }
}

- (void)onMobileRTCLoginResult:(MobileRTCLoginFailReason)resultValue
{
    NSLog(@"MobileRTC onMobileRTCLoginResult result: %@", resultValue == MobileRTCLoginFailReason_Success ? @"Success" : @(resultValue));
    if (resultValue == MobileRTCLoginFailReason_Success) {
        MobileRTCAccountInfo *accoutInfo = [[[MobileRTC sharedRTC] getAuthService] getAccountInfo];
        MobileRTCUserType userType = [[[MobileRTC sharedRTC] getAuthService] getUserType];
        NSLog(@"accoutInfo:%@, User Type:%@", accoutInfo.debugDescription, @(userType));
    }
}

- (void)onMobileRTCLogoutReturn:(NSInteger)returnValue
{
    NSLog(@"MobileRTC onMobileRTCLogoutReturn result=%zd", returnValue);
}

@end
