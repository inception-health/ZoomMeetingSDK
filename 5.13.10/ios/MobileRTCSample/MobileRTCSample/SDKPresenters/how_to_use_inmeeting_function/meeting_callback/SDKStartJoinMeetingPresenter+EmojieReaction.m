//
//  SDKStartJoinMeetingPresenter+EmojieReaction.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2020/12/3.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKStartJoinMeetingPresenter+EmojieReaction.h"


@implementation SDKStartJoinMeetingPresenter (EmojieReaction)

- (void)onEmojiReactionReceived:(NSUInteger)userId reactionType:(MobileRTCEmojiReactionType)type reactionSkinTone:(MobileRTCEmojiReactionSkinTone)skinTone;
{
    NSLog(@"EmojiReaction-->: onEmojiReactionReceived userID=%@ type=%@, SkinTone=%@",@(userId), @(type), @(skinTone));
}

- (void)onEmojiReactionReceivedInWebinar:(MobileRTCEmojiReactionType)type
{
    NSLog(@"EmojiReaction-->: onEmojiReactionReceivedInWebinar type=%@", @(type));
}

@end
