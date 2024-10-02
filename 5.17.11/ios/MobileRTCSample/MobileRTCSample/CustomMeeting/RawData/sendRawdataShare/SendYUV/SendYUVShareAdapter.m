//
//  SendYUVShareAdapter.m
//  ZoomInstantSample
//
//  Created by Zoom Video Communications on 2020/7/8.
//  Copyright © 2020 Zoom. All rights reserved.
//

#import "SendYUVShareAdapter.h"

#define Default_fps 30
#define usec_per_fps (1000000/Default_fps)

@interface SendYUVShareAdapter ()
@property (nonatomic, strong) MobileRTCShareSender *shareRawdataSender;
@property (nonatomic, strong) MobileRTCShareAudioSender *audioSender;
@property (strong, nonatomic) NSThread  *workThread;
@property (strong, nonatomic) NSThread  *workThreadAudio;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@end

@implementation SendYUVShareAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [self stop];
    [self stopAudio];
}



#pragma mark - send raw data cb -
- (void)onStartSend:(MobileRTCShareSender *_Nonnull)sender
{
    self.shareRawdataSender = sender;
    self.width = 640;
    self.height = 480;
    
    [self beginPullVideo];
}

- (void)onStopSend {
    self.shareRawdataSender = nil;
    [self stop];
}

- (void)beginPullVideo
{
    self.sharing = YES;
    if (self.workThread == nil) {
        self.workThread = [[NSThread alloc] initWithTarget:self selector:@selector(pullRunloop) object:nil];
        [self.workThread start];
    }
}

- (void)pullRunloop
{
    NSString *lpath = [[NSBundle mainBundle] pathForResource:@"zoom_640X480" ofType:@"yuv"];
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
    FILE *yuvFile = fopen([path UTF8String], "rb");
    if (yuvFile == NULL) {
        NSLog(@"open yuv failed");
        return;
    }
    if (self.width <= 0 || self.height <= 0) {
        NSLog(@"yuv width or heigh = 0");
        return;
    }
    
    BOOL needRetry = NO;
//    NSLog(@"begain pull video");
    while (![NSThread currentThread].isCancelled) {

        unsigned char * yuvFrame = malloc(self.height*self.width* 3 / 2);
        
        size_t uAddress = self.height*self.width;
        size_t vAddress = self.height*self.width * 5 / 4;
        
        size_t size = fread(&yuvFrame[0], 1, self.width * self.height, yuvFile);
        size = fread(&yuvFrame[uAddress], 1, self.width * self.height/4, yuvFile);
        size = fread(&yuvFrame[vAddress], 1, self.width * self.height/4, yuvFile);
        
        if (size == 0) {
            NSLog(@"read data size = 0");
            needRetry = YES;
            break;
        }
        
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self.shareRawdataSender sendShareFrameBuffer:(char *)yuvFrame width:self.width height:self.height frameLength:self.height*self.width*1.5];
             free(yuvFrame);
         });
        
        usleep(usec_per_fps);
    }
    
    fclose(yuvFile);
    yuvFile = NULL;
//    NSLog(@"end pull video");
    [self stop];
    if (needRetry) {
        [self beginPullVideo];
    }
}

- (void)stop
{
    self.sharing = NO;
    if (self.workThread) {
        [self.workThread cancel];
        self.workThread = nil;
    }
}


//-----------------------------------audio--------------------------------------------------------

#define kSampleRate 16000
#define kAudioBit 16
#define kChannelNum 2
- (void)onStartSendAudio:(MobileRTCShareAudioSender *_Nonnull)sender
{
    if (!sender) return;
    
    self.audioSender = sender;
    [self beginPullAudio];
}

- (void)onStopSendAudio
{
    [self stopAudio];
}


- (void)beginPullAudio
{
    if (self.workThreadAudio == nil) {
        self.workThreadAudio = [[NSThread alloc] initWithTarget:self selector:@selector(pullRunloopAudio) object:nil];
        [self.workThreadAudio start];
    }
}

- (void)pullRunloopAudio
{
    NSString *lpath = [[NSBundle mainBundle] pathForResource:@"16000_stereo" ofType:@"wav"];
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
        unsigned char * pcmFrame = malloc(kAudioBit / 8 * kSampleRate * kChannelNum);
        size_t size = fread(&pcmFrame[0], kAudioBit/8, kSampleRate * kChannelNum, pcmFile);
        
        if (size == 0) {
            NSLog(@"read data size = 0");
            needRetry = YES;
            break;
        }
        
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self.audioSender sendShareAudio:pcmFrame dataLength:(kAudioBit / 8 * kSampleRate * kChannelNum) sampleRate:kSampleRate audioChannel:MobileRTCAudioChannel_Stereo];
             free(pcmFrame);
         });
        
        usleep(1000000);
    }
    
    fclose(pcmFile);
    pcmFile = NULL;
    //    NSLog(@"end pull audio");
    [self stopAudio];
    if (needRetry) {
        [self beginPullAudio];
    }
}

- (void)stopAudio
{
    if (self.workThreadAudio) {
        [self.workThreadAudio cancel];
        self.workThreadAudio = nil;
    }
}
@end
