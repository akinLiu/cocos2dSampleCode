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
    moles = [[CCArray alloc] init];
    
    float hPad = 20;
    float vPad = 25;
    
    for (int i = 1; i <= 4; i++) {
        for (int j = 1; j <= 6; j++) {
            Mole *mole = [Mole spriteWithSpriteFrameName:@"a0001.png"];
            mole.position = ccp(j * mole.contentSize.width + hPad, i * mole.contentSize.height + vPad);
            [moles addObject:mole];
            [self addChild:mole z:1];
        }
    }
    
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
    nextMoleType = MOLE_TYPE_A;
    [self showMole];
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
    Mole *mole = [[CCArray arrayWithNSArray:[self getDownMoles]] randomObject];
    [mole startWithType:nextMoleType];
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
    if (isPaused) {
        return;
    }
    for (UITouch *touch in [event allTouches]) {
        for (Mole *mole in moles) {
            CGPoint location = [touch locationInView:touch.view];
            location = [[CCDirector sharedDirector] convertToGL:location];
            if (CGRectContainsPoint([mole boundingBox], location)) {
                if(![mole getIsUp])
                {
                    continue;
                }
                [mole wasTapped];
            }
        }
    }
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
    [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    [[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
    [self initializeGame];
}

-(void)onExit
{
    [carrots release];
    [moles release];
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end