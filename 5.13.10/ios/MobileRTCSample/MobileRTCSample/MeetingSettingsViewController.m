//
//  MeetingSettingsViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2017/8/18.
//  Copyright © 2017年 Zoom Video Communications, Inc. All rights reserved.
//

#import "MeetingSettingsViewController.h"
#import "SDKMeetingSettingPresenter.h"
#import "SendYUVAdapter.h"

@interface MeetingSettingsViewController ()

@property (strong, nonatomic) UITableViewCell *autoConnectAudioCell;
@property (strong, nonatomic) UITableViewCell *muteAudioCell;
@property (strong, nonatomic) UITableViewCell *muteVideoCell;
@property (strong, nonatomic) UITableViewCell *driveModeCell;
@property (strong, nonatomic) UITableViewCell *galleryViewCell;
@property (strong, nonatomic) UITableViewCell *cloudWhiteboardViewCell;
@property (strong, nonatomic) UITableViewCell *videoPreviewCell;
@property (strong, nonatomic) UITableViewCell *virtualBackgroundCell;
@property (strong, nonatomic) UITableViewCell *copyMeetingUrlCell;
@property (strong, nonatomic) UITableViewCell *proximityMonitoringCell;
@property (strong, nonatomic) UITableViewCell *speakerOffWhenInMeetingCell;
@property (strong, nonatomic) UITableViewCell *disableClearWebkitCacheCell;

@property (strong, nonatomic) UITableViewCell *callInCell;
@property (strong, nonatomic) UITableViewCell *callOutCell;
@property (strong, nonatomic) UITableViewCell *wbFeedbackCell;
@property (strong, nonatomic) UITableViewCell *wbShareCell;
@property (strong, nonatomic) UITableViewCell *minimizeMeetingCell;

@property (strong, nonatomic) UITableViewCell *faceBeautyCell;
@property (strong, nonatomic) UITableViewCell *videoMirrorCell;
@property (strong, nonatomic) UITableViewCell *micOriginalInputCell;

@property (strong, nonatomic) UITableViewCell *titleHiddenCell;
@property (strong, nonatomic) UITableViewCell *hiddenSelfViewCell;
@property (strong, nonatomic) UITableViewCell *passwordHiddenCell;
@property (strong, nonatomic) UITableViewCell *leaveHiddenCell;
@property (strong, nonatomic) UITableViewCell *inviteHiddenCell;
@property (strong, nonatomic) UITableViewCell *inviteUrlHiddenCell;
@property (strong, nonatomic) UITableViewCell *chatHiddenCell;
@property (strong, nonatomic) UITableViewCell *shareHiddenCell;
@property (strong, nonatomic) UITableViewCell *audioHiddenCell;
@property (strong, nonatomic) UITableViewCell *videoHiddenCell;
@property (strong, nonatomic) UITableViewCell *participantHiddenCell;
@property (strong, nonatomic) UITableViewCell *moreHiddenCell;

@property (strong, nonatomic) UITableViewCell *topBarHiddenCell;
@property (strong, nonatomic) UITableViewCell *botBarHiddenCell;

@property (strong, nonatomic) UITableViewCell *thumbnailCell;
@property (strong, nonatomic) UITableViewCell *hostLeaveCell;
@property (strong, nonatomic) UITableViewCell *hintCell;
@property (strong, nonatomic) UITableViewCell *disconnectAudioCell;
@property (strong, nonatomic) UITableViewCell *waitingHUDCell;
@property (strong, nonatomic) UITableViewCell *webinarQACell;
@property (strong, nonatomic) UITableViewCell *callinRoomSystemHiddenCell;
@property (strong, nonatomic) UITableViewCell *calloutRoomSystemHiddenCell;
@property (strong, nonatomic) UITableViewCell *claimHostWithHostKeyHiddenCell;
@property (strong, nonatomic) UITableViewCell *closeCaptionHiddenCell;
@property (strong, nonatomic) UITableViewCell *promoteToPanelistHiddenCell;
@property (strong, nonatomic) UITableViewCell *changeToAttendeeHiddenCell;
@property (strong, nonatomic) UITableViewCell *reactionsOnMeetingUIHiddenCell;
@property (strong, nonatomic) UITableViewCell *recordButtonHiddenCell;
@property (strong, nonatomic) UITableViewCell *hideNovideoUserEnableCell;

@property (strong, nonatomic) UITableViewCell *customMeetingCell;
@property (strong, nonatomic) UITableViewCell *rawdataUICell;

@property (strong, nonatomic) UITableViewCell *sendRawdataCell;

@property (strong, nonatomic) UITableViewCell *showMyMeetingElapseTimeCell;

@property (strong, nonatomic) UITableViewCell *reactionSkinToneCell;

@property (strong, nonatomic) NSArray *itemArray;

//SDK Presenter
@property (strong, nonatomic) SDKMeetingSettingPresenter    *settingPresenter;
@end

@implementation MeetingSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Meeting Settings", @"");
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableArray *layoutArray = [NSMutableArray array];
    if ([[MobileRTC sharedRTC] isSupportedCustomizeMeetingUI])
    {
        [layoutArray addObject:[self customMeetingCell]];
        
        BOOL enableCustomMeeting = [[[MobileRTC sharedRTC] getMeetingSettings] enableCustomMeeting];
        BOOL hasRawDataLicense = [[MobileRTC sharedRTC] hasRawDataLicense];
        if (enableCustomMeeting && hasRawDataLicense) {
            [layoutArray addObject:[self rawdataUICell]];
        }
    }
    [layoutArray addObject:[self thumbnailCell]];
    [array addObject:layoutArray];
    
    NSMutableArray *sendRawdataArray = [NSMutableArray array];
    [sendRawdataArray addObject:[self sendRawdataCell]];
    [array addObject:sendRawdataArray];

    NSMutableArray *avArray = [NSMutableArray array];
    [avArray addObject:[self autoConnectAudioCell]];
    [avArray addObject:[self muteAudioCell]];
    [avArray addObject:[self muteVideoCell]];
    [array addObject:avArray];

    NSMutableArray *disableArray = [NSMutableArray array];
    [disableArray addObject:[self callInCell]];
    [disableArray addObject:[self callOutCell]];
    [disableArray addObject:[self wbShareCell]];
    [disableArray addObject:[self wbFeedbackCell]];
    [disableArray addObject:[self minimizeMeetingCell]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [disableArray addObject:[self driveModeCell]];

    [disableArray addObject:[self galleryViewCell]];
    [disableArray addObject:[self cloudWhiteboardViewCell]];
    [disableArray addObject:[self videoPreviewCell]];
    [disableArray addObject:[self virtualBackgroundCell]];
    [disableArray addObject:[self copyMeetingUrlCell]];
    [disableArray addObject:[self proximityMonitoringCell]];
    [disableArray addObject:[self speakerOffWhenInMeetingCell]];
    [disableArray addObject:[self disableClearWebkitCacheCell]];
    [array addObject:disableArray];
    
    NSMutableArray *enableArray = [NSMutableArray array];
    [enableArray addObject:[self faceBeautyCell]];
    [enableArray addObject:[self videoMirrorCell]];
    [enableArray addObject:[self micOriginalInputCell]];
    [enableArray addObject:[self reactionSkinToneCell]];
    [array addObject:enableArray];

    NSMutableArray *hiddenArray = [NSMutableArray array];
    [hiddenArray addObject:[self titleHiddenCell]];
    [hiddenArray addObject:[self passwordHiddenCell]];
    [hiddenArray addObject:[self leaveHiddenCell]];
    [hiddenArray addObject:[self audioHiddenCell]];
    [hiddenArray addObject:[self videoHiddenCell]];
    [hiddenArray addObject:[self inviteHiddenCell]];
    [hiddenArray addObject:[self inviteUrlHiddenCell]];
    [hiddenArray addObject:[self chatHiddenCell]];
    [hiddenArray addObject:[self participantHiddenCell]];
    [hiddenArray addObject:[self moreHiddenCell]];
    [hiddenArray addObject:[self shareHiddenCell]];
    [hiddenArray addObject:[self topBarHiddenCell]];
    [hiddenArray addObject:[self hostLeaveCell]];
    [hiddenArray addObject:[self hintCell]];
    [hiddenArray addObject:[self disconnectAudioCell]];
    [hiddenArray addObject:[self waitingHUDCell]];
    [hiddenArray addObject:[self botBarHiddenCell]];
    [hiddenArray addObject:[self webinarQACell]];
    [hiddenArray addObject:[self callinRoomSystemHiddenCell]];
    [hiddenArray addObject:[self calloutRoomSystemHiddenCell]];
    [hiddenArray addObject:[self claimHostWithHostKeyHiddenCell]];
    [hiddenArray addObject:[self closeCaptionHiddenCell]];
    [hiddenArray addObject:[self promoteToPanelistHiddenCell]];
    [hiddenArray addObject:[self changeToAttendeeHiddenCell]];
    [hiddenArray addObject:[self reactionsOnMeetingUIHiddenCell]];
    [hiddenArray addObject:[self recordButtonHiddenCell]];
    [hiddenArray addObject:[self hideNovideoUserEnableCell]];
    [hiddenArray addObject:[self hiddenSelfViewCell]];
    
    [array addObject:hiddenArray];
    
    NSMutableArray *showArray = [NSMutableArray array];
    [showArray addObject:[self showMyMeetingElapseTimeCell]];
    [array addObject:showArray];
    
    self.itemArray = array;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.itemArray[section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.itemArray[indexPath.section][indexPath.row];
    return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:[self reactionSkinToneCell]])
    {
        MobileRTCEmojiReactionSkinTone skinTone = [[[MobileRTC sharedRTC] getMeetingSettings] reactionSkinTone];
        skinTone += 1; skinTone %= (MobileRTCEmojiReactionSkinTone_Dark + 1);
        if (skinTone == MobileRTCEmojiReactionSkinTone_Unknown) {
            skinTone = MobileRTCEmojiReactionSkinTone_Default;
        }
        [[[MobileRTC sharedRTC] getMeetingSettings] setReactionSkinTone:skinTone];
        
        NSString *msg = [NSString stringWithFormat:@"Change skin tone to %@", @(skinTone)];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        switch (skinTone) {
            case MobileRTCEmojiReactionSkinTone_Default:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Default";
                break;
            case MobileRTCEmojiReactionSkinTone_Light:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Light";
                break;
            case MobileRTCEmojiReactionSkinTone_MediumLight:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_MediumLight";
                break;
            case MobileRTCEmojiReactionSkinTone_Medium:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Medium";
                break;
            case MobileRTCEmojiReactionSkinTone_MediumDark:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_MediumDark";
                break;
            case MobileRTCEmojiReactionSkinTone_Dark:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Dark";
                break;
            default:
    //            MobileRTCEmojiReactionSkinTone_Unknown
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Unknown";
                break;
        }
        [self.tableView reloadData];
    }
}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return NSLocalizedString(@"Auto Connect Internet Audio Setting", @"");
//    }
//    
//    if (section == 1)
//    {
//        return NSLocalizedString(@"Always mute my microphone when joining others' meeting", @"");
//    }
//    
//    if (section == 2)
//    {
//        return NSLocalizedString(@"Always mute my video when joining others' meeting", @"");
//    }
//    
//    if (section == 3 && [UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
//    {
//        return NSLocalizedString(@"Driving Mode Setting", @"");
//    }
//    
//    return nil;
//}

#pragma mark - Table view cells

- (UITableViewCell*)autoConnectAudioCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL isAutoConnected = [settings autoConnectInternetAudio];
    
    if (!_autoConnectAudioCell)
    {
        _autoConnectAudioCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _autoConnectAudioCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _autoConnectAudioCell.textLabel.text = NSLocalizedString(@"Auto Connect Internet Audio", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:isAutoConnected animated:NO];
        [sv addTarget:self action:@selector(onAutoConnectAudio:) forControlEvents:UIControlEventValueChanged];
        _autoConnectAudioCell.accessoryView = sv;
    }
    
    return _autoConnectAudioCell;
}

- (UITableViewCell*)muteAudioCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL isMuted = [settings muteAudioWhenJoinMeeting];
    
    if (!_muteAudioCell)
    {
        _muteAudioCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _muteAudioCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _muteAudioCell.textLabel.text = NSLocalizedString(@"Always Mute My Microphone", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:isMuted animated:NO];
        [sv addTarget:self action:@selector(onMuteAudio:) forControlEvents:UIControlEventValueChanged];
        _muteAudioCell.accessoryView = sv;
    }
    
    return _muteAudioCell;
}

- (UITableViewCell*)muteVideoCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL isMuted = [settings muteVideoWhenJoinMeeting];
    
    if (!_muteVideoCell)
    {
        _muteVideoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _muteVideoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _muteVideoCell.textLabel.text = NSLocalizedString(@"Always Mute My Video", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:isMuted animated:NO];
        [sv addTarget:self action:@selector(onMuteVideo:) forControlEvents:UIControlEventValueChanged];
        _muteVideoCell.accessoryView = sv;
    }
    
    return _muteVideoCell;
}

- (UITableViewCell*)driveModeCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings driveModeDisabled];
    
    if (!_driveModeCell)
    {
        _driveModeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _driveModeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _driveModeCell.textLabel.text = NSLocalizedString(@"Disable Driving Mode", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableDriveMode:) forControlEvents:UIControlEventValueChanged];
        _driveModeCell.accessoryView = sv;
    }
    
    return _driveModeCell;
}

- (UITableViewCell*)galleryViewCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings galleryViewDisabled];
    
    if (!_galleryViewCell)
    {
        _galleryViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _galleryViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _galleryViewCell.textLabel.text = NSLocalizedString(@"Disable Gallery View", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableGalleryView:) forControlEvents:UIControlEventValueChanged];
        _galleryViewCell.accessoryView = sv;
    }
    
    return _galleryViewCell;
}

- (UITableViewCell*)cloudWhiteboardViewCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = NO;
    
    if (!_cloudWhiteboardViewCell)
    {
        _cloudWhiteboardViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        _cloudWhiteboardViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cloudWhiteboardViewCell.textLabel.text = NSLocalizedString(@"Disable cloud whiteboard", @"");
        _cloudWhiteboardViewCell.detailTextLabel.text = NSLocalizedString(@"cell default is NO", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableCloudWhiteboard:) forControlEvents:UIControlEventValueChanged];
        _cloudWhiteboardViewCell.accessoryView = sv;
    }
    
    return _cloudWhiteboardViewCell;
}

- (UITableViewCell*)videoPreviewCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings showVideoPreviewWhenJoinMeetingDisabled];
    
    if (!_videoPreviewCell)
    {
        _videoPreviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _videoPreviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _videoPreviewCell.textLabel.text = NSLocalizedString(@"Disable Show Video Preview", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableVideoPreview:) forControlEvents:UIControlEventValueChanged];
        _videoPreviewCell.accessoryView = sv;
    }
    
    return _videoPreviewCell;
}

- (UITableViewCell*)virtualBackgroundCell
{
    {
        MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
        if (!settings)
            return nil;
        
        BOOL disabled = [settings virtualBackgroundDisabled];
        
        if (!_virtualBackgroundCell)
        {
            _virtualBackgroundCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _virtualBackgroundCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _virtualBackgroundCell.textLabel.text = NSLocalizedString(@"Disable Virtual Background", @"");
            
            UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
            [sv setOn:disabled animated:NO];
            [sv addTarget:self action:@selector(onDisableVirtualBackground:) forControlEvents:UIControlEventValueChanged];
            _virtualBackgroundCell.accessoryView = sv;
        }
        
        return _virtualBackgroundCell;
    }
}

- (UITableViewCell*)copyMeetingUrlCell
{
    {
        MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
        if (!settings)
            return nil;
        
        BOOL disabled = [settings copyMeetingUrlDisabled];
        
        if (!_copyMeetingUrlCell)
        {
            _copyMeetingUrlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _copyMeetingUrlCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _copyMeetingUrlCell.textLabel.text = NSLocalizedString(@"Disable Copy Meeting Url", @"");
            
            UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
            [sv setOn:disabled animated:NO];
            [sv addTarget:self action:@selector(onDisableCopyMeetinUrl:) forControlEvents:UIControlEventValueChanged];
            _copyMeetingUrlCell.accessoryView = sv;
        }
        
        return _copyMeetingUrlCell;
    }
}

- (UITableViewCell*)proximityMonitoringCell
{
    {
        MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
        if (!settings)
            return nil;
        
        BOOL disabled = [settings proximityMonitoringDisable];
        
        if (!_proximityMonitoringCell)
        {
            _proximityMonitoringCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _proximityMonitoringCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _proximityMonitoringCell.textLabel.text = NSLocalizedString(@"Disable Proximity Monitoring", @"");
            
            UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
            [sv setOn:disabled animated:NO];
            [sv addTarget:self action:@selector(onProximityMonitoring:) forControlEvents:UIControlEventValueChanged];
            _proximityMonitoringCell.accessoryView = sv;
        }
        
        return _proximityMonitoringCell;
    }
}

- (UITableViewCell*)speakerOffWhenInMeetingCell
{
    {
        MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
        if (!settings)
            return nil;
        
        BOOL disabled = [settings speakerOffWhenInMeeting];
        
        if (!_speakerOffWhenInMeetingCell)
        {
            _speakerOffWhenInMeetingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _speakerOffWhenInMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _speakerOffWhenInMeetingCell.textLabel.text = NSLocalizedString(@"Disable Speaker When In Meeting", @"");
            
            UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
            [sv setOn:disabled animated:NO];
            [sv addTarget:self action:@selector(onSpeakerWhenInMeeting:) forControlEvents:UIControlEventValueChanged];
            _speakerOffWhenInMeetingCell.accessoryView = sv;
        }
        
        return _speakerOffWhenInMeetingCell;
    }
}

- (UITableViewCell*)disableClearWebkitCacheCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    if (!_disableClearWebkitCacheCell)
    {
        BOOL disabled = [settings isDisabledClearWebKitCache];
        
        _disableClearWebkitCacheCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _disableClearWebkitCacheCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _disableClearWebkitCacheCell.textLabel.text = NSLocalizedString(@"Disable clean webkit cache", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableClearWeb:) forControlEvents:UIControlEventValueChanged];
        _disableClearWebkitCacheCell.accessoryView = sv;
    }
    
    return _disableClearWebkitCacheCell;
}

- (UITableViewCell*)callInCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings callInDisabled];
    
    if (!_callInCell)
    {
        _callInCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _callInCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _callInCell.textLabel.text = NSLocalizedString(@"Disable Call in", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableCallIn:) forControlEvents:UIControlEventValueChanged];
        _callInCell.accessoryView = sv;
    }
    
    return _callInCell;
}

- (UITableViewCell*)callOutCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings callOutDisabled];
    
    if (!_callOutCell)
    {
        _callOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _callOutCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _callOutCell.textLabel.text = NSLocalizedString(@"Disable Call Out", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableCallOut:) forControlEvents:UIControlEventValueChanged];
        _callOutCell.accessoryView = sv;
    }
    
    return _callOutCell;
}

- (UITableViewCell*)wbFeedbackCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hide = settings.hideFeedbackButtonOnCloudWhiteboard;
    
    if (!_wbFeedbackCell)
    {
        _wbFeedbackCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _wbFeedbackCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _wbFeedbackCell.textLabel.text = NSLocalizedString(@"Hide Feedback in Cloud WB", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hide animated:NO];
        [sv addTarget:self action:@selector(onHideCloudWBFeedback:) forControlEvents:UIControlEventValueChanged];
        _wbFeedbackCell.accessoryView = sv;
    }
    
    return _wbFeedbackCell;
}

- (UITableViewCell*)wbShareCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hide = settings.hideShareButtonOnCloudWhiteboard;
    
    if (!_wbShareCell)
    {
        _wbShareCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _wbShareCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _wbShareCell.textLabel.text = NSLocalizedString(@"Hide share in Cloud WB", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hide animated:NO];
        [sv addTarget:self action:@selector(onHideCloudWBShare:) forControlEvents:UIControlEventValueChanged];
        _wbShareCell.accessoryView = sv;
    }
    
    return _wbShareCell;
}

- (UITableViewCell*)minimizeMeetingCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL disabled = [settings minimizeMeetingDisabled];
    
    if (!_minimizeMeetingCell)
    {
        _minimizeMeetingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _minimizeMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _minimizeMeetingCell.textLabel.text = NSLocalizedString(@"Disable Minimize Meeting", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:disabled animated:NO];
        [sv addTarget:self action:@selector(onDisableMinimizeMeeting:) forControlEvents:UIControlEventValueChanged];
        _minimizeMeetingCell.accessoryView = sv;
    }
    
    return _minimizeMeetingCell;
}

- (UITableViewCell*)faceBeautyCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL isfaceBeautyEnabled = [settings faceBeautyEnabled];
    
    if (!_faceBeautyCell)
    {
        _faceBeautyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _faceBeautyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _faceBeautyCell.textLabel.text = NSLocalizedString(@"Face Beauty Enable", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:isfaceBeautyEnabled animated:NO];
        [sv addTarget:self action:@selector(onFaceBeautyEnable:) forControlEvents:UIControlEventValueChanged];
        _faceBeautyCell.accessoryView = sv;
    }
    
    return _faceBeautyCell;
}

- (UITableViewCell*)videoMirrorCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL isMirror = [settings isMirrorEffectEnabled];
    
    if (!_videoMirrorCell)
    {
        _videoMirrorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _videoMirrorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _videoMirrorCell.textLabel.text = NSLocalizedString(@"Video Mirror Enable", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:isMirror animated:NO];
        [sv addTarget:self action:@selector(onVideoMirrorEnable:) forControlEvents:UIControlEventValueChanged];
        _videoMirrorCell.accessoryView = sv;
    }
    
    return _videoMirrorCell;
}


- (UITableViewCell*)micOriginalInputCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL micOriginalInputEnabled = [settings micOriginalInputEnabled];
    
    if (!_micOriginalInputCell)
    {
        _micOriginalInputCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _micOriginalInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _micOriginalInputCell.textLabel.text = NSLocalizedString(@"Use Original Sound", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:micOriginalInputEnabled animated:NO];
        [sv addTarget:self action:@selector(onMicOriginalInputEnable:) forControlEvents:UIControlEventValueChanged];
        _micOriginalInputCell.accessoryView = sv;
    }
    
    return _micOriginalInputCell;
}

- (UITableViewCell*)titleHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingTitleHidden];
    
    if (!_titleHiddenCell)
    {
        _titleHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _titleHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Title", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingTitle:) forControlEvents:UIControlEventValueChanged];
        _titleHiddenCell.accessoryView = sv;
    }
    
    return _titleHiddenCell;
}

- (UITableViewCell*)hiddenSelfViewCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings isHideSelfViewEnabled];
    
    if (!_hiddenSelfViewCell)
    {
        _hiddenSelfViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _hiddenSelfViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _hiddenSelfViewCell.textLabel.text = NSLocalizedString(@"Hide My View", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideSelfView:) forControlEvents:UIControlEventValueChanged];
        _hiddenSelfViewCell.accessoryView = sv;
    }
    
    return _hiddenSelfViewCell;
}

- (void)onHideSelfView:(id)sender {
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setHiddenMySelfView:sv.on];
}

- (UITableViewCell*)passwordHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingPasswordHidden];
    
    if (!_passwordHiddenCell)
    {
        _passwordHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _passwordHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _passwordHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Password", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingPassword:) forControlEvents:UIControlEventValueChanged];
        _passwordHiddenCell.accessoryView = sv;
    }
    
    return _passwordHiddenCell;
}

- (UITableViewCell*)leaveHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingLeaveHidden];
    
    if (!_leaveHiddenCell)
    {
        _leaveHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _leaveHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _leaveHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Leave", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingLeave:) forControlEvents:UIControlEventValueChanged];
        _leaveHiddenCell.accessoryView = sv;
    }
    
    return _leaveHiddenCell;
}

- (UITableViewCell*)audioHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingAudioHidden];
    
    if (!_audioHiddenCell)
    {
        _audioHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _audioHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _audioHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Audio", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingAudio:) forControlEvents:UIControlEventValueChanged];
        _audioHiddenCell.accessoryView = sv;
    }
    
    return _audioHiddenCell;
}

- (UITableViewCell*)videoHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingVideoHidden];
    
    if (!_videoHiddenCell)
    {
        _videoHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _videoHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _videoHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Video", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingVideo:) forControlEvents:UIControlEventValueChanged];
        _videoHiddenCell.accessoryView = sv;
    }
    
    return _videoHiddenCell;
}

- (UITableViewCell*)inviteHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingInviteHidden];
    
    if (!_inviteHiddenCell)
    {
        _inviteHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _inviteHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _inviteHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Invite", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingInvite:) forControlEvents:UIControlEventValueChanged];
        _inviteHiddenCell.accessoryView = sv;
    }
    
    return _inviteHiddenCell;
}

- (UITableViewCell*)inviteUrlHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingInviteUrlHidden];
    
    if (!_inviteUrlHiddenCell)
    {
        _inviteUrlHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _inviteUrlHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _inviteUrlHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Invite Url", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingInviteUrl:) forControlEvents:UIControlEventValueChanged];
        _inviteUrlHiddenCell.accessoryView = sv;
    }
    
    return _inviteUrlHiddenCell;
}


- (UITableViewCell*)chatHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingChatHidden];
    
    if (!_chatHiddenCell)
    {
        _chatHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _chatHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _chatHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Chat", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingChat:) forControlEvents:UIControlEventValueChanged];
        _chatHiddenCell.accessoryView = sv;
    }
    
    return _chatHiddenCell;
}

- (UITableViewCell*)participantHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingParticipantHidden];
    
    if (!_participantHiddenCell)
    {
        _participantHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _participantHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _participantHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Participant", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingParticipant:) forControlEvents:UIControlEventValueChanged];
        _participantHiddenCell.accessoryView = sv;
    }
    
    return _participantHiddenCell;
}

- (UITableViewCell*)shareHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingShareHidden];
    
    if (!_shareHiddenCell)
    {
        _shareHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _shareHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _shareHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting Share", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingShare:) forControlEvents:UIControlEventValueChanged];
        _shareHiddenCell.accessoryView = sv;
    }
    
    return _shareHiddenCell;
}

- (UITableViewCell*)moreHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings meetingMoreHidden];
    
    if (!_moreHiddenCell)
    {
        _moreHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _moreHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _moreHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting More", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingMore:) forControlEvents:UIControlEventValueChanged];
        _moreHiddenCell.accessoryView = sv;
    }
    
    return _moreHiddenCell;
}

- (UITableViewCell*)topBarHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings topBarHidden];
    
    if (!_topBarHiddenCell)
    {
        _topBarHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _topBarHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _topBarHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting TopBar", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingTopBar:) forControlEvents:UIControlEventValueChanged];
        _topBarHiddenCell.accessoryView = sv;
    }
    
    return _topBarHiddenCell;
}

- (UITableViewCell*)botBarHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings bottomBarHidden];
    
    if (!_botBarHiddenCell)
    {
        _botBarHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _botBarHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _botBarHiddenCell.textLabel.text = NSLocalizedString(@"Hide Meeting BottomBar", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideMeetingBotBar:) forControlEvents:UIControlEventValueChanged];
        _botBarHiddenCell.accessoryView = sv;
    }
    
    return _botBarHiddenCell;
}

- (UITableViewCell*)webinarQACell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings qaButtonHidden];
    
    if (!_webinarQACell)
    {
        _webinarQACell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _webinarQACell.selectionStyle = UITableViewCellSelectionStyleNone;
        _webinarQACell.textLabel.text = NSLocalizedString(@"Hide Meeting Webinar Q&A", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideWebinarQACell:) forControlEvents:UIControlEventValueChanged];
        _webinarQACell.accessoryView = sv;
    }
    
    return _webinarQACell;
}

- (UITableViewCell*)callinRoomSystemHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings callinRoomSystemHidden];
    
    if (!_callinRoomSystemHiddenCell)
    {
        _callinRoomSystemHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _callinRoomSystemHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _callinRoomSystemHiddenCell.textLabel.text = NSLocalizedString(@"Hide Call In Room System", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onCallinRoomSystem:) forControlEvents:UIControlEventValueChanged];
        _callinRoomSystemHiddenCell.accessoryView = sv;
    }
    
    return _callinRoomSystemHiddenCell;
}

- (UITableViewCell*)calloutRoomSystemHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings calloutRoomSystemHidden];
    
    if (!_calloutRoomSystemHiddenCell)
    {
        _calloutRoomSystemHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _calloutRoomSystemHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _calloutRoomSystemHiddenCell.textLabel.text = NSLocalizedString(@"Hide Call Out Room System", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onCalloutRoomSystem:) forControlEvents:UIControlEventValueChanged];
        _calloutRoomSystemHiddenCell.accessoryView = sv;
    }
    
    return _calloutRoomSystemHiddenCell;
}

- (UITableViewCell*)claimHostWithHostKeyHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings claimHostWithHostKeyHidden];
    
    if (!_claimHostWithHostKeyHiddenCell)
    {
        _claimHostWithHostKeyHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _claimHostWithHostKeyHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _claimHostWithHostKeyHiddenCell.textLabel.text = NSLocalizedString(@"Hide Claim Host With HostKey", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onClaimHostWithHostKey:) forControlEvents:UIControlEventValueChanged];
        _claimHostWithHostKeyHiddenCell.accessoryView = sv;
    }
    
    return _claimHostWithHostKeyHiddenCell;
}

- (UITableViewCell*)closeCaptionHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings closeCaptionHidden];
    
    if (!_closeCaptionHiddenCell)
    {
        _closeCaptionHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _closeCaptionHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _closeCaptionHiddenCell.textLabel.text = NSLocalizedString(@"Hide Close Caption", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onCloseCaption:) forControlEvents:UIControlEventValueChanged];
        _closeCaptionHiddenCell.accessoryView = sv;
    }
    
    return _closeCaptionHiddenCell;
}

- (UITableViewCell*)promoteToPanelistHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings promoteToPanelistHidden];
    
    if (!_promoteToPanelistHiddenCell)
    {
        _promoteToPanelistHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _promoteToPanelistHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _promoteToPanelistHiddenCell.textLabel.text = NSLocalizedString(@"Hide Promote To Panelist", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onPromoteToPanelist:) forControlEvents:UIControlEventValueChanged];
        _promoteToPanelistHiddenCell.accessoryView = sv;
    }
    
    return _promoteToPanelistHiddenCell;
}

- (UITableViewCell*)changeToAttendeeHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings changeToAttendeeHidden];
    
    if (!_changeToAttendeeHiddenCell)
    {
        _changeToAttendeeHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _changeToAttendeeHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _changeToAttendeeHiddenCell.textLabel.text = NSLocalizedString(@"Hide Change To Attendee", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onChangeToAttendee:) forControlEvents:UIControlEventValueChanged];
        _changeToAttendeeHiddenCell.accessoryView = sv;
    }
    
    return _changeToAttendeeHiddenCell;
}

- (UITableViewCell*)reactionsOnMeetingUIHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings reactionsOnMeetingUIHidden];
    
    if (!_reactionsOnMeetingUIHiddenCell)
    {
        _reactionsOnMeetingUIHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _reactionsOnMeetingUIHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _reactionsOnMeetingUIHiddenCell.textLabel.text = NSLocalizedString(@"Hide Reactions OnMeetingUI", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onReactionsOnMeetingUI:) forControlEvents:UIControlEventValueChanged];
        _reactionsOnMeetingUIHiddenCell.accessoryView = sv;
    }
    
    return _reactionsOnMeetingUIHiddenCell;
}

- (UITableViewCell*)recordButtonHiddenCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings recordButtonHidden];
    
    if (!_recordButtonHiddenCell)
    {
        _recordButtonHiddenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _recordButtonHiddenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _recordButtonHiddenCell.textLabel.text = NSLocalizedString(@"Hide Record Button", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onRecordButtonHidden:) forControlEvents:UIControlEventValueChanged];
        _recordButtonHiddenCell.accessoryView = sv;
    }
    
    return _recordButtonHiddenCell;
}

- (UITableViewCell*)hideNovideoUserEnableCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings isHideNoVideoUsersEnabled];
    
    if (!_hideNovideoUserEnableCell)
    {
        _hideNovideoUserEnableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _hideNovideoUserEnableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _hideNovideoUserEnableCell.textLabel.text = NSLocalizedString(@"Show Non-Video Participants", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onNoVideoButtonHidden:) forControlEvents:UIControlEventValueChanged];
        _hideNovideoUserEnableCell.accessoryView = sv;
    }
    
    return _hideNovideoUserEnableCell;
}

- (UITableViewCell*)thumbnailCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings thumbnailInShare];
    
    if (!_thumbnailCell)
    {
        _thumbnailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _thumbnailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _thumbnailCell.textLabel.text = NSLocalizedString(@"Change Thumbnail In Sharing", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideThumbnail:) forControlEvents:UIControlEventValueChanged];
        _thumbnailCell.accessoryView = sv;
    }
    
    return _thumbnailCell;
}

- (UITableViewCell*)sendRawdataCell
{
    if (!_sendRawdataCell)
    {
        _sendRawdataCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _sendRawdataCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _sendRawdataCell.textLabel.text = NSLocalizedString(@"Send Raw Data", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        BOOL enableRawdataSend = [[NSUserDefaults standardUserDefaults] boolForKey:Raw_Data_Send_Enable];
        [sv setOn:enableRawdataSend animated:NO];
        [sv addTarget:self action:@selector(onSendRawdata:) forControlEvents:UIControlEventValueChanged];
        _sendRawdataCell.accessoryView = sv;
    }
    
    return _sendRawdataCell;
}

- (UITableViewCell*)hostLeaveCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings hostLeaveHidden];
    
    if (!_hostLeaveCell)
    {
        _hostLeaveCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _hostLeaveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _hostLeaveCell.textLabel.text = NSLocalizedString(@"Host Hide Leave Meeting", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideHostLeave:) forControlEvents:UIControlEventValueChanged];
        _hostLeaveCell.accessoryView = sv;
    }
    
    return _hostLeaveCell;
}

- (UITableViewCell*)hintCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings hintHidden];
    
    if (!_hintCell)
    {
        _hintCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _hintCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _hintCell.textLabel.text = NSLocalizedString(@"Hide Hint in Meeting", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideHint:) forControlEvents:UIControlEventValueChanged];
        _hintCell.accessoryView = sv;
    }
    
    return _hintCell;
}

- (UITableViewCell*)disconnectAudioCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings disconnectAudioHidden];
    
    if (!_disconnectAudioCell)
    {
        _disconnectAudioCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _disconnectAudioCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _disconnectAudioCell.textLabel.text = NSLocalizedString(@"Hide disconnect audio in more menu", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onDisconnectAudio:) forControlEvents:UIControlEventValueChanged];
        _disconnectAudioCell.accessoryView = sv;
    }
    
    return _disconnectAudioCell;
}

- (UITableViewCell*)waitingHUDCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings waitingHUDHidden];
    
    if (!_waitingHUDCell)
    {
        _waitingHUDCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _waitingHUDCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _waitingHUDCell.textLabel.text = NSLocalizedString(@"Hide Waiting HUD", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onHideWaitingHUD:) forControlEvents:UIControlEventValueChanged];
        _waitingHUDCell.accessoryView = sv;
    }
    
    return _waitingHUDCell;
}

- (UITableViewCell*)customMeetingCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL enableCustomMeeting = [settings enableCustomMeeting];
    if (!_customMeetingCell)
    {
        _customMeetingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _customMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _customMeetingCell.textLabel.text = NSLocalizedString(@"Custom Meeting", @"");
        _customMeetingCell.tag = Custom_Meeting_Cell_Tag;
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:enableCustomMeeting animated:NO];
        [sv addTarget:self action:@selector(onEnableCustomMeetingHint:) forControlEvents:UIControlEventValueChanged];
        _customMeetingCell.accessoryView = sv;
    }
    return _customMeetingCell;
}

- (UITableViewCell*)rawdataUICell
{
    if (!_rawdataUICell)
    {
        _rawdataUICell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _rawdataUICell.tag = Raw_Data_Cell_Tag;
        _rawdataUICell.selectionStyle = UITableViewCellSelectionStyleNone;
        _rawdataUICell.textLabel.text = @"Rawdata UI";
        
        BOOL enbleRawdataUI = [[NSUserDefaults standardUserDefaults] boolForKey:Raw_Data_UI_Enable];
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:enbleRawdataUI animated:NO];
        [sv addTarget:self action:@selector(onEnableRawdataUIHint:) forControlEvents:UIControlEventValueChanged];
        _rawdataUICell.accessoryView = sv;
    }
    return _rawdataUICell;
}

- (UITableViewCell*)showMyMeetingElapseTimeCell
{
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if (!settings)
        return nil;
    
    BOOL hidden = [settings showMyMeetingElapseTime];
    
    if (!_showMyMeetingElapseTimeCell)
    {
        _showMyMeetingElapseTimeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _showMyMeetingElapseTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _showMyMeetingElapseTimeCell.textLabel.text = NSLocalizedString(@"Show My Elapse Time", @"");
        
        UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sv setOn:hidden animated:NO];
        [sv addTarget:self action:@selector(onEnableShowMyMeetingElapseTime:) forControlEvents:UIControlEventValueChanged];
        _showMyMeetingElapseTimeCell.accessoryView = sv;
    }
    return _showMyMeetingElapseTimeCell;
}

- (UITableViewCell*)reactionSkinToneCell
{
    if (!_reactionSkinToneCell)
    {
        _reactionSkinToneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        _reactionSkinToneCell.selectionStyle = UITableViewCellSelectionStyleGray;
        _reactionSkinToneCell.textLabel.text = NSLocalizedString(@"Change emoji reaction skin tone", @"");
        MobileRTCEmojiReactionSkinTone skinTone = [[[MobileRTC sharedRTC] getMeetingSettings] reactionSkinTone];
        switch (skinTone) {
            case MobileRTCEmojiReactionSkinTone_Default:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Default";
                break;
            case MobileRTCEmojiReactionSkinTone_Light:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Light";
                break;
            case MobileRTCEmojiReactionSkinTone_MediumLight:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_MediumLight";
                break;
            case MobileRTCEmojiReactionSkinTone_Medium:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Medium";
                break;
            case MobileRTCEmojiReactionSkinTone_MediumDark:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_MediumDark";
                break;
            case MobileRTCEmojiReactionSkinTone_Dark:
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Dark";
                break;
            default:
    //            MobileRTCEmojiReactionSkinTone_Unknown
                _reactionSkinToneCell.detailTextLabel.text = @"SkinTone_Unknown";
                break;
        }
    }
    return _reactionSkinToneCell;
}

- (SDKMeetingSettingPresenter *)settingPresenter
{
    if (!_settingPresenter) {
        _settingPresenter = [[SDKMeetingSettingPresenter alloc] init];
    }
    return _settingPresenter;
}


- (void)onAutoConnectAudio:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setAutoConnectInternetAudio:sv.on];
}

- (void)onMuteAudio:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMuteAudioWhenJoinMeeting:sv.on];
}

- (void)onMuteVideo:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMuteVideoWhenJoinMeeting:sv.on];
}

- (void)onDisableDriveMode:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableDriveMode:sv.on];
}

- (void)onDisableGalleryView:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableGalleryView:sv.on];
}

- (void)onDisableCloudWhiteboard:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableCloudWhiteboard:sv.on];
}

- (void)onDisableVideoPreview:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onDisableVideoPreview:sv.on];
}

- (void)onDisableVirtualBackground:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onDisableVirtualBackground:sv.on];
}

- (void)onDisableCopyMeetinUrl:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onDisableCopyMeetinUrl:sv.on];
}

- (void)onProximityMonitoring:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onProximityMonitoring:sv.on];
}

- (void)onSpeakerWhenInMeeting:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onSpeakerWhenInMeeting:sv.on];
}

- (void)onDisableClearWeb:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter onDisableClearWeb:sv.on];
}

- (void)onDisableCallIn:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableCallIn:sv.on];
}

- (void)onDisableCallOut:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableCallOut:sv.on];
}

- (void)onHideCloudWBShare:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [[MobileRTC sharedRTC] getMeetingSettings].hideShareButtonOnCloudWhiteboard = sv.on;
}

- (void)onHideCloudWBFeedback:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [[MobileRTC sharedRTC] getMeetingSettings].hideFeedbackButtonOnCloudWhiteboard = sv.on;
}

- (void)onDisableMinimizeMeeting:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter disableMinimizeMeeting:sv.on];
}

- (void)onFaceBeautyEnable:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter faceBeautyEnable:sv.on];
}

- (void)onVideoMirrorEnable:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter videoMirrorEnable:sv.on];
}

- (void)onMicOriginalInputEnable:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter enableMicOriginalInput:sv.on];
}

- (void)onHideMeetingTitle:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingTitleHidden:sv.on];
}

- (void)onHideMeetingPassword:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingPasswordHidden:sv.on];
}

- (void)onHideMeetingLeave:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingLeaveHidden:sv.on];
}

- (void)onHideMeetingAudio:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingAudioHidden:sv.on];
}

- (void)onHideMeetingVideo:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingVideoHidden:sv.on];
}

- (void)onHideMeetingInvite:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingInviteHidden:sv.on];
}

- (void)onHideMeetingInviteUrl:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingInviteUrlHidden:sv.on];
}

- (void)onHideMeetingChat:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingChatHidden:sv.on];
}


- (void)onHideMeetingParticipant:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingParticipantHidden:sv.on];
}

- (void)onHideMeetingShare:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingShareHidden:sv.on];
}

- (void)onHideMeetingMore:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setMeetingMoreHidden:sv.on];
}

- (void)onHideMeetingTopBar:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setTopBarHidden:sv.on];
}

- (void)onHideMeetingBotBar:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setBottomBarHidden:sv.on];
}

- (void)onHideWebinarQACell:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setQaButtonHidden:sv.on];
}

- (void)onCallinRoomSystem:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setCallinRoomSystemHidden:sv.on];
}

- (void)onCalloutRoomSystem:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setCalloutRoomSystemHidden:sv.on];
}

- (void)onClaimHostWithHostKey:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setClaimHostWithHostKeyHidden:sv.on];
}

- (void)onCloseCaption:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setCloseCaptionHidden:sv.on];
}

- (void)onPromoteToPanelist:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setPromoteToPanelistHidden:sv.on];
}

- (void)onChangeToAttendee:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setChangeToAttendeeHiddenHidden:sv.on];
}

- (void)onReactionsOnMeetingUI:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setReactionsOnMeetingUI:sv.on];
}

- (void)onRecordButtonHidden:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setRecordButtonHidden:sv.on];
}

- (void)onNoVideoButtonHidden:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setHideNoVideoUsersEnabled:sv.on];
}

- (void)onHideThumbnail:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setThumbnailInShare:sv.on];
}

- (void)onHideHostLeave:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setHostLeaveHidden:sv.on];
}

- (void)onHideHint:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setHintHidden:sv.on];
}

- (void)onDisconnectAudio:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setDisconnectAudioHidden:sv.on];
}

- (void)onHideWaitingHUD:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setWaitingHUDHidden:sv.on];
}

- (void)onEnableCustomMeetingHint:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter setEnableCustomMeeting:sv.on];
    BOOL hasRawDataLicense = [[MobileRTC sharedRTC] hasRawDataLicense];
    if (sv.on) {
        if (hasRawDataLicense) {
            for (int i = 0; i < self.itemArray.count; i++) {
                NSMutableArray *sectionArray = self.itemArray[i];
                for (int j = 0; j < sectionArray.count; j++) {
                    UITableViewCell *cell = sectionArray[j];
                    if (Custom_Meeting_Cell_Tag == cell.tag) {
                        [sectionArray insertObject:[self rawdataUICell] atIndex:j+1];
                        [self.tableView reloadData];
                        return;
                    }
                }
            }
        }
    } else {
        for (int i = 0; i < self.itemArray.count; i++) {
            NSMutableArray *sectionArray = self.itemArray[i];
            for (int j = 0; j < sectionArray.count; j++) {
                UITableViewCell *cell = sectionArray[j];
                if (Raw_Data_Cell_Tag == cell.tag) {
                    [sectionArray removeObjectAtIndex:j];
                    [self.tableView reloadData];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:Raw_Data_UI_Enable];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    return;
                }
            }
        }
    }
}

- (void)onEnableRawdataUIHint:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:sv.on forKey:Raw_Data_UI_Enable];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)onEnableShowMyMeetingElapseTime:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self.settingPresenter enableShowMyMeetingElapseTime:sv.on];
}

- (void)onSendRawdata:(id)sender
{
    UISwitch *sv = (UISwitch*)sender;
    [self enableSendRawdata:sv.on];
}

-(void)enableSendRawdata:(BOOL)enable {
    if (enable) {
        SendYUVAdapter *yuvAdapter = [[SendYUVAdapter alloc] init];
        [[[MobileRTC sharedRTC] getVideoSourceHelper] setExternalVideoSource:yuvAdapter];
    } else {
        [[[MobileRTC sharedRTC] getVideoSourceHelper] setExternalVideoSource:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:Raw_Data_Send_Enable];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
