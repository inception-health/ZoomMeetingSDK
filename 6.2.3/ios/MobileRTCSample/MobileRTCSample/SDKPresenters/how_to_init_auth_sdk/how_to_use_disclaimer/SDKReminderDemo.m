//
//  SDKDReminderDemo.m
//  MobileRTCSample
//
//  Created by Jackie Chen on 3/27/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKReminderDemo.h"

@implementation SDKReminderDemo

- (void)setReminderDelegate
{
    MobileRTCReminderHelper *reminder = [[MobileRTC sharedRTC] getReminderHelper];
    if (reminder) reminder.reminderDelegate = self;
}

- (void)onReminderNotify:(MobileRTCReminderContent *)content handle:(MobileRTCReminderHandler *)handler
{
//    [handler declined];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:content.title
                                                                             message:content.content
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler accept];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Declined" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [handler declined];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [handler ignore];
    }]];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appDelegate topViewController] presentViewController:alertController animated:YES completion:nil];

}


@end
