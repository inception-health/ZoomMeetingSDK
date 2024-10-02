//
//  SDKStartJoinMeetingPresenter+ShareServiceDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+ShareServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"
#import "MainViewController+MeetingDelegate.h"

@implementation SDKStartJoinMeetingPresenter (ShareServiceDelegate)

- (void)onSinkSharingStatus:(MobileRTCSharingStatus)status userID:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkSharingStatus==%@ userID==%@", @(status),@(userID));
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onSinkSharingStatus:userID:)])
    {
        [self.customMeetingVC onSinkSharingStatus:status userID:userID];
    }
}

- (void)onShareContentChanged:(MobileRTCShareContentType)shareContentType {
    NSLog(@"-- %s %@",__FUNCTION__,@(shareContentType));
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkShareSizeChange==%@",@(userID));
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onSinkShareSizeChange:)])
    {
        [self.customMeetingVC onSinkShareSizeChange:userID];
    }
}

- (void)onAppShareSplash
{
    NSLog(@"MobileRTC onAppShareSplash");
    if (self.mainVC) {
        [self.mainVC onAppShareSplash];
    }
}

- (void)onSinkShareSettingTypeChanged:(MobileRTCShareSettingType)shareSettingType {
    NSLog(@"MobileRTC onSinkShareSettingTypeChanged==%lu", shareSettingType);
}
- (void)onShareFromMainSession:(NSInteger)iSharingID shareStatus:(MobileRTCSharingStatus)status shareAction:(MobileRTCShareAction *_Nullable)pShareAction {
    NSLog(@" %s ", __FUNCTION__);
    if (self.customMeetingVC && [self.customMeetingVC respondsToSelector:@selector(onShareFromMainSession:shareStatus:shareAction:)])
    {
        [self.customMeetingVC onShareFromMainSession:iSharingID shareStatus:status shareAction:pShareAction];
    }
}
@end
