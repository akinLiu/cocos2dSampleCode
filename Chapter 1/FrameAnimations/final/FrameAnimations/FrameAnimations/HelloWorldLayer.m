//
//  HelloWorldLayer.m
//  FrameAnimations
//
//  Created by ldc on 9/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
		CGSize s = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"moles.plist"];
        
        CCSprite *mole = [CCSprite spriteWithSpriteFrameName:@"a0001.png"];
        mole.position = ccp(s.width/2,s.height/2);
		[self addChild:mole];
        mole.tag = 1;
        
        NSMutableArray *frames = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 10; i++) {
            NSString *frameName = [NSString stringWithFormat:@"a%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithFrames:frames delay:1.0f/24.0f];
        [mole runAction:[CCAnimate actionWithAnimation:a restoreOriginalFrame:NO]];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];
	}
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCSprite *mole = (CCSprite *)[self getChildByTag:1];
    if (CGRectContainsPoint([mole boundingBox], location)) {
        NSMutableArray *frames = [[NSMutableArray alloc] init];
        for (int i = 11; i <= 20; i++) {
            NSString *frameName = [NSString stringWithFormat:@"a%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithFrames:frames delay:1.0f/24.0f];
        [mole runAction:[CCAnimate actionWithAnimation:a restoreOriginalFrame:NO]];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
