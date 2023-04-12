//
//  SendPCMAdapter.m
//  MobileRTCSample
//
//  Created by Zoom on 2022/7/27.
//  Copyright © 2022 Zoom Video Communications, Inc. All rights reserved.
//

#import "SendPCMAdapter.h"

#define kSampleRate 44100
#define kAudioBit 16

@interface SendPCMAdapter ()

@property (nonatomic, strong) MobileRTCAudioSender *audioRawdataSender;
@property (strong, nonatomic) NSThread  *workThread;

@end

@implementation SendPCMAdapter

- (void)onDeviceInitialize:(MobileRTCAudioSender *_Nonnull)rawdataSender
{
    NSLog(@"onDeviceInitialize:");
    self.audioRawdataSender = rawdataSender;
}
- (void)onStartSendData {
    NSLog(@"onStartSendData:");
    [self beginPullAudio];
}
- (void)onStopSendData {
    NSLog(@"onStopSendData");
    [self stop];
}

- (void)onDeviceUninitialize {
    NSLog(@"onDeviceUninitialize");
    self.audioRawdataSender = nil;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [self stop];
}


#pragma mark - send raw data cb -


- (void)beginPullAudio
{
    if (self.workThread == nil) {
        self.workThread = [[NSThread alloc] initWithTarget:self selector:@selector(pullRunloop) object:nil];
        [self.workThread start];
    }
}

- (void)pullRunloop
{
    NSString *lpath = [[NSBundle mainBundle] pathForResource:@"test_16bit_44100" ofType:@"wav"];
    if (lpath.length == 0) {
        NSLog(@"lpath = nil");
        return;
    }
    NSURL *fileUrl = [NSURL fileURLWithPath:lpath];
    NSString *path = fileUrl.path;
    if (path.length == 0) {
        NSLog(@"path = nil");
        return;
    }
    
    // read file in binary
    FILE *pcmFile = fopen([path UTF8String], "rb");
    if (pcmFile == NULL) {
        NSLog(@"open pcm failed");
        return;
    }

    
    BOOL needRetry = NO;
//    NSLog(@"begain pull audio");
    while (![NSThread currentThread].isCancelled) {

        unsigned char * pcmFrame = malloc(kAudioBit / 8 * kSampleRate);
        
        size_t size = fread(&pcmFrame[0], kAudioBit/8, kSampleRate, pcmFile);
        
        if (size == 0) {
            NSLog(@"read data size = 0");
            needRetry = YES;
            break;
        }
        
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self.audioRawdataSender send:(char *)pcmFrame dataLength:kAudioBit / 8 * kSampleRate sampleRate:kSampleRate];
             free(pcmFrame);
         });
        
        usleep(1000000);
    }
    
    fclose(pcmFile);
    pcmFile = NULL;
    //    NSLog(@"end pull audio");
    [self stop];
    if (needRetry) {
        [self beginPullAudio];
    }
}

- (void)stop
{
    if (self.workThread) {
        [self.workThread cancel];
        self.workThread = nil;
    }
}

@end
