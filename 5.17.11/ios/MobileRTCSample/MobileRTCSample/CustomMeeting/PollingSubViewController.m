//
//  PollingQuestionViewController.m
//  MobileRTCSample
//
//  Created by Zoom on 2023/12/2.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "PollingSubViewController.h"
#import "PollingViewController.h"

@interface PollingSubViewController ()

@end

@interface PollingSubViewController () <UITableViewDataSource, UITableViewDelegate, MobileRTCMeetingServiceDelegate>
@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSMutableArray          *pollingActionArray;
@property (nonatomic, assign)   NSInteger          pollingSubIndex;

@end

@implementation PollingSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (_subViewType) {
        case PollingSubViewType_QuestionItem:
            self.title = @"QuestionItem";
            break;
        case PollingSubViewType_SubQuestionItem:
            self.title = @"SubQuestionItem";
            break;
        case PollingSubViewType_AnswerItem:
            self.title = @"AnswerItem";
            break;
        case PollingSubViewType_AnswerResultItem:
            self.title = @"AnswerResultItem";
            break;
        default:
            break;
    }
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    [self.navigationItem.leftBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Test", @"") style: UIBarButtonItemStylePlain target: self action: @selector(onTestClicked:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem.rightBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
//    self.dataSource = [NSMutableArray array];
    [self initActionDataSource];
    [self initTableView];
    _pollingSubIndex = -1;
}

- (void)initActionDataSource
{
    _pollingActionArray = [NSMutableArray array];
    [_pollingActionArray addObject:@(Polling_Common_getPollingSubQuestionItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_canGetRightAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingRightAnswerItemList)];
    [_pollingActionArray addObject:@(Polling_Common_canShowAnswerResultList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerResultItemList)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingAnswerItemByID)];
    [_pollingActionArray addObject:@(Polling_Common_getPollingQuestionImagePath)];
    [_pollingActionArray addObject:@(Polling_Common_getQuestionCharactersMinLen)];
    [_pollingActionArray addObject:@(Polling_Common_getQuestionCharactersMaxLen)];
    [_pollingActionArray addObject:@(Polling_Common_isQuestionCaseSensitive)];
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    if (![ms isMeetingHost] && ![ms isMeetingCoHost]) {
        [_pollingActionArray addObject:@(Polling_Attendee_setAnswerCheck)];
        [_pollingActionArray addObject:@(Polling_Attendee_setAnswerContent)];
        [_pollingActionArray addObject:@(Polling_Attendee_canSubmitPolling)];
        [_pollingActionArray addObject:@(Polling_Attendee_submitPolling)];
    }
}

- (void)onTestClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    if (_pollingSubIndex < 0) {
        [self alertMsg:@"" msg:@"Select polling sub please!"];
        return;
    }
    
    if (!_pollingID) {
        [self alertMsg:@"" msg:@"_pollingID is nil"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Polling Test"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSNumber *tesAction in _pollingActionArray) {
        NSString *interfaceName = [self getInterfaceName:[tesAction intValue]];
        [alertController addAction:[UIAlertAction actionWithTitle:interfaceName
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
            switch ([tesAction intValue]) {
                case Polling_Common_getPollingSubQuestionItemList:
                {
                    if (PollingSubViewType_QuestionItem == _subViewType) {
                        MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                        NSArray * pollingSubQuestionItemList = [item getPollingSubQuestionItemList];
                        
                        if (pollingSubQuestionItemList.count > 0)
                        {
                            PollingSubViewController *questionVC = [[PollingSubViewController alloc] init];
                            questionVC.pollingID = _pollingID;
                            questionVC.dataSource = pollingSubQuestionItemList;
                            questionVC.subViewType = PollingSubViewType_SubQuestionItem;
                            [self.navigationController pushViewController:questionVC animated:YES];
                        }
                        else
                        {
                            [self alertMsg:@"" msg:@"has no sub question"];
                        }
                    }
                }
                    break;
                case Polling_Common_getPollingAnswerItemList:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    NSArray * pollingAnswerItemList = [item getPollingAnswerItemList];
                    if (pollingAnswerItemList.count > 0) {
                        PollingSubViewController *questionVC = [[PollingSubViewController alloc] init];
                        questionVC.pollingID = _pollingID;
                        questionVC.dataSource = pollingAnswerItemList;
                        questionVC.subViewType = PollingSubViewType_AnswerItem;
                        [self.navigationController pushViewController:questionVC animated:YES];
                    }
                    else
                    {
                        [self alertMsg:@"" msg:@"has no answer item"];
                    }
                }
                    break;
                case Polling_Common_canGetRightAnswerItemList:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    BOOL canGetRightAnswerItemList = [ms canGetRightAnswerItemList:_pollingID ];
                    [self alertMsg:@"Polling_Common_canGetRightAnswerItemList" msg:canGetRightAnswerItemList?@"1":@"0"];
                }
                    break;
                case Polling_Common_getPollingRightAnswerItemList:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    NSArray * pollingRightAnswerItemList = [ms getPollingRightAnswerItemList:_pollingID ];
                    if (pollingRightAnswerItemList.count > 0) {
                        PollingSubViewController *questionVC = [[PollingSubViewController alloc] init];
                        questionVC.pollingID = _pollingID;
                        questionVC.dataSource = pollingRightAnswerItemList;
                        questionVC.subViewType = PollingSubViewType_AnswerItem;
                        [self.navigationController pushViewController:questionVC animated:YES];
                    }
                    else
                    {
                        [self alertMsg:@"" msg:@"has no right answer item"];
                    }
                }
                    break;
                case Polling_Common_canShowAnswerResultList:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    BOOL canShowAnswerResultList = [ms canShowAnswerResultList:item.getPollingID];
                    [self alertMsg:@"Polling_Common_canShowAnswerResultList" msg:canShowAnswerResultList?@"1":@"0"];
                }
                    break;
                case Polling_Common_getPollingAnswerResultItemList:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    NSArray * pollingAnswerResultItemList = [ms getPollingAnswerResultItemList:_pollingID];
                    if (pollingAnswerResultItemList.count > 0) {
                        PollingSubViewController *questionVC = [[PollingSubViewController alloc] init];
                        questionVC.pollingID = _pollingID;
                        questionVC.dataSource = pollingAnswerResultItemList;
                        questionVC.subViewType = PollingSubViewType_AnswerResultItem;
                        [self.navigationController pushViewController:questionVC animated:YES];
                    }
                    else
                    {
                        [self alertMsg:@"" msg:@"has no answer result item list"];
                    }
                }
                    break;
                case Polling_Common_getPollingItemByID:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    MobileRTCPollingItem *pollingitem = [ms getPollingItemByID:item.getPollingID];
                    NSString *itemDetail = [NSString stringWithFormat:@"PollingName:%@ (%@),PollingStatus:%@,PollingQuestionCount:%@,TotalVotedUserCount:%@,isLibraryPolling:%@", [pollingitem getPollingName], @([pollingitem getPollingType]),@([pollingitem getPollingStatus]),@([pollingitem getPollingQuestionCount]),@([pollingitem getTotalVotedUserCount]),@([pollingitem isLibraryPolling])];
                    [self alertMsg:@"Polling_Common_getPollingItemByID" msg:itemDetail];
                }
                    break;
                case Polling_Common_getPollingAnswerItemByID:
                {
//                    MobileRTCPollingItem *pollingitem = [ms getPollingAnswerItemByID:_pollingID];
//                    NSString *itemDetail = [NSString stringWithFormat:@"PollingName:%@ (%@),PollingStatus:%@,PollingQuestionCount:%@,TotalVotedUserCount:%@,isLibraryPolling:%@", [pollingitem getPollingName], @([pollingitem getPollingType]),@([pollingitem getPollingStatus]),@([pollingitem getPollingQuestionCount]),@([pollingitem getTotalVotedUserCount]),@([pollingitem isLibraryPolling])];
//                    [self alertMsg:@"Polling_Common_getPollingItemByID" msg:itemDetail];
                }
                    break;
                case Polling_Common_getPollingQuestionImagePath:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    NSString *path = [ms getPollingQuestionImagePath:[item getPollingID] questionID:[item getPollingQuestionID]];
                    [self alertMsg:@"Polling_Common_getPollingQuestionImagePath" msg:path];;
                }
                    break;
                case Polling_Common_getQuestionCharactersMinLen:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    int MinLen = [ms getQuestionCharactersMinLen:_pollingID questionID:[item getPollingQuestionID]];
                    [self alertMsg:@"Polling_Common_getQuestionCharactersMinLen" msg:[NSString stringWithFormat:@"%d",MinLen]];;
                }
                    break;
                case Polling_Common_getQuestionCharactersMaxLen:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    int MaxLen = [ms getQuestionCharactersMaxLen:_pollingID questionID:[item getPollingQuestionID]];
                    [self alertMsg:@"Polling_Common_getQuestionCharactersMinLen" msg:[NSString stringWithFormat:@"%d",MaxLen]];;
                }
                    break;
                case Polling_Common_isQuestionCaseSensitive:
                {
                    MobileRTCPollingQuestionItem *item = self.dataSource[_pollingSubIndex];
                    BOOL isQuestionCaseSensitive = [ms isQuestionCaseSensitive:item.getPollingID questionID:[item getPollingQuestionID]];
                    [self alertMsg:@"Polling_Common_isQuestionCaseSensitive" msg:isQuestionCaseSensitive?@"1":@"0"];
                }
                    break;

                // Attendee
                case Polling_Attendee_setAnswerCheck:
                {
                    MobileRTCPollingAnswerItem *item = self.dataSource[_pollingSubIndex];
                    MobileRTCSDKError ret = [ms setAnswerCheck:item check:YES];
                    [self alertMsg:@"Polling_Attendee_setAnswerCheck" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Attendee_setAnswerContent:
                {
                    MobileRTCPollingAnswerItem *item = self.dataSource[_pollingSubIndex];
                    MobileRTCSDKError ret = [ms setAnswerContent:item answerText:@"Test answer text"];
                    [self alertMsg:@"Polling_Attendee_setAnswerContent" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
                }
                    break;
                case Polling_Attendee_canSubmitPolling:
                {
                    MobileRTCPollingAnswerItem *item = self.dataSource[_pollingSubIndex];
                    BOOL canSubmitPolling = [ms canSubmitPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Attendee_canSubmitPolling" msg:canSubmitPolling?@"1":@"0"];
                }
                    break;
                case Polling_Attendee_submitPolling:
                {
                    MobileRTCPollingAnswerItem *item = self.dataSource[_pollingSubIndex];
                    MobileRTCSDKError ret = [ms submitPolling:item.getPollingID];
                    [self alertMsg:@"Polling_Attendee_submitPolling" msg:ret==MobileRTCSDKError_Success?@"successed":@"failed"];
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
    [self.navigationController popViewControllerAnimated:YES];
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
//    [self initDataSource];
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
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.textLabel.numberOfLines = 0;
    if (PollingSubViewType_QuestionItem == _subViewType || PollingSubViewType_SubQuestionItem == _subViewType) {
        MobileRTCPollingQuestionItem *item = self.dataSource[indexPath.row];
        MobileRTCPollingQuestionType type = [item getPollingQuestionType];
        NSString *typeName = @"";
        switch (type) {
            case MobileRTCPollingQuestionType_Single:
                typeName = @"Single";
                break;
            case MobileRTCPollingQuestionType_Multi:
                typeName = @"Multi";
                break;
            case MobileRTCPollingQuestionType_Matching:
                typeName = @"Matching";
                break;
            case MobileRTCPollingQuestionType_RankOrder:
                typeName = @"RankOrder";
                break;
            case MobileRTCPollingQuestionType_ShortAnswer:
                typeName = @"ShortAnswer";
                break;
            case MobileRTCPollingQuestionType_LongAnswer:
                typeName = @"LongAnswer";
                break;
            case MobileRTCPollingQuestionType_FillBlank:
                typeName = @"FillBlank";
                break;
            case MobileRTCPollingQuestionType_RatingScale:
                typeName = @"RatingScale";
                break;
            case MobileRTCPollingQuestionType_Dropdown:
                typeName = @"Dropdown";
                break;
            default:
                typeName = @"Unknown";
                break;
        }
        
        NSString *cellName = [NSString stringWithFormat:@"QuestionName:%@ (%@),answeredCount:%@,isRequired:%@", [item getPollingQuestionName], typeName,@([item getAnsweredCount]), @([item isRequired])];
        cell.textLabel.text = cellName;
    } else if (PollingSubViewType_AnswerItem == _subViewType) {
        MobileRTCPollingAnswerItem *item = self.dataSource[indexPath.row];
        NSString *cellName = [NSString stringWithFormat:@"AnswerName:%@,answeredContent:%@, isChecked:%@", [item getPollingAnswerName], [item getPollingAnsweredContent],@([item isChecked])];
        cell.textLabel.text = cellName;
    } else if (PollingSubViewType_AnswerResultItem == _subViewType) {
        MobileRTCPollingAnswerResultItem *item = self.dataSource[indexPath.row];
        NSString *cellName = [NSString stringWithFormat:@"AnswerName:%@, selectedCount:%@", [item getPollingAnswerName] ,@([item getSelectedCount])];
        cell.textLabel.text = cellName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _pollingSubIndex = indexPath.row;
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
