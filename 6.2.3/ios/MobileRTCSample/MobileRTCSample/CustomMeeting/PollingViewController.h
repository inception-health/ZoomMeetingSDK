//
//  PollingViewController.h
//  MobileRTCSample
//
//  Created by Zoom on 2023/12/1.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PollingActions) {
    // Common
    Polling_Common_canDoPolling = 100,
    Polling_Common_getActivePollingID,
    Polling_Common_getPollingQuestionItemList,
    Polling_Common_getPollingSubQuestionItemList,
    Polling_Common_getPollingAnswerItemList,
    Polling_Common_canGetRightAnswerItemList,
    Polling_Common_getPollingRightAnswerItemList,
    Polling_Common_canShowAnswerResultList,
    Polling_Common_getPollingAnswerResultItemList,
    Polling_Common_getPollingItemByID,
    Polling_Common_getPollingAnswerItemByID,
    Polling_Common_getPollingQuestionImagePath,
    Polling_Common_getQuestionCharactersMinLen,
    Polling_Common_getQuestionCharactersMaxLen,
    Polling_Common_isQuestionCaseSensitive,

    // host
    Polling_Host_canAddPolling,
    Polling_Host_addPolling,
    Polling_Host_canEditPolling,
    Polling_Host_editPolling,
    Polling_Host_canDeletePolling,
    Polling_Host_deletePolling,
    Polling_Host_canDuplicatePolling,
    Polling_Host_duplicatePolling,
    Polling_Host_canViewPollingResultFromBrowser,
    Polling_Host_viewPollingResultFromBrowser,
    Polling_Host_getPollingItemList,
    Polling_Host_canStartPolling,
    Polling_Host_startPolling,
    Polling_Host_stopPolling,
    Polling_Host_canRestartPolling,
    Polling_Host_restartPolling,
    Polling_Host_canSharePollingResult,
    Polling_Host_startSharePollingResult,
    Polling_Host_stopSharePollingResult,
    Polling_Host_enableGetRightAnswerList,
    Polling_Host_canDownloadResult,
    Polling_Host_downLoadResult,

    // Attendee
    Polling_Attendee_setAnswerCheck,
    Polling_Attendee_setAnswerContent,
    Polling_Attendee_canSubmitPolling,
    Polling_Attendee_submitPolling,
};

#define kPOLLING_NOTIFICATION_DATA_UPDATE @"kPOLLING_NOTIFICATION_DATA_UPDATE"

@interface PollingViewController : UIViewController

@end

