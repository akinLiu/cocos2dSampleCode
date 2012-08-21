//
//  AppDelegate.m
//  Mole It
//
//  Created by Todd Perkins on 4/25/11.
//  Copyright Wedgekase Games, LLC 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "Game.h"
#import "RootViewController.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    timesPlayed = [[NSUserDefaults standardUserDefaults] integerForKey:kTimesPlayed];
    currentSkin = SKIN_MOLE;
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
    adView = [[AdViewController alloc] init];
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
#endif
	
	[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];
    
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	[viewController setView:adView.view];
	// make the OpenGLView a child of the view controller
	
    
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	//[director enableRetinaDisplay:YES]
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu node]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    if([self isGameScene])
    {
        [(Game *)[[CCDirector sharedDirector] runningScene] pauseGame];
    }
    else
    {
        [[CCDirector sharedDirector] pause];
    }
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (![self isGameScene]) {
        [[CCDirector sharedDirector] resume];
    }
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}



-(void)finishedWithScore: (int)score
{
    if(score > [self getHighScore])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kHighScoreKey];
    }
    timesPlayed++;
    [[NSUserDefaults standardUserDefaults] setInteger:timesPlayed forKey:kTimesPlayed];
    if (timesPlayed % 10 == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:kDidRate]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like Mole It?" message:@"If you like Mole It, please rate it to show your support." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate", nil];
        [alert show];
    }
}

-(int)getHighScore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey];
}
#pragma mark -------

-(void)pause
{
    if (![self isGameScene]) {
        [[CCDirector sharedDirector] pause];
    }
}
-(void)resume
{
    if (![self isGameScene]) {
        [[CCDirector sharedDirector] resume];
    }
}


-(BOOL)isGameScene
{
    return [[[CCDirector sharedDirector] runningScene] isKindOfClass:[Game class]];
}


-(NSString *)getCurrentSkin
{
    return currentSkin;
}
-(void)setCurrentSkin:(NSString *)skin
{
    currentSkin = skin;
}

-(UIViewController *)getViewController
{
    return viewController;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return;
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/app/mole-it!-free/id464362476?ls=1&mt=8"]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidRate];
    
}

-(float)getAdHeight
{
    return [adView getAdHeight];
}
-(void)hideBanner
{
    [adView hideBanner];
}
-(void)showBanner
{
    [adView showBanner];
}

- (void)dealloc {
    [[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
