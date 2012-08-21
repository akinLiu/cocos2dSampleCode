//
//  Mole.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "Mole.h"
#import "Game.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation Mole

- (id)init
{
    self = [super init];
    if (self) {
        upTime = 2.0f;
        type = MOLE_TYPE_A;
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)startWithType: (NSString *)t
{
    [self stopAllActions];
    isUp = YES;
    
    if ([type isEqualToString:MOLE_TYPE_B]) {
        instanceUpTime = upTime * 1.25f;
    }
    else if ([type isEqualToString:MOLE_TYPE_A]) {
        instanceUpTime = upTime;
    }
    else if ([type isEqualToString:MOLE_TYPE_C]) {
        instanceUpTime = upTime * 1.5f;
    }
    
    didMiss = YES;
    type = t;
    self.scaleX = (CCRANDOM_0_1() >= .5) ? 1 : -1;
    
    [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:1 to:10] restoreOriginalFrame:NO]];
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:instanceUpTime],
                     [CCCallFunc actionWithTarget:self selector:@selector(stop)],
                     nil]];
}

-(void)reset
{
    isUp = NO;
    
    if (didMiss) {
        [(Game *)self.parent missedMole];
    }
    
}

-(void)stopEarly
{
    didMiss = NO;
    [self stopAllActions];
    [self stop];
}

-(void)stop
{
    
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:[self reverseAnimationWithFrames:10 to:1] restoreOriginalFrame:NO],
                     [CCCallFunc actionWithTarget:self selector:@selector(reset)],
                     nil]];
}

-(BOOL)getIsUp
{
    return isUp;
}

-(void)wasTapped
{
    if (isUp) {
        [self stopAllActions];
        [self runAction:[CCAnimate actionWithAnimation:[self getAnimationWithFrames:21 to:31] restoreOriginalFrame:NO]];
        isUp = NO;
    }
}

-(CCAnimation *)getAnimationWithFrames: (int)from to:(int)to
{
    NSMutableArray *anim = [[NSMutableArray alloc] init];
    for (int i = from; i <= to; i++) {
        NSString *frame = [NSString stringWithFormat:@"%@%04i.png",type, i];
        [anim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frame]];
    }
    CCAnimation *a = [CCAnimation animationWithFrames:anim delay:1.0f/24.0f];
    return a;
}

-(CCAnimation *)reverseAnimationWithFrames: (int)from to:(int)to
{
    NSMutableArray *anim = [[NSMutableArray alloc] init];
    for (int i = from; i >= to; i--) {
        NSString *frame = [NSString stringWithFormat:@"%@%04i.png",type, i];
        [anim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frame]];
    }
    CCAnimation *a = [CCAnimation animationWithFrames:anim delay:1.0f/24.0f];
    return a;
}

-(NSString *)getType
{
    return type;
}

- (void)dealloc
{
    [super dealloc];
}

@end