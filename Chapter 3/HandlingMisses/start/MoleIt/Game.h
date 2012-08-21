//
//  Game.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "cocos2d.h"

@class AppDelegate,Mole;

@interface Game : CCScene <CCStandardTouchDelegate> {
    CCArray *moles, *carrots;
    float timeBetweenMoles,timeElapsed, increaseMolesAtTime, increaseElapsed, lastMoleHitTime,totalTime;
    CCLabelBMFont *scoreLabel;
    int carrotsLeft, score, molesAtOnce;
    CGSize s;
    AppDelegate *delegate;
    CCMenuItemSprite *pauseButton;
    NSString *nextMoleType, *missSound, *hitSound;
    bool canShowYellowMoles,canShowBlueMoles,isPaused;
}

-(void)showMole;
-(void)didScore;
-(void)missedMole;
-(int)getMolesUp;
-(void)pauseGame;
-(void)resumeGame;
-(NSArray *)getUpMoles;
-(NSArray *)getDownMoles;
-(void)startGame;
-(void)initializeGame;
-(void)chooseWhichMoleToMake;
-(void)mainMenu;
-(void)playAgain;
-(void)gameOver;

@end
