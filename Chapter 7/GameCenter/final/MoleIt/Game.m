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
    
    missSound = [NSString stringWithFormat:@"%@_miss.wav", [delegate getCurrentSkin]];
    hitSound = [NSString stringWithFormat:@"%@_ouch.wav", [delegate getCurrentSkin]];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:missSound];
    [[SimpleAudioEngine sharedEngine] preloadEffect:hitSound];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"splat.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[NSString stringWithFormat:@"%@_bg.mp3", [delegate getCurrentSkin]]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", [delegate getCurrentSkin]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
    
    int fSize = 24;
    scoreLabel = [CCLabelBMFont labelWithString:@"score:0" fntFile:[NSString stringWithFormat:@"%i.fnt", fSize]];
    scoreLabel.anchorPoint = ccp(0,1);
    scoreLabel.position = ccp(0,s.height);
    [self addChild:scoreLabel z:10];
    
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
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"%@_bg.mp3", [delegate getCurrentSkin]] loop:YES];
    [self schedule:@selector(tick:)];
}

-(void)chooseWhichMoleToMake
{
    if ([self getMolesUp] >= molesAtOnce) {
        return;
    }
    nextMoleType = (CCRANDOM_0_1() < .15 && canShowBlueMoles) ? MOLE_TYPE_B : MOLE_TYPE_A;
    if ([self getMolesUp] < molesAtOnce - 1 && CCRANDOM_0_1() < .1 && canShowYellowMoles) {
        nextMoleType = MOLE_TYPE_C;
        [self showMole];
    }
    
    [self showMole];
}

-(void)tick: (ccTime)dt
{
    timeElapsed += dt;
    increaseElapsed += dt;
    if(timeElapsed >= timeBetweenMoles)
    {
        [self chooseWhichMoleToMake];
        timeElapsed = 0;
    }
    if (increaseElapsed >= increaseMolesAtTime) {
        int maxMolesAtOnce = 18;
        if (molesAtOnce < maxMolesAtOnce) {
            molesAtOnce++;
            float minMoleTime = .1f;
            timeBetweenMoles -= (timeBetweenMoles > minMoleTime) ? 0.05f : 0;
            increaseMolesAtTime += 10.0f;
        }
        if (canShowBlueMoles) {
            canShowYellowMoles = YES;
        }
        else
        {
            canShowBlueMoles = YES;
        }
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
    NSMutableArray *molesTappedAtOnce = [[NSMutableArray alloc] init];
    for (UITouch *touch in [event allTouches]) {
        for (Mole *mole in moles) {
            CGPoint location = [touch locationInView:touch.view];
            location = [[CCDirector sharedDirector] convertToGL:location];
            if (CGRectContainsPoint([mole boundingBox], location)) {
                if(![mole getIsUp] || [molesTappedAtOnce containsObject:mole])
                {
                    continue;
                }
                if([[mole getType] isEqualToString:MOLE_TYPE_C])
                {
                    [molesTappedAtOnce addObject:mole];
                }
                
                bool greenMoleWasWhacked = ([[mole getType] isEqualToString:MOLE_TYPE_A]);
                bool blueMoleWasWhacked = ([[mole getType] isEqualToString:MOLE_TYPE_B] && [touch tapCount] > 1);
                if(greenMoleWasWhacked || blueMoleWasWhacked)
                {
                    [mole wasTapped];
                    [self didScore];
                    [[SimpleAudioEngine sharedEngine] playEffect:hitSound pitch:1 pan:1 gain:.25];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
                }
                
            }
        }
    }
    
    if ([molesTappedAtOnce count] > 1) {
        for (Mole *m in molesTappedAtOnce) {
            [m wasTapped];
            [self didScore];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:hitSound pitch:1 pan:1 gain:.25];
        [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
    }
    [molesTappedAtOnce removeAllObjects];
}

-(void)didScore
{
    score++;
    [scoreLabel setString:[NSString stringWithFormat:@"score:%i",score]];
}


-(void)missedMole
{
    carrotsLeft--;
    [[SimpleAudioEngine sharedEngine] playEffect:missSound pitch:1 pan:1 gain:.2];
    if([carrots count] > 0)
    {
        [self removeChild:[carrots objectAtIndex:[carrots count] - 1] cleanup:YES];
        [carrots removeLastObject];
    }
    if(carrotsLeft <= 0)
    {
        [self gameOver];
    }
    else
    {
        for (Mole *m in [self getUpMoles]) {
            [m stopEarly];
        }
    }
}

-(void)gameOver
{
    for (Mole *m in moles) {
        [m stopAllActions];
        [m unscheduleAllSelectors];
    }
    [delegate finishedWithScore:score];
    [self unscheduleAllSelectors];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"play again"] selectedSprite:NULL target:self selector:@selector(playAgain)];
    CCMenuItemSprite *mainButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"main menu"] selectedSprite:NULL target:self selector:@selector(mainMenu)];
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:playAgainButton,mainButton, nil];
    [menu alignItemsHorizontallyWithPadding:10];
    PopUp *pop = [PopUp popUpWithTitle:@"-game over-" description:@"" sprite:menu];
    [self addChild:pop z:1000];
    
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
    if(isPaused)
    {
        return;
    }
    CCMenuItemSprite *resumeButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"resume"] selectedSprite:NULL target:self selector:@selector(resumeGame)];
    CCMenuItemSprite *mainButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"main menu"] selectedSprite:NULL target:self selector:@selector(mainMenu)];
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:resumeButton,mainButton, nil];
    [menu alignItemsHorizontallyWithPadding:10];
    PopUp *pop = [PopUp popUpWithTitle:@"-pause-" description:@"" sprite:menu];
    [self addChild:pop z:1000];
    pauseButton.visible = NO;
    for (Mole *m in [self getUpMoles]) {
        [m stopEarly];
    }
    [self unschedule:@selector(tick:)];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    isPaused = YES;
}
-(void)resumeGame
{
    pauseButton.visible = YES;
    [self schedule:@selector(tick:)];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    isPaused = NO;
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
    [[SimpleAudioEngine sharedEngine] unloadEffect:hitSound];
    [[SimpleAudioEngine sharedEngine] unloadEffect:missSound];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"splat.wav"];
    [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end