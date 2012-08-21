//
//  Mole.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "cocos2d.h"

@class AppDelegate;

@interface Mole : CCSprite {
    bool isUp, didMiss;
    float instanceUpTime,upTime;
    NSString *type;
    AppDelegate *delegate;
}


-(void)wasTapped;
-(BOOL)getIsUp;
-(CCAnimation *)getAnimationWithFrames: (int)from to:(int)to;
-(CCAnimation *)reverseAnimationWithFrames: (int)from to:(int)to;
-(void)startWithType: (NSString *)t;
-(void)stop;
-(void)stopEarly;
-(void)reset;
-(NSString *)getType;

@end
