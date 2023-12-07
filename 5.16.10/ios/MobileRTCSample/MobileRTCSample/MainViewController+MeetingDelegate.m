//
//  MainViewController+MeetingDelegate.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/12/5.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "MainViewController+MeetingDelegate.h"
#import "SendYUVAdapter.h"

@implementation MainViewController (MeetingDelegate)

- (void)onJoinMeetingInfo:(MobileRTCJoinMeetingInfo)info
               completion:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion
{
    if (completion)
        self.joinMeetingBlock = completion;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please input display name and password", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    alert.tag = 10022;
    switch (info) {
        case MobileRTCJoinMeetingInfo_NeedName:
            alert.message = NSLocalizedString(@"Please input display name", @"");
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            break;
        case MobileRTCJoinMeetingInfo_NeedPassword:
            alert.message = NSLocalizedString(@"Please input password", @"");
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            break;
        case MobileRTCJoinMeetingInfo_WrongPassword:
            alert.message = NSLocalizedString(@"Password Wrong! Please input password", @"");
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            break;
        case MobileRTCJoinMeetingInfo_NeedNameAndPwd:
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [alert textFieldAtIndex:0].placeholder = @"input display name";
            [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
            break;
        default:
            break;
    }

    [alert show];
}

- (void)onMeetingStateChange:(MobileRTCMeetingState)state;
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];

    if (state == MobileRTCMeetingState_Ended) {
        [self.view insertSubview:self.webVC.view aboveSubview:self.splashVC.view];
        [self.view insertSubview:self.introVC.view aboveSubview:self.webVC.view];
        
        [self.view bringSubviewToFront:self.meetButton];
        [self.view bringSubviewToFront:self.joinButton];
        [self.view bringSubviewToFront:self.expandButton];
        [self.view bringSubviewToFront:self.shareButton];
        [self.view bringSubviewToFront:self.settingButton];
    }
    
    BOOL inAppShare = (state == MobileRTCMeetingState_InMeeting) && [ms isDirectAppShareMeeting];
    self.expandButton.hidden = !inAppShare;
    self.shareButton.hidden = !inAppShare;
    self.meetButton.hidden = inAppShare;
    self.joinButton.hidden = inAppShare;
    
    if (state != MobileRTCMeetingState_InMeeting)
    {
        self.isSharingWebView = NO;
    }
    
#if 1
    if (state == MobileRTCMeetingState_InMeeting)
    {
        //For customizing the content of Invite by SMS
        NSString *meetingNumber = [[MobileRTCInviteHelper sharedInstance] ongoingMeetingNumber];
        NSString *smsMessage = [NSString stringWithFormat:NSLocalizedString(@"Please join meeting with ID: %@", @""), meetingNumber];
        [[MobileRTCInviteHelper sharedInstance] setInviteSMS:smsMessage];
        
        //For customizing the content of Copy URL
        NSString *joinURL = [[MobileRTCInviteHelper sharedInstance] joinMeetingURL];
        NSString *copyURLMsg = [NSString stringWithFormat:NSLocalizedString(@"Meeting URL: %@", @""), joinURL];
        [[MobileRTCInviteHelper sharedInstance] setInviteCopyURL:copyURLMsg];
    }
    
    else if(state == MobileRTCMeetingState_WebinarPromote)
    {
        NSLog(@"onMeetingStateChange MobileRTCMeetingState_WebinarPromote");
    }
    
    else if(state == MobileRTCMeetingState_WebinarDePromote)
    {
        NSLog(@"onMeetingStateChange MobileRTCMeetingState_WebinarDePromote");
    }
#endif
    
#if 0
    //For adding customize view above the meeting view
    if (state == MobileRTCMeetingState_InMeeting)
    {
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        UIView *v = [ms meetingView];
        
        CGFloat offsetY = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 220 : 180;
        UIView *sv = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, v.frame.size.width, 50)];
        sv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        sv.backgroundColor = [UIColor redColor];
        [v addSubview:sv];
    }
    
#endif
    
    if (state == MobileRTCMeetingState_InMeeting)
    {
#if 0
        // Test Send raw data
        MobileRTCVideoSourceHelper *videoSourceHelper = [[MobileRTCVideoSourceHelper alloc] init];
        SendYUVAdapter *yuvAdapter = [[SendYUVAdapter alloc] init];
        [videoSourceHelper setExternalVideoSource:yuvAdapter];
#endif
        
#if 0
        // Test setMeetingTopic
        [[[MobileRTC sharedRTC] getMeetingService] setMeetingTopic:@"test"];
#endif
    }
}

- (void)onMeetingReady
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if ([ms isDirectAppShareMeeting])
    {
        if ([ms isStartingShare] || [ms isViewingShare])
        {
            NSLog(@"There exist an ongoing share");
            [ms showMobileRTCMeeting:^(void){
                [ms stopAppShare];
            }];
            return;
        }
        
        BOOL ret = [ms startAppShare];
        NSLog(@"Start App Share... ret:%a", @(ret));
    }
    
    //    [self startClockTimer];
}

- (void)onAppShareSplash
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms)
    {
        [ms appShareWithView:self.splashVC.view];
        [self.shareButton setImage:[UIImage imageNamed:@"icon_resume"] forState:UIControlStateNormal];
        self.isSharingWebView = NO;
    }
}

- (BOOL)onClickedShareButton:(UIViewController*)parentVC addShareActionItem:(NSMutableArray *)array
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms && [ms isDirectAppShareMeeting])
    {
//        if ([ms isStartingShare] || [ms isViewingShare])
//        {
//            NSLog(@"There exist an ongoing share");
//            return YES;
//        }
//
//        [ms hideMobileRTCMeeting:^(void){
//            [ms startAppShare];
//        }];
        
        [ms hideMobileRTCMeeting:^(void){
            if (![ms isStartingShare] && ![ms isViewingShare]) {
                [ms startAppShare];
            }
        }];
        
        return YES;
    }
    
    return NO;
    
#if 0
    //Sample For Add custom share action item
    MobileRTCMeetingShareActionItem * item = [MobileRTCMeetingShareActionItem itemWithTitle:@"Demo share" Tag:1];
    
    item.delegate = self;
    
    [array addObject:item];
    
    return NO;
#endif
}

//Sample for add customized share item
- (void)onShareItemClicked:(NSUInteger)tag completion:(BOOL (^)(UIViewController* shareView))completion
{
    SplashViewController *splashctrl = [SplashViewController new];
    
    if (completion && splashctrl)
    {
        BOOL ret = completion(splashctrl);
        NSLog(@"%@",@(ret));
    }
}

- (void)onJBHWaitingWithCmd:(JBHCmd)cmd
{
    switch (cmd) {
        case JBHCmd_Show:
        {
            UIViewController *vc = [UIViewController new];
            
            NSString *meetingNumber = [MobileRTCInviteHelper sharedInstance].ongoingMeetingNumber;
            vc.title = meetingNumber;
            
            UIBarButtonItem *leaveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Leave", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onLeave:)];
            [vc.navigationItem setRightBarButtonItem:leaveItem];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:NULL];
        }
            break;
            
        case JBHCmd_Hide:
        default:
        {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
            break;
    }
}

- (BOOL)onClickedInviteButton:(UIViewController*)parentVC addInviteActionItem:(NSMutableArray *)inListArray
{
    //Sample For Add custom invite action item
    MobileRTCMeetingInviteActionItem * item = [MobileRTCMeetingInviteActionItem itemWithTitle:@"test" Action:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"add invite item test", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alert show];
    }];

    [inListArray addObject:item];
    return NO;

    //Sample For show user customized InviteViewController
//    InviteViewController *inviteVC = [[InviteViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:inviteVC];
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
//
//    [parentVC presentViewController:nav animated:YES completion:NULL];
//    return YES;
}

- (BOOL)onClickedParticipantsButton:(UIViewController*)parentVC
{
    InviteViewController *inviteVC = [[InviteViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:inviteVC];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [parentVC presentViewController:nav animated:YES completion:NULL];
    
    return YES;
}

- (BOOL)onClickedEndButton:(UIViewController*)parentVC endButton:(UIButton *)endButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    

    
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    if (ms) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Leave Meeting"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms leaveMeetingWithCmd:LeaveMeetingCmd_Leave];
                                                          }]];
        if ([ms isMeetingHost]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"End Meeting"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [ms leaveMeetingWithCmd:LeaveMeetingCmd_End];
                                                              }]];
        }
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = endButton;
        popover.sourceRect = endButton.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
    
    return YES;
}

- (void)onClickedDialOut:(UIViewController*)parentVC isCallMe:(BOOL)me
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms)
        return;
    
    if ([ms isDialOutInProgress])
    {
        NSLog(@"There already exists an ongoing call");
        return;
    }
    
    NSString *callName = me ? nil : @"Dialer";
    BOOL ret = [ms dialOut:@"+866004" isCallMe:me withName:callName];
    NSLog(@"Dial out result: %@", @(ret));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dial out"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"cancel dial out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [ms cancelDialOut:NO];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"is Dial out inprogress" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            BOOL ret = [ms isDialOutInProgress];
            NSLog(@"isDialOutInProgress : %@", @(ret));
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
        
    });
}

@end
