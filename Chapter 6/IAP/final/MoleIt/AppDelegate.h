//
//  AppDelegate.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright Wedgekase Games, LLC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@class RootViewController;


@interface AppDelegate : NSObject <UIAlertViewDelegate, UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    BOOL hasPlayedBefore,whacked3,whacked4;
    NSString *currentSkin;
    Store *store;
    int timesPlayed,currentAction,greenMolesWhacked,blueMolesWhacked,yellowMolesWhacked;
}

@property (nonatomic, retain) UIWindow *window;


-(void)finishedWithScore: (int)score;
-(int)getHighScore;
-(void)pause;
-(void)resume;
-(BOOL)isGameScene;
-(NSString *)getCurrentSkin;
-(void)setCurrentSkin:(NSString *)skin;
-(UIViewController *)getViewController;
-(void)buySkin;

@end
