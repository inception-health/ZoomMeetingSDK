//
//  SendYUVShareAdapter.h
//  ZoomInstantSample
//
//  Created by Zoom Video Communications on 2020/7/8.
//  Copyright © 2020 Zoom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendYUVShareAdapter : NSObject <MobileRTCShareSourceDelegate>

@property (nonatomic, assign, getter=isSharing) BOOL sharing;

@end

NS_ASSUME_NONNULL_END
