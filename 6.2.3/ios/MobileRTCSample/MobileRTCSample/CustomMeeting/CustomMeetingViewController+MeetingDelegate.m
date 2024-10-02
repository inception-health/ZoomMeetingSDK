//
//  CustomMeetingViewController+MeetingDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/10/12.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation CustomMeetingViewController (MeetingDelegate)

- (void)onMeetingStateChange:(MobileRTCMeetingState)state
{
    if (state == MobileRTCMeetingState_InMeeting) {
        [self.videoVC.preVideoView removeFromSuperview];
        [[[MobileRTC sharedRTC] getMeetingService] setParentViewCtroller:self];
        BOOL isWebinarAttendee = [[[MobileRTC sharedRTC] getMeetingService] isWebinarAttendee];
        if (isWebinarAttendee) {
            self.thumbView.hidden = YES;
        } else {
            self.thumbView.hidden = NO;
        }
    }
}

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    self.pinUserId = userID;
    [self updateVideoOrShare];
}

- (void)onSinkMeetingPreviewStopped
{
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    [self updateMyAudioStatus];

    [self updateVideoOrShare];
}

- (void)onSinkMeetingMyAudioTypeChange
{
    [self updateMyAudioStatus];
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    [self updateMyVideoStatus];

    [self updateVideoOrShare];
}

- (void)onMyVideoStateChange
{
    [self updateMyVideoStatus];

    [self updateVideoOrShare];
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
    [self updateVideoOrShare];
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
    [self updateVideoOrShare];
}

- (void)onSinkSharingStatus:(MobileRTCSharingStatus)status userID:(NSUInteger)userID
{
    if (status == MobileRTCSharingStatus_Self_Send_Begin) {
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        if ([ms isMeetingChatLegalNoticeAvailable]) {
            NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
            NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    [self updateMyShareStatus];
    if (status == MobileRTCSharingStatus_Self_Send_Begin)
    {
        if([[[MobileRTC sharedRTC] getMeetingService] isMyself:userID] && [[[MobileRTC sharedRTC] getMeetingService] isDeviceSharing]) { //share device
            return;
        }
        else [self showLocalShareView];
    }
    else if (status == MobileRTCSharingStatus_Other_Share_Begin)
    {
        self.remoteShareVC.activeShareID = userID;
        [self showRemoteShareView];
    }
    else if (status == MobileRTCSharingStatus_Self_Send_End ||
             status == MobileRTCSharingStatus_Other_Share_End)
    {
//        self.topPanelView.shrinkBtn.hidden = NO;
        [self hideAnnotationView];
        [self showVideoView];
    }
}

-(void)onIndicatorItemReceived:(MobileRTCIndicatorHandler *)inMeetingIndicatorHandler {
    [inMeetingIndicatorHandler showIndicatorPane:self.view originPoint:CGPointMake(80, 100)];
}

- (void)onIndicatorItemRemoved:(MobileRTCIndicatorHandler *)inMeetingIndicatorHandler {
    [inMeetingIndicatorHandler hideIndicatorPanel];
}


- (void)onShareFromMainSession:(NSInteger)iSharingID shareStatus:(MobileRTCSharingStatus)status shareAction:(MobileRTCShareAction *_Nullable)pShareAction {
    NSLog(@"--- %s status:%@",__FUNCTION__,@(status));
    switch (status) {
        case MobileRTCSharingStatus_Other_Share_Begin:
        {
            self.remoteShareVC.shareAction = pShareAction;
            [self showRemoteShareView];
        }
            break;
            
        case MobileRTCSharingStatus_Other_Share_End:
        {
            [self hideAnnotationView];
            [self showVideoView];
            self.remoteShareVC.shareAction = nil;
        }
            break;
            
        case MobileRTCSharingStatus_Pause:
        case MobileRTCSharingStatus_Resume:
            
            break;
        default:
            break;
    }
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    if (!self.remoteShareVC.parentViewController)
        return;

    [self.remoteShareVC.shareView changeShareScaleWithUserID:userID];
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
    if (!self.remoteShareVC.parentViewController)
        return;

    [self.remoteShareVC.shareView changeShareScaleWithUserID:userID];
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    if (needWaiting)
    {
#if 0
        MobileRTCWaitingRoomService *ws = [[MobileRTC sharedRTC] getWaitingRoomService];
        
        MobileRTCSDKError error = [ws getWaitingRoomCustomizeData];
        NSLog(@"getWaitingRoomCustomizeData = %@", @(error));
#endif
        
        UIViewController *vc = [UIViewController new];
        
        vc.title = @"Need wait for host Approve";
        
        UIBarButtonItem *leaveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Leave", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onEndButtonClick:)];
        [vc.navigationItem setRightBarButtonItem:leaveItem];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:NULL];
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)onEndButtonClick:(id)sender
{
    [self.actionPresenter leaveMeeting];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
