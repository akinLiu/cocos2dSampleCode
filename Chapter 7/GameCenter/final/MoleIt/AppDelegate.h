//
//  AppDelegate.h
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright Wedgekase Games, LLC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKWizard.h"
@class RootViewController;


@interface AppDelegate : NSObject <UIAlertViewDelegate, UIApplicationDelegate,GKLeaderboardViewControllerDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    BOOL hasPlayedBefore,whacked3,whacked4;
    NSString *currentSkin;
    GKWizard *wiz;
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
-(void)showLeaderboard;

@end
