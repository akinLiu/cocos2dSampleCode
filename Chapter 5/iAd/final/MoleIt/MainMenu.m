//
//  MainMenu.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "PopUp.h"
#import "GameButton.h"
#import "CCMenuPopup.h"

@implementation MainMenu

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate hideBanner];
        NSString *fileName =  [NSString stringWithFormat: @"%@.plist", [delegate getCurrentSkin]];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileName];
        int fSize = 24;
        CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i", [delegate getHighScore]] fontName:@"TOONISH.ttf" fontSize:fSize];
        highScore.anchorPoint = ccp(1,1);
        highScore.position = ccp(s.width,s.height);
        [self addChild:highScore];
        [CCMenuItemFont setFontName:@"TOONISH.ttf"];
        fSize = [CCMenuItemFont fontSize];
        [CCMenuItemFont setFontSize:48];
        
        CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"play!" isBig:YES] selectedSprite:NULL target:self selector:@selector(playGame)];
        
        [CCMenuItemFont setFontSize:fSize/1.5];
        CCMenuItemSprite *leaderboardsButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Game Center"] selectedSprite:NULL target:self selector:@selector(showLeaderboard)];
        CCMenuItemSprite *selectSkinButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Skins"] selectedSprite:NULL target:self selector:@selector(selectSkin)];
        CCMenuItemSprite *otherGamesButton = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"more games"] selectedSprite:NULL target:self selector:@selector(otherGames)];
        [CCMenuItemFont setFontSize:fSize];
        CCMenu *menu = [CCMenu menuWithItems: leaderboardsButton,otherGamesButton, selectSkinButton, nil];
        
        [menu alignItemsHorizontallyWithPadding:20];
        menu.position = ccp(s.width/2, 20);
        [self addChild:menu];
        
        CCMenu *mainPlay = [CCMenu menuWithItems:playButton, nil];
        mainPlay.position = ccp(s.width/2,s.height/2 - s.height/3.5f);
        [self addChild:mainPlay];
        
        fileName = @"title.png";
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        CCSprite *bg = [CCSprite spriteWithFile:fileName];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    }
    
    return self;
}

-(void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[Game node]];
}


-(void)selectSkin
{
    CCMenuItemSprite *jetIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"jetpack_icon.png"] selectedSprite:NULL target:self selector:@selector(jSkin)];
    CCMenuItemSprite *moleIcon = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"moles_icon.png"] selectedSprite:NULL target:self selector:@selector(mSkin)];
    
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:jetIcon,moleIcon, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    
    CCMenuItemSprite *btnCancel = [CCMenuItemSprite itemFromNormalSprite:[GameButton buttonWithText:@"Cancel"] selectedSprite:NULL];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCMenuPopup *cancelMenu = [CCMenuPopup menuWithItems:btnCancel, nil];
    btnCancel.position = ccp(0,- s.height/3);
    CCSprite *container = [CCSprite node];
    [container addChild:menu];
    [container addChild:cancelMenu];
    
    PopUp *pop = [PopUp popUpWithTitle:@"-SKINS!-" description:@"Select a skin to use or preview" sprite:container];
    [self addChild:pop z:1000];
}

-(void)otherGames
{
    
    NSString *search = @"wedgekase games";  
    NSString *sstring = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?WOURLEncoding=ISO8859_1&lang=1&output=lm&country=US&term=%@&media=software", [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:sstring]];  
}

-(void)jSkin
{
    [delegate setCurrentSkin:SKIN_JETPACK];
}

-(void)mSkin
{
    [delegate setCurrentSkin:SKIN_MOLE];
}

-(void)showLeaderboard
{
    
}

- (void)dealloc
{
    CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
