//
//  BOMeetingViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2020/2/13.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "BOMeetingViewController.h"

typedef NS_ENUM(NSUInteger, BOActions) {
    // creator
    BOCreator_CreateBO = 100,
    BOCreator_CreateBOInBatch,
    BOCreator_UpdateBO,
    BOCreator_RemoveBO,
    BOCreator_AssignUserToBO,
    BOCreator_RemoveUser,
    BOCreator_SetBOOption,
    BOCreator_GetBOOption,
    
    BOCreator_IsWebPreAssignBOEnabled,
    BOCreator_RequestAndUseWebPreAssignBOList,
    BOCreator_GetWebPreAssignBODataStatus,
    
    // Admin
    BOAdmin_StartBO,
    BOAdmin_StopBO,
    BOAdmin_AssignNewUserToBO,
    BOAdmin_SwitchUser,
    BOAdmin_CanStartBO,
    BOAdmin_BroadcastMessage,
    BOAdmin_BroadcastVoice,
    BOAdmin_HandleHelpRequest,
    BOCreator_InviteBOUserReturnToMainSession,
    
    // Assistant
    BOAssistant_JoinBO,
    BOAssistant_LeaveBO,
    
    // Attendee
    BOAttendee_JoinBO,
    BOAttendee_LeaveBO,
    BOAttendee_GetBOName,
    BOAttendee_RequestForHelp,
    BOAttendee_IsHostInThisBO,
    
    // BOData
    BODataHelper_UnsignedUserList,
    BODataHelper_BOMeetingIDList,
    BODataHelper_GetBOUser,
    BODataHelper_GetBOMeeting,
    BODataHelper_GetMyBOName,
    BODataHelper_IsBOUserMyself,
    
    // BOService
    BOService_GetBOStatus,
};

@interface BOMeetingViewController () <UITableViewDataSource, UITableViewDelegate, MobileRTCMeetingServiceDelegate>
@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSMutableArray          *dataSource;

@end

@implementation BOMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"BO Meeting";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    [self.navigationItem.leftBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    self.dataSource = [NSMutableArray array];
    [self initDataSource];
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:kBO_NOTIFICATION_DATA_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:kBO_NOTIFICATION_HELP_RECEIVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBroadcastMessageNoti:) name:kBO_NOTIFICATION_BRODCASET_RECEIVED object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    _dataSource = nil;
    _tableView = nil;
}

- (void)handleBOHelpInOrder {
    NSString *userId = [self handleRequsterIds:YES];
    [self updateTable];
    NSString *alertMsg = userId ? [NSString stringWithFormat:@"Request User:%@",userId] : @"No requested user found";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Join BO for Help"
                                                                             message:alertMsg
                                                   preferredStyle:UIAlertControllerStyleAlert];
    if (userId) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Accept"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            MobileRTCBOAdmin *admin = [[[MobileRTC sharedRTC] getMeetingService] getAdminHelper];
            if(admin) [admin joinBOByUserRequest:userId];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ignore"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
            MobileRTCBOAdmin *admin = [[[MobileRTC sharedRTC] getMeetingService] getAdminHelper];
            if(admin) [admin ignoreUserHelpRequest:userId];
        }]];
    } else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)handleRequsterIds:(BOOL)removed {
    NSArray *boUIdList = [[NSUserDefaults standardUserDefaults] objectForKey:kBO_HELP_REQUESTER_IDS];
    if (![boUIdList isKindOfClass:NSArray.class]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBO_HELP_REQUESTER_IDS];
        boUIdList = @[];
        [[NSUserDefaults standardUserDefaults] setObject:boUIdList forKey:kBO_HELP_REQUESTER_IDS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    } else {
        NSMutableArray *boUserList2Write = [NSMutableArray arrayWithArray:boUIdList];
        NSString *handleId = boUserList2Write.firstObject;
        if (removed) {
            [boUserList2Write removeObject:handleId];
            [[NSUserDefaults standardUserDefaults] setObject:boUserList2Write forKey:kBO_HELP_REQUESTER_IDS];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return handleId;
    }
}

- (void)onDone:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)initDataSource
{
    [self.dataSource removeAllObjects];
        
    MobileRTCBOCreator *creator = [[[MobileRTC sharedRTC] getMeetingService] getCreatorHelper];
    if (creator) {
        [self.dataSource addObject:@(BOCreator_CreateBO)];
        [self.dataSource addObject:@(BOCreator_CreateBOInBatch)];
        [self.dataSource addObject:@(BOCreator_UpdateBO)];
        [self.dataSource addObject:@(BOCreator_RemoveBO)];
        [self.dataSource addObject:@(BOCreator_AssignUserToBO)];
        [self.dataSource addObject:@(BOCreator_RemoveUser)];
        [self.dataSource addObject:@(BOCreator_SetBOOption)];
        [self.dataSource addObject:@(BOCreator_GetBOOption)];
        
        [self.dataSource addObject:@(BOCreator_IsWebPreAssignBOEnabled)];
        [self.dataSource addObject:@(BOCreator_RequestAndUseWebPreAssignBOList)];
        [self.dataSource addObject:@(BOCreator_GetWebPreAssignBODataStatus)];
        NSLog(@"---BO--- Get Own Creator");
    }
    
    MobileRTCBOData *dataHelper = [[[MobileRTC sharedRTC] getMeetingService] getDataHelper];
    if (dataHelper) {
        [self.dataSource addObject:@(BODataHelper_UnsignedUserList)];
        [self.dataSource addObject:@(BODataHelper_BOMeetingIDList)];
        [self.dataSource addObject:@(BODataHelper_GetBOUser)];
        [self.dataSource addObject:@(BODataHelper_GetBOMeeting)];
        [self.dataSource addObject:@(BODataHelper_GetMyBOName)];
        [self.dataSource addObject:@(BODataHelper_IsBOUserMyself)];
        
        NSLog(@"---BO--- Get Own DataHelper");
    }
    
    MobileRTCBOAdmin *admin = [[[MobileRTC sharedRTC] getMeetingService] getAdminHelper];
    if (admin) {
        [self.dataSource addObject:@(BOAdmin_StartBO)];
        [self.dataSource addObject:@(BOAdmin_StopBO)];
        [self.dataSource addObject:@(BOAdmin_AssignNewUserToBO)];
        [self.dataSource addObject:@(BOAdmin_SwitchUser)];
        [self.dataSource addObject:@(BOAdmin_CanStartBO)];
        [self.dataSource addObject:@(BOAdmin_BroadcastMessage)];
        [self.dataSource addObject:@(BOAdmin_BroadcastVoice)];
        [self.dataSource addObject:@(BOAdmin_HandleHelpRequest)];
        [self.dataSource addObject:@(BOCreator_InviteBOUserReturnToMainSession)];
        NSLog(@"---BO--- Get Own Admin");
    }
    
    MobileRTCBOAssistant *assistant = [[[MobileRTC sharedRTC] getMeetingService] getAssistantHelper];
    if (assistant) {
        [self.dataSource addObject:@(BOAssistant_JoinBO)];
        [self.dataSource addObject:@(BOAssistant_LeaveBO)];
        
        NSLog(@"---BO--- Get Own Assistant");
    }
    
    MobileRTCBOAttendee *attendee = [[[MobileRTC sharedRTC] getMeetingService] getAttedeeHelper];
    if (attendee) {
        [self.dataSource addObject:@(BOAttendee_JoinBO)];
        [self.dataSource addObject:@(BOAttendee_LeaveBO)];
        [self.dataSource addObject:@(BOAttendee_GetBOName)];
        [self.dataSource addObject:@(BOAttendee_RequestForHelp)];
        [self.dataSource addObject:@(BOAttendee_IsHostInThisBO)];
        
        NSLog(@"---BO--- Get Own Attendee");
    }
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms) {
        [self.dataSource addObject:@(BOService_GetBOStatus)];
    }
}

- (void)initTableView
{
    float h;
    if (IPHONE_X) {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - SAFE_ZOOM_INSETS;
    } else {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - 20;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero ];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedRowHeight = 0 ;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - MobileRTCMeetingServiceDelegate

- (void)updateTable {
    [self initDataSource];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSInteger index = [self.dataSource[indexPath.row] integerValue];
    NSString *cellName = [self getBOActionCaseName:index];
    cell.textLabel.text = cellName;
    return cell;
}

- (void)onBroadcastMessageNoti:(NSNotification *)noti {
    NSString *broadcastMsg = noti.object;
    if (![broadcastMsg isKindOfClass:NSString.class]) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"BO Boradcast"
                                                          message:[NSString stringWithFormat:@"Broadcast Msg:%@", broadcastMsg]
                                                   preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = [self.dataSource[indexPath.row] integerValue];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIAlertController *alertController = nil;
    
    MobileRTCBOCreator *creator = [[[MobileRTC sharedRTC] getMeetingService] getCreatorHelper];
    MobileRTCBOData *dataHelper = [[[MobileRTC sharedRTC] getMeetingService] getDataHelper];
    MobileRTCBOAdmin *admin = [[[MobileRTC sharedRTC] getMeetingService] getAdminHelper];
    MobileRTCBOAssistant *assistant = [[[MobileRTC sharedRTC] getMeetingService] getAssistantHelper];
    MobileRTCBOAttendee *attendee = [[[MobileRTC sharedRTC] getMeetingService] getAttedeeHelper];
    
    switch (index) {
        case BOCreator_CreateBO:
        {
            if (!creator) {
                NSLog(@"no object");
                return;
            }
            NSDate *date = [NSDate date];
            NSString *boName = [NSString stringWithFormat:@"BO%@", @([date timeIntervalSince1970])];
            NSString * boMeetingId = [creator createBO:boName];
            NSLog(@"creator create BO: %@", boMeetingId? @"Success" : @"Fail");
            
            alertController = [UIAlertController alertControllerWithTitle:@"Create BO Name"
                                                                  message:boName
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        case BOCreator_CreateBOInBatch:
        {
            if (!creator) {
                NSLog(@"no object");
                return;
            }
            NSMutableArray<NSString *> *boNameList = [NSMutableArray array];
            NSMutableString *batchBoNames = [@"" mutableCopy];
            for (int index = 0; index < 10; index++) {
                NSString *boName = [NSString stringWithFormat:@"Batch_BO_%02d", index + 1];
                [boNameList addObject:boName];
                [batchBoNames appendFormat:@"%@\n", boName];
            }
            
            BOOL ret = [creator createGroupBO:boNameList];
            NSLog(@"creator create BO: %@", ret? @"Success" : @"Fail");
            
            alertController = [UIAlertController alertControllerWithTitle:@"Create BO Names"
                                                                  message:batchBoNames
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        case BOCreator_UpdateBO:
            {
                if (!creator || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSString *boId = [[dataHelper getBOMeetingIDList] firstObject];
                
                NSDate *date = [NSDate date];
                NSString *boName = [NSString stringWithFormat:@"BO%@", @([date timeIntervalSince1970])];
                BOOL ret = [creator updateBO:boId name:boName];
                NSLog(@"creator update BO: %@", ret? @"Success" : @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"Update BO Name"
                                                                      message:[NSString stringWithFormat:@"Update Bo Name to:%@, Bo ID:%@",boName, boId]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
                break;
        case BOCreator_RemoveBO:
            {
                if (!creator || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSArray *boArr = [dataHelper getBOMeetingIDList];
                
                alertController = [UIAlertController alertControllerWithTitle:@"Remove BO"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < boArr.count; i++) {
                    NSString *boId = boArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        BOOL ret = [creator removeBO:boId];
                        NSLog(@"creator remove BO: %@", ret? @"Success" : @"Fail");
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
                break;
        case BOCreator_AssignUserToBO:
            {
                if (!creator || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSArray *unsignedUserArr = [dataHelper getUnassignedUserList];
                NSArray *meetingIDArr = [dataHelper getBOMeetingIDList];
                
                alertController = [UIAlertController alertControllerWithTitle:@"Assign all unsigned user to BO"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < meetingIDArr.count; i++) {
                    NSString *boId = meetingIDArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        for (int u = 0; u < unsignedUserArr.count; u++) {
                            NSString *userId = unsignedUserArr[u];
                            [creator assignUser:userId toBO:boId];
                        }
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
            break;
        case BOCreator_RemoveUser:
            {
                if (!creator || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *meetingIDArr = [dataHelper getBOMeetingIDList];
                
                alertController = [UIAlertController alertControllerWithTitle:@"Remove all user in one BO"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < meetingIDArr.count; i++) {
                    NSString *boId = meetingIDArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        NSArray *boUserList = [meeting getBOMeetingUserList];
                        for (int u = 0; u < boUserList.count; u++) {
                            NSString *userId = boUserList[u];
                            BOOL ret = [creator removeUser:userId fromBO:boId];
                            NSLog(@"creator remove user: %@", ret? @"Success" : @"Fail");
                        }
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
            break;
        case BOCreator_SetBOOption:
            {
                if (!creator) {
                    NSLog(@"no object");
                    return;
                }
                
                MobileRTCBOOption *option = [[MobileRTCBOOption alloc] init];
                option.countdownSeconds = MobileRTCBOStopCountDown_Seconds_30;
                option.isParticipantCanChooseBO = NO;
                option.isParticipantCanReturnToMainSessionAtAnyTime = NO;
                option.isAutoMoveAllAssignedParticipantsEnabled = NO;
                option.isBOTimerEnabled = YES;
                option.isTimerAutoStopBOEnabled = NO;
                option.timerDuration = 2 * 60;
                BOOL ret = [creator setBOOption:option];
                
                NSLog(@"creator setBOOption: %@", ret? @"Success" : @"Fail");
                NSString *alertMessageFmt = @"count_down_second:%@\n"
                @"isParticipantCanChooseBO:%@\n"
                @"isParticipantCanReturnToMainSessionAtAnyTime:%@\n"
                @"isAutoMoveAllAssignedParticipantsEnabled:%@\n"
                @"isBOTimerEnabled:%@\n"
                @"isTimerAutoStopBOEnabled:%@\n"
                @"timerDuration:%ds\n";
                NSString *alertMessage = [NSString stringWithFormat:alertMessageFmt,
                                          @"30 s",
                                          option.isParticipantCanChooseBO ? @"Y": @"N",
                                          option.isParticipantCanReturnToMainSessionAtAnyTime ? @"Y": @"N",
                                          option.isAutoMoveAllAssignedParticipantsEnabled ? @"Y": @"N",
                                          option.isBOTimerEnabled ? @"Y": @"N",
                                          option.isTimerAutoStopBOEnabled ? @"Y": @"N",
                                          option.timerDuration];
                
                alertController = [UIAlertController alertControllerWithTitle:@"creator setBOOption"
                                                                      message:alertMessage
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOCreator_GetBOOption:
            {
                if (!creator) {
                    NSLog(@"no object");
                    return;
                }
                
                MobileRTCBOOption *BOOption = [creator getBOOption];
                
                NSLog(@"creator getBOOption: %@", BOOption? @"Success" : @"Fail");
                
                NSString *alertMessageFmt = @"count_down_second:%@\n"
                @"isParticipantCanChooseBO:%@\n"
                @"isParticipantCanReturnToMainSessionAtAnyTime:%@\n"
                @"isAutoMoveAllAssignedParticipantsEnabled:%@\n"
                @"isBOTimerEnabled:%@\n"
                @"isTimerAutoStopBOEnabled:%@\n"
                @"timerDuration:%ds\n";
                NSString *alertMessage = [NSString stringWithFormat:alertMessageFmt,
                                          @(BOOption.countdownSeconds),
                                          BOOption.isParticipantCanChooseBO ? @"Y": @"N",
                                          BOOption.isParticipantCanReturnToMainSessionAtAnyTime ? @"Y": @"N",
                                          BOOption.isAutoMoveAllAssignedParticipantsEnabled ? @"Y": @"N",
                                          BOOption.isBOTimerEnabled ? @"Y": @"N",
                                          BOOption.isTimerAutoStopBOEnabled ? @"Y": @"N",
                                          BOOption.timerDuration];
                
                alertController = [UIAlertController alertControllerWithTitle:@"creator getBOOption"
                                                                      message:alertMessage
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
            
        case BOCreator_IsWebPreAssignBOEnabled:
            {
                if (!creator) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL *isWebPreAssignBOEnabled = [creator isWebPreAssignBOEnabled];
                
                NSLog(@"creator isWebPreAssignBOEnabled: %@", isWebPreAssignBOEnabled? @"Enabled" : @"Disabled");
                alertController = [UIAlertController alertControllerWithTitle:@"creator isWebPreAssignBOEnabled"
                                                                      message:isWebPreAssignBOEnabled? @"Enabled" : @"Disabled"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];

            }
            break;
        case BOCreator_RequestAndUseWebPreAssignBOList:
            {
                if (!creator) {
                    NSLog(@"no object");
                    return;
                }
                
                MobileRTCSDKError ret = [creator requestAndUseWebPreAssignBOList];
                
                NSLog(@"creator requestAndUseWebPreAssignBOList: %@", ret == MobileRTCSDKError_Success? @"Success" : @"Failed");
                
                alertController = [UIAlertController alertControllerWithTitle:@"creator requestAndUseWebPreAssignBOList"
                                                                      message:ret == MobileRTCSDKError_Success? @"Success" : @"Failed"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];

            }
            break;
        case BOCreator_GetWebPreAssignBODataStatus:
            {
                if (!creator) {
                    NSLog(@"no object");
                    return;
                }
                
                MobileRTCBOPreAssignBODataStatus status = [creator getWebPreAssignBODataStatus];
                
                NSLog(@"creator MobileRTCBOPreAssignBODataStatus: %@", @(status));
                
                alertController = [UIAlertController alertControllerWithTitle:@"creator getWebPreAssignBODataStatus: %@"
                                                               message:[NSString stringWithFormat:@"%@",@(status)]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];

            }
            break;
            
        // Admin
        case BOAdmin_StartBO:
            {
                if (!admin) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL ret = [admin startBO];
                NSLog(@"Amdin start BO: %@", ret? @"Success" : @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"Start BO"
                                                                      message:ret? @"Success" : @"Fail"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAdmin_StopBO:
            {
                if (!admin) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL ret = [admin stopBO];
                NSLog(@"Amdin stop BO: %@", ret? @"Success" : @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"Stop BO"
                                                                      message:ret? @"Success" : @"Fail"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAdmin_AssignNewUserToBO:
            {
                if (!admin || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *unsignedUserArr = [dataHelper getUnassignedUserList];
                NSArray *meetingIDArr = [dataHelper getBOMeetingIDList];
                
                alertController = [UIAlertController alertControllerWithTitle:@"Assign all unsigned user to BO"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < meetingIDArr.count; i++) {
                    NSString *boId = meetingIDArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        for (int u = 0; u < unsignedUserArr.count; u++) {
                            NSString *userId = unsignedUserArr[u];
                            BOOL ret = [admin assignNewUser:userId toRunningBO:boId];
                            NSLog(@"Amdin assign new user to BO: %@", ret? @"Success" : @"Fail");
                        }
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
            break;
        case BOAdmin_SwitchUser:
            {
                if (!admin || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSArray *meetingArr = [dataHelper getBOMeetingIDList];
                if (meetingArr.count < 2) {
                    alertController = [UIAlertController alertControllerWithTitle:@"SwitchUser"
                                                                          message:@"only one bo"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:nil]];
                    return;
                }
                
                MobileRTCBOMeeting *fromBO = [dataHelper getBOMeetingByID:[meetingArr firstObject]];
                MobileRTCBOMeeting *toBO = [dataHelper getBOMeetingByID:[meetingArr lastObject]];
                
                NSString *fromUserId = [[fromBO getBOMeetingUserList] firstObject];
                MobileRTCBOUser *inBOUser = [dataHelper getBOUserByUserID:fromUserId];
                BOOL ret = [admin switchUser:fromUserId toRunningBO:[toBO getBOMeetingId]];
                NSLog(@"Amdin switch user: %@", ret? @"Success" : @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"SwitchUser"
                                                                      message:[NSString stringWithFormat:@"switch %@ from %@ to %@: %@", inBOUser.getUserName, fromBO.getBOMeetingName, toBO.getBOMeetingName, ret? @"Success" : @"Fail"]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
            
        case BOAdmin_CanStartBO:
            {
                if (!admin)
                    return;
                BOOL ret = [admin canStartBO];
                alertController = [UIAlertController alertControllerWithTitle:@"Can start BO by Admin?"
                                                                      message:ret ? @"Yes, You can" : @"No, you can't"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAdmin_BroadcastMessage:
        {
            if (!admin)
                return;
            NSDate *date = [NSDate date];
            NSString *broadcastMsg = [NSString stringWithFormat:@"BO_MSG_%@", @([date timeIntervalSince1970])];
            BOOL sendResult = [admin broadcastMessage:broadcastMsg];
            alertController = [UIAlertController alertControllerWithTitle:@"BOAdmin_BroadcastMessage"
                                                                  message:sendResult ? @"Success" : @"Failed"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        case BOAdmin_BroadcastVoice:
        {
            if (!admin) return;
            MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
            BOOL isBroadcasting = [ms isBroadcastingVoiceToBO];
            NSString *alertTitle = @"Start BOAdmin_BroadcastVoice";
            if (isBroadcasting) {
                alertTitle = @"Stop BOAdmin_BroadcastVoice";
            }
            BOOL sendResult = [admin broadcastVoiceToBO:!isBroadcasting];
            alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                  message:sendResult ? @"Success" : @"Failed"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        case BOAdmin_HandleHelpRequest:
        {
            [self handleBOHelpInOrder];
        }
            break;
        case BOCreator_InviteBOUserReturnToMainSession:
            {
                if (!admin || !dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *meetingIDArr = [dataHelper getBOMeetingIDList];
                
                alertController = [UIAlertController alertControllerWithTitle:@"Invite all user return to main session"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < meetingIDArr.count; i++) {
                    NSString *boId = meetingIDArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        NSArray *boUserList = [meeting getBOMeetingUserList];
                        for (int u = 0; u < boUserList.count; u++) {
                            NSString *userId = boUserList[u];
                            BOOL ret = [admin inviteBOUserReturnToMainSession:userId];
                            NSLog(@"inviteBOUserReturnToMainSession: %@", ret? @"Success" : @"Fail");
                        }
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
            break;
            
            
        // Assistant
        case BOAssistant_JoinBO:
            {
                if (!assistant || !dataHelper ) {
                    NSLog(@"no object");
                    return;
                }
                                
                NSArray *meetingIDArr = [dataHelper getBOMeetingIDList];
                alertController = [UIAlertController alertControllerWithTitle:@"BOAssistant_JoinBO"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                for (int i = 0; i < meetingIDArr.count; i++) {
                    NSString *boId = meetingIDArr[i];
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:boId];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:meeting.getBOMeetingName
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                        [assistant joinBO:boId];
                    }]];
                }
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
            }
            break;
        case BOAssistant_LeaveBO:
            {
                if (!assistant) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL ret = [assistant leaveBO];
                NSLog(@"assistant leave BO: %@", ret? @"Success": @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"BOAssistant_LeaveBO"
                                                                      message:ret? @"Success": @"Fail"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
            
            
        // Attendee
        case BOAttendee_JoinBO:
            {
                if (!attendee) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL ret = [attendee joinBO];
                NSLog(@"attendee join BO: %@", ret? @"Success": @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"BOAttendee_JoinBO"
                                                                      message:ret? @"Success": @"Fail"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAttendee_LeaveBO:
            {
                if (!attendee) {
                    NSLog(@"no object");
                    return;
                }
                
                BOOL ret = [attendee leaveBO];
                NSLog(@"attendee leave BO: %@", ret? @"Success": @"Fail");
                
                alertController = [UIAlertController alertControllerWithTitle:@"BOAttendee_LeaveBO"
                                                                      message:ret? @"Success": @"Fail"
                                                               preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAttendee_GetBOName:
            {
                if (!attendee) {
                    NSLog(@"no object");
                    return;
                }
                
                NSString *boName = [attendee getBOName];
                NSLog(@"attendee BO name: %@", boName);
                alertController = [UIAlertController alertControllerWithTitle:@"BOAttendee_GetBOName"
                                                                                         message:boName
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOAttendee_RequestForHelp:
        {
            if (!attendee) {
                NSLog(@"no object");
                return;
            }
            
            BOOL requestResult = [attendee requestForHelp];
            NSString *resultMsg = requestResult? @"succeed" : @"failed";
            alertController = [UIAlertController alertControllerWithTitle:@"BOAttendee_RequestForHelp"
                                                                  message:resultMsg
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        case BOAttendee_IsHostInThisBO:
        {
            if (!attendee) {
                NSLog(@"no object");
                return;
            }
            
            BOOL requestResult = [attendee isHostInThisBO];
            NSString *resultMsg = [NSString stringWithFormat:@"host now is %@ current BO meeting", requestResult? @"in" : @"not in"];
            alertController = [UIAlertController alertControllerWithTitle:@"BOAttendee_RequestForHelp"
                                                                  message:resultMsg
                                                           preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            break;
        // BOData
        case BODataHelper_UnsignedUserList:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *arr = [dataHelper getUnassignedUserList];
                NSLog(@"datahelper un-assigned user: %@", [arr description]);
                
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_UnsignedUserList"
                                                                                         message:[arr description]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BODataHelper_BOMeetingIDList:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *arr = [dataHelper getBOMeetingIDList];
                
                NSString *meetingInfo = @"";
                for (NSString *meetingID in arr) {
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:meetingID];
                    meetingInfo = [meetingInfo stringByAppendingFormat:@"ID:%@, Name:%@\n", meeting.getBOMeetingId, meeting.getBOMeetingName];
                }
                
                
                NSLog(@"datahelper get bo meeting list: %@", [arr description]);
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_BOMeetingIDList"
                                                                                         message:meetingInfo
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BODataHelper_GetBOUser:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *unAssignUserArr = [dataHelper getUnassignedUserList];
                NSArray *meetingArr = [dataHelper getBOMeetingIDList];
                MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:[meetingArr firstObject]];
                NSString *inBOUserId = [[meeting getBOMeetingUserList] firstObject];
                
                MobileRTCBOUser *unassignboUser = [dataHelper getBOUserByUserID:[unAssignUserArr firstObject]];
                MobileRTCBOUser *inBOUser = [dataHelper getBOUserByUserID:inBOUserId];
                NSLog(@"datahelper bo unassign user: %@, in bo user: %@", [unassignboUser description], [inBOUser description]);
                
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_GetBOUser"
                                                                                         message:[NSString stringWithFormat:@"unassignboUser:%@,inBOUser:%@", [unassignboUser description], [inBOUser description]]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BODataHelper_GetBOMeeting:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                
                NSArray *meetingArr = [dataHelper getBOMeetingIDList];
                MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:[meetingArr firstObject]];
                
                NSLog(@"datahelper bo meeting: %@", [meeting description]);
                
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_GetBOMeeting"
                                                                                         message:[meeting description]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BODataHelper_GetMyBOName:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSString *currentBOName = [dataHelper getCurrentBOName];
                NSLog(@"datahelper current meeting name: %@", currentBOName);
                
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_GetMyBOName"
                                                                                         message:currentBOName
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BODataHelper_IsBOUserMyself:
            {
                if (!dataHelper) {
                    NSLog(@"no object");
                    return;
                }
                NSArray *unAssignUserArr = [dataHelper getUnassignedUserList];
                NSArray *meetingArr = [dataHelper getBOMeetingIDList];
                NSMutableString *alertText = [@"" mutableCopy];
                for (NSString *userId in unAssignUserArr) {
                    NSString *boolText = [dataHelper isBOUserMyself:userId] ? @"YES" : @"NO";
                    [alertText appendFormat:@"%@-%@\n", userId, boolText];
                }
                for (NSString *meetingID in meetingArr) {
                    MobileRTCBOMeeting *meeting = [dataHelper getBOMeetingByID:meetingID];
                    NSArray *userList = [meeting getBOMeetingUserList];
                    for (NSString *userId in userList) {
                        NSString *boolText = [dataHelper isBOUserMyself:userId] ? @"YES" : @"NO";
                        
                        [alertText appendFormat:@"%@-%@\n",userId, boolText];
                    }
                }
                
                alertController = [UIAlertController alertControllerWithTitle:@"BODataHelper_IsBOUserMyself"
                                                                                         message:alertText
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
            }
            break;
        case BOService_GetBOStatus:
        {
            MobileRTCBOStatus boStatus = [[[MobileRTC sharedRTC] getMeetingService] getBOStatus];
            alertController = [UIAlertController alertControllerWithTitle:@"BOService_GetBOStatus"
                                                                                     message:[NSString stringWithFormat:@"BOService_GetBOStatus = %@",@(boStatus)]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
        }
            
        default:
            NSLog(@"not support now");
            break;
    }
    
    if (alertController) {
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = cell;
            popover.sourceRect = cell.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSString *)getBOActionCaseName:(NSInteger)value {
    switch (value) {
        // creator
        case BOCreator_CreateBO:
            return @"BOCreator_CreateBO";
        case BOCreator_CreateBOInBatch:
            return @"BOCreator_CreateBOInBatch";
        case BOCreator_UpdateBO:
            return @"BOCreator_UpdateBO";
        case BOCreator_RemoveBO:
            return @"BOCreator_RemoveBO";
        case BOCreator_AssignUserToBO:
            return @"BOCreator_AssignUserToBO";
        case BOCreator_RemoveUser:
            return @"BOCreator_RemoveUser";
        case BOCreator_SetBOOption:
            return @"BOCreator_SetBOOption";
        case BOCreator_GetBOOption:
            return @"BOCreator_GetBOOption";

        // Admin
        case BOAdmin_StartBO:
            return @"BOAdmin_StartBO";
        case BOAdmin_StopBO:
            return @"BOAdmin_StopBO";
        case BOAdmin_AssignNewUserToBO:
            return @"BOAdmin_AssignNewUserToBO";
        case BOAdmin_SwitchUser:
            return @"BOAdmin_SwitchUser";
        case BOAdmin_CanStartBO:
            return @"BOAdmin_CanStartBO";
        case BOAdmin_BroadcastMessage:
            return @"BOAdmin_BroadcastMessage";
        case BOAdmin_BroadcastVoice:
        {
            NSString *result = @"Start BOAdmin_BroadcastVoice";
            MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
            if(ms && [ms isBroadcastingVoiceToBO]) {
                result = @"Stop BOAdmin_BroadcastVoice";
            }
            return result;
        }
        case BOAdmin_HandleHelpRequest:
        {
            NSString *helpReqCellName = @"BOAdmin_HandleHelpRequest";
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kBO_HELP_REQUESTER_IDS];
            if (!(array && [array isKindOfClass:NSArray.class])) {
                return helpReqCellName;
            }
            helpReqCellName = [NSString stringWithFormat:@"%@(%@)", helpReqCellName, @(array.count)];
            return helpReqCellName;
        }
        case BOCreator_InviteBOUserReturnToMainSession:
            return @"BOCreator_InviteBOUserReturnToMainSession";
        
        // Assistant
        case BOAssistant_JoinBO:
            return @"BOAssistant_JoinBO";
        case BOAssistant_LeaveBO:
            return @"BOAssistant_LeaveBO";
        
        // Attendee
        case BOAttendee_JoinBO:
            return @"BOAttendee_JoinBO";
        case BOAttendee_LeaveBO:
            return @"BOAttendee_LeaveBO";
        case BOAttendee_GetBOName:
            return @"BOAttendee_GetBOName";
        case BOAttendee_RequestForHelp:
            return @"BOAttendee_RequestForHelp";
        case BOAttendee_IsHostInThisBO:
            return @"BOAttendee_IsHostInThisBO";
        
        // BOData
        case BODataHelper_UnsignedUserList:
            return @"BODataHelper_UnsignedUserList";
        case BODataHelper_BOMeetingIDList:
            return @"BODataHelper_BOMeetingIDList";
        case BODataHelper_GetBOUser:
            return @"BODataHelper_GetBOUser";
        case BODataHelper_GetBOMeeting:
            return @"BODataHelper_GetBOMeeting";
        case BODataHelper_GetMyBOName:
            return @"BODataHelper_GetMyBOName";
        case BODataHelper_IsBOUserMyself:
            return @"BODataHelper_IsBOUserMyself";
            
        case BOService_GetBOStatus:
            return @"BOService_GetBOStatus";
            
        default:
            return @"not support";
    }
}

@end
