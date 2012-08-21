//
//  Game.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "Game.h"
#import "Mole.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "GameButton.h"
#import "CCMenuPopup.h"

@implementation Game

- (id)init
{
    self = [super init];
    if (self) {
        carrotsLeft = 3;
        molesAtOnce = 3;
        timeBetweenMoles = 0.5f;
        increaseMolesAtTime = 10.0f;
    }
    
    return self;
}

-(void)initializeGame
{
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[CCDirector sharedDirector] resume];
    s = [[CCDirector sharedDirector] winSize];
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [delegate getCurrentSkin]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
    
    carrots = [[CCArray alloc] init];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_bg.png", [delegate getCurrentSkin]]];
    bg.anchorPoint = ccp(0,0);
    [self addChild:bg z:-1];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    for (int i = 0; i < carrotsLeft; i++) {
        CCSprite *c = [CCSprite spriteWithSpriteFrameName:@"life.png"];
        c.anchorPoint = ccp(1,1);
        c.position = ccp(s.width - i * c.contentSize.width, s.height);
        [carrots addObject:c];
        [self addChild:c z:10];
    }
    
    pauseButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause_button.png"] selectedSprite:NULL target:self selector:@selector(pauseGame)];
    CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
    pauseButton.position = ccp(s.width/2 - pauseButton.contentSize.width/2, (-s.height/2) + pauseButton.contentSize.height/2);
    [self addChild:menu z:100];
    
    [self startGame];
}

-(void)startGame
{
    [self schedule:@selector(tick:)];
}

-(void)chooseWhichMoleToMake
{
    
}

-(void)tick: (ccTime)dt
{
    timeElapsed += dt;
    if(timeElapsed >= timeBetweenMoles)
    {
        [self chooseWhichMoleToMake];
        timeElapsed = 0;
    }
}

-(void)showMole
{
    
}

-(NSArray *)getDownMoles
{
    NSMutableArray *downMoles = [[NSMutableArray alloc] init];
    for (Mole *m in moles) {
        if (![m getIsUp]) {
            [downMoles addObject:m];
        }
    }
    return downMoles;
}
-(NSArray *)getUpMoles
{
    NSMutableArray *upMoles = [[NSMutableArray alloc] init];
    for (Mole *m in moles) {
        if ([m getIsUp]) {
            [upMoles addObject:m];
        }
    }
    return upMoles;
}



-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)didScore
{
    
}


-(void)missedMole
{
    
}

-(void)gameOver
{
    
}

-(int)getMolesUp
{
    int upMoles = 0;
    for (Mole *m in moles) {
        if ([m getIsUp]) {
            upMoles++;
        }
    }
    return upMoles;
}

-(void)pauseGame
{
    
}
-(void)resumeGame
{
    
}

-(void)mainMenu
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

-(void)playAgain
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[[self class] node]];
}

-(void)onEnterTransitionDidFinish
{
    [self initializeGame];
}

-(void)onExit
{
    [carrots release];
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end