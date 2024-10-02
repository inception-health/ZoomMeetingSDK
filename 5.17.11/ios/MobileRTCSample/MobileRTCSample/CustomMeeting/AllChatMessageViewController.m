//
//  AllChatMessageViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2022/4/6.
//  Copyright © 2022 Zoom Video Communications, Inc. All rights reserved.
//

#import "AllChatMessageViewController.h"

@interface AllChatMessageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSMutableArray          *dataSource;
@end

@implementation AllChatMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"All Chat Message";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(messageAction:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    self.dataSource = [[[[MobileRTC sharedRTC] getMeetingService] getAllChatMessageID] mutableCopy];
    [self initTableView];
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Chat"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Send new topic chat message"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"123456\r This is a new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setQuotePosition:0 end:6] build];
        
                                                            bool ret = [ms sendChatMsg:newChat];
                                                            NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
            
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)                                                                                 style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = self.navigationItem.rightBarButtonItem.customView;
        popover.sourceRect = self.navigationItem.rightBarButtonItem.customView.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)initTableView
{
    float h;
    if (IPHONE_X) {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - SAFE_ZOOM_INSETS;
    } else {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - 20;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
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
    NSString * messageID = [self.dataSource objectAtIndex:indexPath.row];
    MobileRTCMeetingChat * chatInfo = [[[MobileRTC sharedRTC] getMeetingService] meetingChatByID:messageID];
    cell.textLabel.text = chatInfo.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * messageID = [self.dataSource objectAtIndex:indexPath.row];
    MobileRTCMeetingChat * chatInfo = [[[MobileRTC sharedRTC] getMeetingService] meetingChatByID:messageID];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if ([ms isChatMessageCanBeDeleted:messageID]) {
           
            [alertController addAction:[UIAlertAction actionWithTitle:@"Delete this chat message"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    bool ret = [ms deleteChatMessage:messageID];
                                                                    NSLog(@"deleteChatMessage==>%@", @(ret));
                                                                    if (ret) {
                                                                        [self.dataSource removeObject:messageID];
                                                                        [self.tableView reloadData];
                                                                    }
                                                                }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Comments this chat message"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"12345\r6 This\r is a comments"] setReceiver:0] setThreadId:chatInfo.threadID] setMessageType:MobileRTCChatMessageType_To_All] setQuotePosition:0 end:2] build];
        
                                                            bool ret = [ms sendChatMsg:newChat];
                                                            NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                            if (ret) {
                                                                self.dataSource = [[[[MobileRTC sharedRTC] getMeetingService] getAllChatMessageID] mutableCopy];
                                                                [self.tableView reloadData];
                                                            }
                                                        }]];
            
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)                                                                                 style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = cell;
        popover.sourceRect = cell.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
