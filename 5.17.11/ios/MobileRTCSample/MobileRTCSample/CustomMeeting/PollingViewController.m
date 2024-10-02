//
//  PollingViewController.m
//  MobileRTCSample
//
//  Created by Zoom on 2023/12/1.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "PollingViewController.h"
#import "PollingSubViewController.h"



@interface PollingViewController () <UITableViewDataSource, UITableViewDelegate, MobileRTCMeetingServiceDelegate>
@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSMutableArray          *dataSource;
@property (nonatomic, strong)   NSMutableArray          *pollingActionArray;
@property (nonatomic, assign)   NSInteger          pollingIndex;

@end

@implementation PollingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:kPOLLING_NOTIFICATION_DATA_UPDATE object:nil];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Polling";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    [self.navigationItem.leftBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Test", @"") style: UIBarButtonItemStylePlain target: self action: @selector(onTestClicked:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem.rightBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    [self initDataSource];
    [self initTableView];
    _pollingIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    _dataSource = nil;
    _tableView = nil;
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onTestClicked:(id)sender
{
    if (_pollingIndex < 0) {
        [self alertMsg:@"" msg:@"Select polling please!"];
        return;
    }
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Polling Test"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    MobileRTCPollingItem *item = _dataSource[_pollingIndex];
    for (NSNumber *tesAction in _pollingActionArray) {
        NSString *interfaceName = [self getInterfaceName:[tesAction intValue]];
        [alertController addAction:[UIAlertAction actionWithTitle:interfaceName
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
            switch ([tesAction intValue]) {
                case Polling_Common_canDoPolling:
                {
                    BOOL ret = [ms canDoPolling];
                    [self alertMsg:@"Polling_Common_canDoPolling" msg:[NSString stringWithFormat:@"%@",@(ret)]];
                }
                    break;
                    
                case Polling_Common_getActivePollingID:
                {
                    NSString *activePollingID= [ms getActivePollingID];
                    [self alertMsg:@"Polling_Common_getActivePollingID" msg:activePollingID];
                }
                    break;
                case Polling_Common_getPollingQuestionItemList:
                {
                    NSArray * pollingQuestionItemList = [ms getPollingQuestionItemList:item.getPollingID];
                    
                    PollingSubViewController *questionVC = [[PollingSubViewController alloc] init];
                    questionVC.pollingID = item.getPollingID;
                    questionVC.dataSource = pollingQuestionItemList;
                    questionVC.subViewType = PollingSubViewType_QuestionItem;
                    [self.navigationController pushViewController:questionVC animated:YES];
                }
                    break;
                case Polling_Common_getPollingSubQuestionItemList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getPollingAnswerItemList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_canGetRightAnswerItemList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getPollingRightAnswerItemList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_canShowAnswerResultList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getPollingAnswerResultItemList:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getPollingItemByID:
                {
//                    -(MobileRTCPollingItem * _Nullable)getPollingItemByID:(NSString *_Nonnull)pollingID;
                    MobileRTCPollingItem *pollingitem = [ms getPollingItemByID:item.getPollingID];
                    NSString *itemDetail = [NSString stringWithFormat:@"PollingName:%@ (%@),PollingStatus:%@,PollingQuestionCount:%@,TotalVotedUserCount:%@,isLibraryPolling:%@", [pollingitem getPollingName], @([pollingitem getPollingType]),@([pollingitem getPollingStatus]),@([pollingitem getPollingQuestionCount]),@([pollingitem getTotalVotedUserCount]),@([pollingitem isLibraryPolling])];
                    [self alertMsg:@"Polling_Common_getPollingItemByID" msg:itemDetail];
                }
                    break;
                case Polling_Common_getPollingAnswerItemByID:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getPollingQuestionImagePath:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getQuestionCharactersMinLen:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_getQuestionCharactersMaxLen:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Common_isQuestionCaseSensitive:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;

                // host
                case Polling_Host_canAddPolling:
                {
                    BOOL canAddPolling = [ms canAddPolling];
                    [self alertMsg:@"Polling_Host_canAddPolling" msg:canAddPolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_addPolling:
                {
                    MobileRTCSDKError ret = [ms addPolling];
                    [self alertMsg:@"Polling_Host_addPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canEditPolling:
                {
                    BOOL canAddPolling = [ms canEditPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canEditPolling" msg:canAddPolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_editPolling:
                {
                    MobileRTCSDKError ret = [ms editPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_editPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canDeletePolling:
                {
                    BOOL canDeletePolling = [ms canDeletePolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canDeletePolling" msg:canDeletePolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_deletePolling:
                {
                    MobileRTCSDKError ret = [ms deletePolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_deletePolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canDuplicatePolling:
                {
                    BOOL canDuplicatePolling = [ms canDuplicatePolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canDuplicatePolling" msg:canDuplicatePolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_duplicatePolling:
                {
                    MobileRTCSDKError ret = [ms duplicatePolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_duplicatePolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canViewPollingResultFromBrowser:
                {
                    BOOL canViewPollingResultFromBrowser = [ms canViewPollingResultFromBrowser:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canViewPollingResultFromBrowser" msg:canViewPollingResultFromBrowser?@"1":@"0"];
                }
                    break;
                case Polling_Host_viewPollingResultFromBrowser:
                {
                    MobileRTCSDKError ret = [ms viewPollingResultFromBrowser:item.getPollingID];
                    [self alertMsg:@"Polling_Host_viewPollingResultFromBrowser" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canStartPolling:
                {
                    BOOL canStartPolling = [ms canStartPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canStartPolling" msg:canStartPolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_startPolling:
                {
                    MobileRTCSDKError ret = [ms startPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_startPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_stopPolling:
                {
                    MobileRTCSDKError ret = [ms stopPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_stopPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canRestartPolling:
                {
                    BOOL canRestartPolling = [ms canRestartPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canRestartPolling" msg:canRestartPolling?@"1":@"0"];
                }
                    break;
                case Polling_Host_restartPolling:
                {
                    MobileRTCSDKError ret = [ms restartPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Host_restartPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canSharePollingResult:
                {
                    BOOL canSharePollingResult = [ms canSharePollingResult:item.getPollingID];
                    [self alertMsg:@"Polling_Host_canSharePollingResult" msg:canSharePollingResult?@"1":@"0"];
                }
                    break;
                case Polling_Host_startSharePollingResult:
                {
                    MobileRTCSDKError ret = [ms startSharePollingResult:item.getPollingID];
                    [self alertMsg:@"Polling_Host_startSharePollingResult" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_stopSharePollingResult:
                {
                    MobileRTCSDKError ret = [ms stopSharePollingResult:item.getPollingID];
                    [self alertMsg:@"Polling_Host_stopSharePollingResult" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_enableGetRightAnswerList:
                {
                    MobileRTCSDKError ret = [ms enableGetRightAnswerList:YES];
                    [self alertMsg:@"Polling_Host_enableGetRightAnswerList" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Host_canDownloadResult:
                {
                    BOOL canDownloadResult = [ms canDownloadResult];
                    [self alertMsg:@"Polling_Host_canDownloadResult" msg:canDownloadResult?@"1":@"0"];
                }
                    break;
                case Polling_Host_downLoadResult:
                {
                    MobileRTCSDKError ret = [ms downLoadResult];
                    [self alertMsg:@"Polling_Host_downLoadResult" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;

                // Attendee
                case Polling_Attendee_setAnswerCheck:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Attendee_setAnswerContent:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Attendee_canSubmitPolling:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                case Polling_Attendee_submitPolling:
                {
                    [self alertMsg:@"" msg:@"do sub polling view"];
                }
                    break;
                    
                default:
                    [self alertMsg:@"" msg:@"not support now"];
                    break;
            }
                                                                }]];
    }
        
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        UIButton *btn = (UIButton*)sender;
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)alertMsg:(NSString *)title msg:(NSString *)msg {
    if (msg == nil) {
        msg = @"empty";
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                          message:msg
                                                   preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
  
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)initDataSource
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms.isMeetingHost || ms.isMeetingCoHost)
        _dataSource = [[ms getPollingItemList] mutableCopy];
    else
        _dataSource = [@[[ms getPollingItemByID:[ms getActivePollingID]]] mutableCopy];
    
    _pollingActionArray = [NSMutableArray array];
    
    [_pollingActionArray addObject:@(Polling_Common_canDoPolling)];
    [_pollingActionArray addObject:@(Polling_Common_getActivePollingID)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingQuestionItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingSubQuestionItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_canGetRightAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingRightAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_canShowAnswerResultList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerResultItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingItemByID)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerItemByID)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingQuestionImagePath)];
    [_pollingActionArray addObject:@(Polling_Common_getQuestionCharactersMinLen)];
    [_pollingActionArray addObject:@(Polling_Common_getQuestionCharactersMaxLen)];
    [_pollingActionArray addObject:@(Polling_Common_isQuestionCaseSensitive)];
    
    if (ms.isMeetingHost || ms.isMeetingCoHost) {
        [_pollingActionArray addObject:@(Polling_Host_canAddPolling)];
        [_pollingActionArray addObject:@(Polling_Host_addPolling)];
        [_pollingActionArray addObject:@(Polling_Host_canEditPolling)];
        [_pollingActionArray addObject:@(Polling_Host_editPolling)];
        [_pollingActionArray addObject:@(Polling_Host_canDeletePolling)];
        [_pollingActionArray addObject:@(Polling_Host_deletePolling)];
        [_pollingActionArray addObject:@(Polling_Host_canDuplicatePolling)];
        [_pollingActionArray addObject:@(Polling_Host_duplicatePolling)];
        [_pollingActionArray addObject:@(Polling_Host_canViewPollingResultFromBrowser)];
        [_pollingActionArray addObject:@(Polling_Host_viewPollingResultFromBrowser)];
        [_pollingActionArray addObject:@(Polling_Host_getPollingItemList)];
        [_pollingActionArray addObject:@(Polling_Host_canStartPolling)];
        [_pollingActionArray addObject:@(Polling_Host_startPolling)];
        [_pollingActionArray addObject:@(Polling_Host_stopPolling)];
        [_pollingActionArray addObject:@(Polling_Host_canRestartPolling)];
        [_pollingActionArray addObject:@(Polling_Host_restartPolling)];
        [_pollingActionArray addObject:@(Polling_Host_canSharePollingResult)];
        [_pollingActionArray addObject:@(Polling_Host_startSharePollingResult)];
        [_pollingActionArray addObject:@(Polling_Host_stopSharePollingResult)];
        [_pollingActionArray addObject:@(Polling_Host_enableGetRightAnswerList)];
        [_pollingActionArray addObject:@(Polling_Host_canDownloadResult)];
        [_pollingActionArray addObject:@(Polling_Host_downLoadResult)];
    } else {
        [_pollingActionArray addObject:@(Polling_Attendee_setAnswerCheck)];
        [_pollingActionArray addObject:@(Polling_Attendee_setAnswerContent)];
        [_pollingActionArray addObject:@(Polling_Attendee_canSubmitPolling)];
        [_pollingActionArray addObject:@(Polling_Attendee_submitPolling)];
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
    self.tableView.rowHeight = 80;
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
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MobileRTCPollingItem *item = _dataSource[indexPath.row];
    MobileRTCPollingType type = [item getPollingType];
    NSString *typeName = @"";
    if (type == MobileRTCPollingType_Poll) {
        typeName = @"Poll";
    } else if (type == MobileRTCPollingType_Quiz) {
        typeName = @"Quiz";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.textLabel.numberOfLines = 0;
    NSString *cellName = [NSString stringWithFormat:@"PollingName:%@ (%@),PollingStatus:%@,PollingQuestionCount:%@,TotalVotedUserCount:%@,isLibraryPolling:%@", [item getPollingName], typeName,@([item getPollingStatus]),@([item getPollingQuestionCount]),@([item getTotalVotedUserCount]),@([item isLibraryPolling])];
    cell.textLabel.text = cellName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _pollingIndex = indexPath.row;
}

- (NSString *)getInterfaceName:(NSInteger)value {
    switch (value) {
        // Common
        case Polling_Common_canDoPolling:
            return @"Polling_Common_canDoPolling";
        case Polling_Common_getActivePollingID:
            return @"Polling_Common_getActivePollingID";
        case Polling_Common_getPollingQuestionItemList:
            return @"Polling_Common_getPollingQuestionItemList";
        case Polling_Common_getPollingSubQuestionItemList:
            return @"Polling_Common_getPollingSubQuestionItemList";
        case Polling_Common_getPollingAnswerItemList:
            return @"Polling_Common_getPollingAnswerItemList";
        case Polling_Common_canGetRightAnswerItemList:
            return @"Polling_Common_canGetRightAnswerItemList";
        case Polling_Common_getPollingRightAnswerItemList:
            return @"Polling_Common_getPollingRightAnswerItemList";
        case Polling_Common_canShowAnswerResultList:
            return @"Polling_Common_canShowAnswerResultList";
        case Polling_Common_getPollingAnswerResultItemList:
            return @"Polling_Common_getPollingAnswerResultItemList";
        case Polling_Common_getPollingItemByID:
            return @"Polling_Common_getPollingItemByID";
        case Polling_Common_getPollingAnswerItemByID:
            return @"Polling_Common_getPollingAnswerItemByID";
        case Polling_Common_getPollingQuestionImagePath:
            return @"Polling_Common_getPollingQuestionImagePath";
        case Polling_Common_getQuestionCharactersMinLen:
            return @"Polling_Common_getQuestionCharactersMinLen";
        case Polling_Common_getQuestionCharactersMaxLen:
            return @"Polling_Common_getQuestionCharactersMaxLen";
        case Polling_Common_isQuestionCaseSensitive:
            return @"Polling_Common_isQuestionCaseSensitive";

        // host
        case Polling_Host_canAddPolling:
            return @"Polling_Host_canAddPolling";
        case Polling_Host_addPolling:
            return @"Polling_Host_addPolling";
        case Polling_Host_canEditPolling:
            return @"Polling_Host_canEditPolling";
        case Polling_Host_editPolling:
            return @"Polling_Host_editPolling";
        case Polling_Host_canDeletePolling:
            return @"Polling_Host_canDeletePolling";
        case Polling_Host_deletePolling:
            return @"Polling_Host_deletePolling";
        case Polling_Host_canDuplicatePolling:
            return @"Polling_Host_canDuplicatePolling";
        case Polling_Host_duplicatePolling:
            return @"Polling_Host_duplicatePolling";
        case Polling_Host_canViewPollingResultFromBrowser:
            return @"Polling_Host_canViewPollingResultFromBrowser";
        case Polling_Host_viewPollingResultFromBrowser:
            return @"Polling_Host_viewPollingResultFromBrowser";
        case Polling_Host_getPollingItemList:
            return @"Polling_Host_getPollingItemList";
        case Polling_Host_canStartPolling:
            return @"Polling_Host_canStartPolling";
        case Polling_Host_startPolling:
            return @"Polling_Host_startPolling";
        case Polling_Host_stopPolling:
            return @"Polling_Host_stopPolling";
        case Polling_Host_canRestartPolling:
            return @"Polling_Host_canRestartPolling";
        case Polling_Host_restartPolling:
            return @"Polling_Host_restartPolling";
        case Polling_Host_canSharePollingResult:
            return @"Polling_Host_canSharePollingResult";
        case Polling_Host_startSharePollingResult:
            return @"Polling_Host_startSharePollingResult";
        case Polling_Host_stopSharePollingResult:
            return @"Polling_Host_stopSharePollingResult";
        case Polling_Host_enableGetRightAnswerList:
            return @"Polling_Host_enableGetRightAnswerList";
        case Polling_Host_canDownloadResult:
            return @"Polling_Host_canDownloadResult";
        case Polling_Host_downLoadResult:
            return @"Polling_Host_downLoadResult";

        // Attendee
        case Polling_Attendee_setAnswerCheck:
            return @"Polling_Attendee_setAnswerCheck";
        case Polling_Attendee_setAnswerContent:
            return @"Polling_Attendee_setAnswerContent";
        case Polling_Attendee_canSubmitPolling:
            return @"Polling_Attendee_canSubmitPolling";
        case Polling_Attendee_submitPolling:
            return @"Polling_Attendee_submitPolling";
        default:
            return @"not support";
    }
}
@end

