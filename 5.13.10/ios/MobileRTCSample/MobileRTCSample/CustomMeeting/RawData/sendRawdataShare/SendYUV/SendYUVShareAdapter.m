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

@property (strong, nonatomic) NSThread  *workThread;
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
}



#pragma mark - send raw data cb -
- (void)onStartSend:(MobileRTCShareSender *_Nonnull)sender
{
    self.shareRawdataSender = sender;
    self.width = 1280;
    self.height = 720;
    
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
    NSString *lpath = [[NSBundle mainBundle] pathForResource:@"zoom_1280x720_i420_full" ofType:@"yuv"];
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

@end
