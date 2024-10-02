//
//  SDKStartJoinMeetingPresenter+PollingServiceDelegate.m
//  MobileRTCSample
//
//  Created by Murray Li on 2023/12/1.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+PollingServiceDelegate.h"
#import "PollingViewController.h"

@implementation SDKStartJoinMeetingPresenter (PollingServiceDelegate)

- (void)onPollingStatusChanged:(NSString*_Nullable)pollingID status:(MobileRTCPollingStatus)status
{
    NSLog(@"---Polling--- OonPollingStatusChanged pollingID=%@ status=%@", pollingID, @(status));
}
- (void)onPollingResultUpdated:(NSString*_Nullable)pollingID
{
    NSLog(@"---Polling--- onPollingResultUpdated pollingID=%@", pollingID);
}
- (void)onPollingListUpdated
{
    NSLog(@"---Polling--- onPollingListUpdated");
    [[NSNotificationCenter defaultCenter] postNotificationName:kPOLLING_NOTIFICATION_DATA_UPDATE object:nil];
}
- (void)onPollingActionResult:(MobileRTCPollingActionType)actionType pollingID:(NSString*_Nullable)pollingID bSuccess:(BOOL)bSuccess errorMsg:(NSString*_Nullable)errorMsg
{
    NSLog(@"---Polling--- onPollingActionResult actionType=%@ pollingID=%@ bSuccess=%@ errorMsg=%@", @(actionType), pollingID, @(bSuccess), errorMsg);
}
- (void)onPollingQuestionImageDownloaded:(NSString*_Nullable)questionID path:(NSString*_Nullable)path
{
    NSLog(@"---Polling--- onPollingQuestionImageDownloaded questionID=%@ path=%@", questionID, path);
}
- (void)onPollingElapsedTime:(NSString*_Nullable)pollingID uElapsedtime:(int)uElapsedtime
{
    NSLog(@"---Polling--- onPollingElapsedTime pollingID=%@ uElapsedtime=%@", pollingID, @(uElapsedtime));
}
- (void)onGetRightAnswerListPrivilege:(BOOL)bCan
{
    NSLog(@"---Polling--- onGetRightAnswerListPrivilege bCan=%@", @(bCan));
}

- (void)onPollingInactive
{
    NSLog(@"---Polling--- onPollingInactive");
}

@end
