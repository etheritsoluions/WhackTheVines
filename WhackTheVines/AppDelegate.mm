//
//  AppDelegate.mm
//  WhackTheVines
//
//  Created by Ether IT Solutions on 04/04/13.
//  Copyright Ether IT Solutions 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

@implementation MyNavigationController
NSString *const FBSessionStateChangedNotification =
@"in.CurseWordz:FBSessionStateChangedNotification";
#pragma mark faceBook
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"state  closed=");
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"state  FBSessionStateClosedLoginFailed=");
            
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error on App"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    // attempt to extract a token from the url
//    return [FBSession.activeSession handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    
    BOOL retValue;
    if (FBSession.activeSession.isOpen)
    {
        
        //MAke you request
        retValue=TRUE;
        
    }
    else
    {
        //REopen your session
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email",
                                @"user_likes",
                                nil];
        retValue= [FBSession openActiveSessionWithReadPermissions:permissions
                                                     allowLoginUI:allowLoginUI
                                                completionHandler:^(FBSession *session,
                                                                    FBSessionState state,
                                                                    NSError *error) {
                                                    [self sessionStateChanged:session
                                                                        state:state
                                                                        error:error];
                                                }];
        
    }
    return retValue;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    if ([[FBSession activeSession] handleOpenURL:url])
    {
        
        return YES;
    }
    else
    {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        // Otherwise extract the app link data from the url and open a new active session from it.
        NSString *appID = @"576181712405433";//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
        FBAccessTokenData *appLinkToken = [FBAccessTokenData createTokenFromFacebookURL:url
                                                                                  appID:appID
                                                                        urlSchemeSuffix:nil];
        if (appLinkToken) {
            if ([FBSession activeSession].isOpen)
            {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }
            else
            {
                
                [self handleAppLink:appLinkToken];
                return YES;
            }
        }
    }
    return NO;
}
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken
{
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error)
                              {
                                 // [SharePage loginView:nil handleError:error];
                              }
                          }];
}

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [IntroLayer scene]];
	}
}
@end


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	


	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	//[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"firstTime"]integerValue]!=1)
    {
        //[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"music"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loadCount"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"NoRate"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RestartGame"];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RestartGame"];

    [FBSession setDefaultAppID:@"147839172062316"];

	return YES;
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else  // iPhone
        return UIInterfaceOrientationMaskAllButUpsideDown;
}
// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}
#pragma mark rate Options
-(void)pleaseRateIt
{
    UIAlertView *rate =[[UIAlertView alloc] initWithTitle:@"We need your help! Please take a moment to rate this app. It will help us continue to make great games for you. If you love this game, give it 5- stars! :)"
                                                  message:nil
                                                 delegate:self cancelButtonTitle:Nil
                                        otherButtonTitles:@"No Thanks",@"Yes",nil];
    
    [rate show];
    
    
}
#pragma mark alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( (buttonIndex == 1) &&([alertView.title isEqualToString:@" Like This App...?"]))
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Yes"];
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/curse-wordz/id383060549?ls=1&mt=8"];
        NSLog(@"directed to the url");
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NoRate"];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if( (buttonIndex == 0) &&([alertView.title isEqualToString:@" Like This App...?"]))
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NoRate"];
        NSLog(@" No  do  ");

    }
    
}
// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults]valueForKey:@"loadCount"]integerValue]+1 forKey:@"loadCount"];
    NSLog(@" handleDidBecomeActive =%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"loadCount"]integerValue]);
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"NoRate"]integerValue]==0&&[[[NSUserDefaults standardUserDefaults]valueForKey:@"loadCount"]integerValue]>=3)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loadCount"];
        [self pleaseRateIt];
    }
    
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}
@end

