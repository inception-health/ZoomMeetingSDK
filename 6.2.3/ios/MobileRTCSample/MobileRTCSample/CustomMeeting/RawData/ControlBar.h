//
//  ControlBar.h
//
//  Created by Zoom Video Communications on 2019/5/27.
//  Copyright © 2019 Zoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraCaptureAdapter.h"
#import "SendPictureAdapter.h"
#import "SendYUVAdapter.h"
#import "SendYUVShareAdapter.h"
#import "SendPCMAdapter.h"


#define kTagButtonSwitch        2000
#define kTagButtonAudio         (kTagButtonSwitch+1)
#define kTagButtonVideo         (kTagButtonSwitch+2)
#define kTagButtonMore          (kTagButtonSwitch+3)
#define kTagButtonShare          (kTagButtonSwitch+4)


NS_ASSUME_NONNULL_BEGIN

@interface ControlBar : UIView
- (void)updateMyAudioStatus;
- (void)updateMyVideoStatus;

@property (nonatomic,strong) CameraCaptureAdapter *cameraAdapter;
@property (nonatomic,strong) SendPictureAdapter *picAdapter;
@property (nonatomic,strong) SendYUVAdapter     *yuvAdapter;
@property (nonatomic,strong) SendYUVShareAdapter *yuvShareAdapter;
@property (nonatomic,strong) SendPCMAdapter *pcmAudioAdapter;

@property(nonatomic,copy) void(^MyBlock)(int Tag);

@end

NS_ASSUME_NONNULL_END
