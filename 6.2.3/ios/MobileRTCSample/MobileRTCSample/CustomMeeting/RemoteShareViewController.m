//
//  RemoteShareViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 27/11/2017.
//  Copyright © 2017 Zoom Video Communications, Inc. All rights reserved.
//

#import "RemoteShareViewController.h"
#import "CustomRemoteControl.h"

@interface RemoteShareViewController ()

@property (strong, nonatomic) CustomRemoteControl *remoteControl;

@end

@implementation RemoteShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.shareView];
    
    [self.remoteControl setupRemoteControl:self.shareView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.shareView = nil;
    self.remoteControl = nil;
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_shareAction) {
        [self.view addSubview: [_shareAction getActiveShareView]];
        [_shareAction getActiveShareView].frame = CGRectMake(50, 100, CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
        [_shareAction setShareActionDelegate:self];
    }
    else {
        [self.view addSubview:self.shareView];
        
        [self.remoteControl setupRemoteControl:self.shareView];
    }
    [self updateShareView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_shareAction) {
        [_shareAction unsubscribe];
        [[_shareAction getActiveShareView] removeFromSuperview];
    }
    else {
        [self.shareView stopActiveShare];
    }
}

-(void)onSharingContentStartReceiving {
    NSLog(@"--- %s -- %@",__func__,_shareAction.description);
}
-(void)onActionBeforeDestroyed:(NSUInteger)sharingID {
    NSLog(@"--- %s -sharingID:%lu - %@ ",__func__,(unsigned long)sharingID,_shareAction.description);
}
#pragma mark - MobileRTCVideoView

- (MobileRTCActiveShareView *)shareView
{
    if (!_shareView)
    {
        _shareView = [[MobileRTCActiveShareView alloc] initWithFrame:self.view.bounds];
    }
    return _shareView;
}

- (void)updateShareView
{
    if (_shareAction) {
        
        NSLog(@"_shareAction :%@",_shareAction.description);
        [_shareAction subscribe];
        
    }
    else {
        if (0 != self.activeShareID)
        {
            [self.shareView showActiveShareWithUserID:self.activeShareID];
            MobileRTCAnnotationService *as = [[MobileRTC sharedRTC] getAnnotationService];
            if (as) [as startAnnotationWithSharedView:self.shareView];
        }
        else
        {
            [self.shareView stopActiveShare];
        }
    }
   
}


- (void)stopShareView {
    [self.shareView stopActiveShare];
}

#pragma mark - CustomRemoteControl
- (CustomRemoteControl *)remoteControl
{
    if (!_remoteControl)
    {
        _remoteControl = [[CustomRemoteControl alloc]init];
    }
    
    return _remoteControl;
}
@end
