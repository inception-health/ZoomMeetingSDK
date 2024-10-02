//
//  SettingsViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 7/6/15.
//  Copyright (c) 2015 Zoom Video Communications, Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguaguePickerViewController.h"
#import "MeetingSettingsViewController.h"
#import <MobileRTC/MobileRTC.h>
#import "SDKAuthPresenter.h"
#import <MessageUI/MessageUI.h>
#import "SDKAuthPresenter+Login.h"

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UITableViewCell *meetingCell;
@property (strong, nonatomic) UITableViewCell *languageCell;
@property (strong, nonatomic) UITableViewCell *loginCell;
@property (strong, nonatomic) UITableViewCell *scheduleCell;
@property (strong, nonatomic) UITableViewCell *listMeetingCell;
@property (strong, nonatomic) UITableViewCell *swtichDomainCell;

@property (strong, nonatomic) UITableViewCell *customizedInvitationDomainCell;

@property (strong, nonatomic) NSArray *itemArray;

@property (strong, nonatomic) SDKAuthPresenter      *authPresenter;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"");
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    [self initSettingItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSettingItems
{
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:@[[self meetingCell]]];
    
    [array addObject:@[[self languageCell]]];
    
    [array addObject:@[[self swtichDomainCell]]];
    
    [array addObject:@[[self customizedInvitationDomainCell]]];
    
    [array addObject:@[[self loginCell]]];
    
    self.itemArray = array;
    
    [self.tableView reloadData];
}

#pragma mark - Table Cell

- (UITableViewCell*)meetingCell
{
    if (!_meetingCell)
    {
        _meetingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _meetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _meetingCell.textLabel.text = NSLocalizedString(@"Meeting Settings", @"");
        _meetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return _meetingCell;
}

- (UITableViewCell*)languageCell
{
    if (!_languageCell)
    {
        _languageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _languageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _languageCell.textLabel.text = NSLocalizedString(@"Select Language", @"");
        _languageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return _languageCell;
}

- (UITableViewCell *)swtichDomainCell {
    if (!_swtichDomainCell)
    {
        _swtichDomainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _swtichDomainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _swtichDomainCell.textLabel.text = NSLocalizedString(@"Switch Domain and Auth Again", @"");
        _swtichDomainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return _swtichDomainCell;
}

- (UITableViewCell *)customizedInvitationDomainCell {
    if (!_customizedInvitationDomainCell)
    {
        _customizedInvitationDomainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _customizedInvitationDomainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _customizedInvitationDomainCell.textLabel.text = NSLocalizedString(@"Customized Invitation Domain", @"");
        _customizedInvitationDomainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return _customizedInvitationDomainCell;
}

- (UITableViewCell*)loginCell
{
    if (!_loginCell)
    {
        _loginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loginCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _loginCell.textLabel.text = NSLocalizedString(@"Sign In", @"");
        _loginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    BOOL isLoggedIn = [[[MobileRTC sharedRTC] getAuthService] isLoggedIn];
    NSString *title = isLoggedIn ? NSLocalizedString(@"Sign Out", @"") : NSLocalizedString(@"Sign In", @"");
    UIColor *titleColor = isLoggedIn ? [UIColor redColor] : [UIColor blueColor];
    _loginCell.textLabel.text = title;
    _loginCell.textLabel.textColor = titleColor;
    
    return _loginCell;
}

- (SDKAuthPresenter *)authPresenter
{
    return [(AppDelegate *)UIApplication.sharedApplication.delegate authPresenter];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.itemArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.itemArray[section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.itemArray[indexPath.section][indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == (self.itemArray.count - 1)) {
        return [NSString stringWithFormat:@"Version: %@", [MobileRTC sharedRTC].mobileRTCVersion];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.itemArray[indexPath.section][indexPath.row];
    if ([cell isEqual:_languageCell])
    {
        LanguaguePickerViewController * vc = [[LanguaguePickerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else if ([cell isEqual:_meetingCell])
    {
        MeetingSettingsViewController * vc = [[MeetingSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    if ([cell isEqual:_swtichDomainCell]) {
        [self switchDomainAndAuthAgain];
        return;
    }
    else if ([cell isEqual:_customizedInvitationDomainCell])
    {
        [self customizedInvitationDomain];
        return;
    }
    else if ([cell isEqual:_loginCell])
    {
        if ([[[MobileRTC sharedRTC] getAuthService] isLoggedIn])
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[[MobileRTC sharedRTC] getAuthService] logoutRTC];
            }];
        }
        else
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select Login Type", @"")
                                                                                         message:nil
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Login with SSO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self selectSSOAction];
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        return;
    }
}

- (void)switchDomainAndAuthAgain {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Switch domain and auth again", @"")
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"New Domain", @"");
            textField.text = @"";
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"New JWT Token", @"");
            textField.text = @"";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *newDomain = alertController.textFields.firstObject;
            UITextField *newToken = alertController.textFields.lastObject;
          
            BOOL ret = [[MobileRTC sharedRTC] switchDomain:newDomain.text force:YES];
            NSLog(@"switchDomain-ret ===> %d", ret);
            
            [self.authPresenter SDKAuth:newToken.text];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)customizedInvitationDomain
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Customized Invitation Domain", @"")
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"Invitation Domain", @"");
            textField.text = @"";
        }];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *invitationDomainTF = alertController.textFields.firstObject;
            BOOL ret = [[[MobileRTC sharedRTC] getMeetingService] setCustomizedInvitationDomain:invitationDomainTF.text];
            NSLog(@"setCustomizedInvitationDomain==>%@", @(ret));
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)selectSSOAction {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SSO Login Action", @"")
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Generate SSO URL", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self generateSSOURL];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Auth with protocol", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self authWithProtocol];
        }]];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)generateSSOURL {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SSO Login Action", @"")
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"SSO Vanity URL", @"");
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Generate", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *ssoVanityURL = alertController.textFields.firstObject;
            NSString *ssoLoginUrl = [self.authPresenter getSSODomainWithVanityURL:ssoVanityURL.text];
            if (ssoLoginUrl.length > 0) {
                [self showSSOURLAlert:ssoLoginUrl];
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)showSSOURLAlert:(NSString *)SSOURL {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SSO Login URL", @"")
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.text = SSOURL;
            }];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = SSOURL;
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SSOURL]];
            }]];
            
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)authWithProtocol {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SSO Login Action", @"")
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = NSLocalizedString(@"SSO auth protocol", @"");
            }];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Auth", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField *ssoProtocolURL = alertController.textFields.firstObject;
                [self.authPresenter ssoLoginWithWebUriProtocol:ssoProtocolURL.text];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
