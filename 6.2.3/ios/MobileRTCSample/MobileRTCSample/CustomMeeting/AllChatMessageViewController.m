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
    [alertController addAction:[UIAlertAction actionWithTitle:@"Quote"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setQuotePosition:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"un Quote"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setQuotePosition:4 end:18] unsetQuotePosition:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Italic"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setItalic:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un Italic"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setItalic:4 end:18] unsetItalic:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Bold"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBold:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un Bold"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBold:4 end:18] unsetBold:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Strikethrough"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setStrikethrough:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un Strikethrough"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setStrikethrough:4 end:18] unsetStrikethrough:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"BulletedList"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        NSString *content = @"This is a  你好，我有一个帽衫 \r new topic chat message";
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:content] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBulletedList:0 end:content.length] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un BulletedList"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        NSString *content = @"This is a  你好，我有一个帽衫 \r new topic chat message";
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:content] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBulletedList:0 end:content.length] unsetBulletedList:0 end:content.length] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"NumberedList"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        NSString *content = @"This is a  你好，我有一个帽衫 \r new topic chat message";
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:content] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setNumberedList:0 end:content.length] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un NumberedList"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        NSString *content = @"This is a  你好，我有一个帽衫 \r new topic chat message";
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:content] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setNumberedList:0 end:content.length] unsetNumberedList:0 end:content.length] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Underline"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setUnderline:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un Underline"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setUnderline:4 end:18] unsetUnderline:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"FontSize"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCFontSizeAttrs *sizeAttr = [[MobileRTCFontSizeAttrs alloc] init];
        sizeAttr.fontSize = FontSize_Large;
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setFontSize:sizeAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un FontSize"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCFontSizeAttrs *sizeAttr = [[MobileRTCFontSizeAttrs alloc] init];
        sizeAttr.fontSize = FontSize_Large;
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setFontSize:sizeAttr start:4 end:18] unsetFontSize:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"InsertLink"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCInsertLinkAttrs *linkAttr = [[MobileRTCInsertLinkAttrs alloc] init];
        linkAttr.insertLinkUrl = @"https://www.google.com";
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setInsertLink:linkAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un InsertLink"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCInsertLinkAttrs *linkAttr = [[MobileRTCInsertLinkAttrs alloc] init];
        linkAttr.insertLinkUrl = @"https://www.google.com";
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setInsertLink:linkAttr start:4 end:18] unsetInsertLink:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"BackgroundColor"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCBackgroundColorAttrs *bgAttr = [[MobileRTCBackgroundColorAttrs alloc] init];
        bgAttr.color = kRichTextColor(235,24,7);
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBackgroundColor:bgAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un BackgroundColor"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCBackgroundColorAttrs *bgAttr = [[MobileRTCBackgroundColorAttrs alloc] init];
        bgAttr.color = kRichTextColor(235,24,7);
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setBackgroundColor:bgAttr start:4 end:18] unsetBackgroundColor:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"FontColor"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCFontColorAttrs *fontAttr = [[MobileRTCFontColorAttrs alloc] init];
        fontAttr.color = kRichTextColor(235,24,7);
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setFontColor:fontAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un FontColor"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCFontColorAttrs *fontAttr = [[MobileRTCFontColorAttrs alloc] init];
        fontAttr.color = kRichTextColor(235,24,7);
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setFontColor:fontAttr start:4 end:18] unsetFontColor:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"increaseIndent"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCIndentAttrs *indentAttr = [[MobileRTCIndentAttrs alloc] init];
        indentAttr.indent = 3;
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] increaseIndent:indentAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"decreaseIndent"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCIndentAttrs *indentAttr = [[MobileRTCIndentAttrs alloc] init];
        indentAttr.indent = 2;
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] increaseIndent:indentAttr start:4 end:18] decreaseIndent:indentAttr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Paragraph"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCParagraphAttrs *attr = [[MobileRTCParagraphAttrs alloc] init];
        attr.strParagraph = TextStyle_Paragraph_H1;
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setParagraph:attr start:4 end:18] build];
        bool ret = [ms sendChatMsg:newChat];
        NSLog(@"sendCommentsChatMsg==>%@", @(ret));
                                                        }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"un Paragraph"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        MobileRTCMeetingChatBuilder *builder = [[MobileRTCMeetingChatBuilder alloc] init];
        MobileRTCParagraphAttrs *attr = [[MobileRTCParagraphAttrs alloc] init];
        attr.strParagraph = TextStyle_Paragraph_H3;
        MobileRTCMeetingChat *newChat = [[[[[[[builder setContent:@"This is a  你好，我有一个帽衫 \r new topic chat message"] setReceiver:0] setThreadId:@""] setMessageType:MobileRTCChatMessageType_To_All] setParagraph:attr start:4 end:18] unsetParagraph:4 end:18] build];
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
        MobileRTCMeetingChat *newChat = [[[[[[builder setContent:@"12345\r6 This\r is a comments"] setReceiver:0] setThreadId:chatInfo.threadID] setMessageType:MobileRTCChatMessageType_To_All] setQuotePosition:2 end:3] build];
        
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
