//
//  AdViewController.m
//  Mole It
//
//  Created by Todd Perkins on 4/21/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "AdViewController.h"
#import "AppDelegate.h"
#import "Game.h"
#import "MainMenu.h"
#import "Constants.h"

@implementation AdViewController

- (id)init
{
    self = [super init];
    if (self) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    EAGLView *eaglView = [[CCDirector sharedDirector] openGLView];
    [self.view addSubview:eaglView];
    CGSize s = [[CCDirector sharedDirector] winSize];
    bool isIPAD = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;

    
    if ([self iAdIsAvailable]) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        // position the guy off the screen
        if (isIPAD) {
            adView.frame = CGRectMake(0, 768, adView.frame.size.width, adView.frame.size.height);
        }
        else
        {
        adView.frame = CGRectMake(0, 320, adView.frame.size.width, adView.frame.size.height);
        }
        adView.delegate = self;
        [self.view addSubview:adView];
        currentView = adView;
    }
    
}

// iAd Stuff
#pragma mark iAd Stuff

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = YES;
    
    if (!willLeave && shouldExecuteAction)
    {
        [delegate pause];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [delegate resume];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    adIsLoaded = YES;
    if ([delegate isGameScene]) {
    [self showBanner];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    adIsLoaded = NO;
    [self hideBanner];
}

#pragma mark animations

-(void)showBanner
{
    bannerShouldShow = YES;
    if (bannerIsVisible || !adIsLoaded) {
        return;
    }
    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    currentView.frame = CGRectOffset(currentView.frame, 0, -currentView.frame.size.height);
    [UIView commitAnimations];
    bannerIsVisible = YES;
}

-(void)hideBanner
{
    bannerShouldShow = NO;
    if (!bannerIsVisible) {
        return;
    }
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    currentView.frame = CGRectOffset(currentView.frame, 0, currentView.frame.size.height);
    [UIView commitAnimations];
    bannerIsVisible = NO;
}

-(float)getAdHeight
{
    return currentView.frame.size.height;
}

-(bool)iAdIsAvailable
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"ADBannerView"));
	
    // The device must be running running iOS 4.1 or later.
    bool isIPAD = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    NSString *reqSysVer = (isIPAD) ? @"4.2" : @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

- (void)dealloc
{
    [super dealloc];
}

@end
