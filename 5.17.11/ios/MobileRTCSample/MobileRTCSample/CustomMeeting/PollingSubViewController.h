//
//  PollingQuestionViewController.h
//  MobileRTCSample
//
//  Created by Zoom on 2023/12/2.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PollingSubViewType) {
    // Common
    PollingSubViewType_QuestionItem=0,
    PollingSubViewType_SubQuestionItem,
    PollingSubViewType_AnswerItem,
    PollingSubViewType_AnswerResultItem,
    
};

@interface PollingSubViewController : UIViewController
@property (nonatomic, assign)   PollingSubViewType          subViewType;

@property (nonatomic, strong)   NSString          *pollingID;
//@property (nonatomic, strong)   NSString          *questionID;
//@property (nonatomic, strong)   NSString          *answerID;

@property (nonatomic, strong)   NSArray          *dataSource;
@end

