//
//  AdViewController.h
//  Mole It
//
//  Created by Todd Perkins on 4/21/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "cocos2d.h"

@class AppDelegate;

@interface AdViewController : UIViewController <ADBannerViewDelegate> {
    ADBannerView *adView;
    bool bannerIsVisible, adIsLoaded, bannerShouldShow;
    AppDelegate *delegate;
    UIView *currentView;
}

-(void)showBanner;
-(void)hideBanner;
-(bool)iAdIsAvailable;
-(float)getAdHeight;

@end
