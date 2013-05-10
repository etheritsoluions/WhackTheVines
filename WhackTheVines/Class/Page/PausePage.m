//
//  PausePage.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 18/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "PausePage.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation PausePage
@synthesize gameCenterManager;

CCSprite *soundOff ,*musicOff;

CGSize ScreenSize;

-(void)removeSelf
{

    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}
#pragma mark playSound
-(void)buttonSoundInPause
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button_switch.wav"];
    
}
#pragma mark Button Aciton
-(void)ResumeAction:(id)sender
{
    [self buttonSoundInPause];
    [[CCDirector sharedDirector]resume];
    float deltaY=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?960.0:480.0;
    id action1= [CCCallFunc actionWithTarget:self.parent selector:@selector(removePausePage)];
    id action3= [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
    id action2= [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, -deltaY)];
    [self runAction:[CCSequence actions:action1,action2,action3,nil]];
}
-(void)RestartAction:(id)sender
{
    [self buttonSoundInPause];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"RestartGame"];
    [[CCDirector sharedDirector]resume];
    float deltaY=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?960.0:480.0;
    id action1= [CCCallFunc actionWithTarget:self.parent selector:@selector(cleanUpFunction)];
    id action3= [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
    id action2= [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, -deltaY)];

    [self runAction:[CCSequence actions:action1,action2,action3,nil]];
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error)
    {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
        {
            alertMsg = error.fberrorUserMessage;
        }
        else
        {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    }
    else
    {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma mark support for FBConnection
- (void) performPublishAction:(void (^)(void)) action
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                
                                            }];
    } else {
        action();
    }
    
}
#pragma mark Leader Board Aciton

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
-(void)faceAction:(id)sender
{

    [self buttonSoundInPause];

    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:[CCDirector sharedDirector]
                                                                    initialText:[NSString stringWithFormat:@"%@ %@%@",@"My High Score",[[NSUserDefaults standardUserDefaults] valueForKey:@"highScore"],@"!  \n\nSent from Whack the Vines"]
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog)
    {
        [self performPublishAction:^{
            
            [FBRequestConnection startForUploadPhoto:nil
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 [self showAlert:@"Photo Post" result:result error:error];
             }];
            
        }];
    }
}
-(void)twitterAction:(id)sender
{
    [self buttonSoundInPause];

    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet addImage:[UIImage imageNamed:@"Icon.png"]];

        
        [tweetSheet setInitialText: [NSString stringWithFormat:@"I just scored %@ playing the addictive game Whack the Vines! This is my new high score!!!",[[NSUserDefaults standardUserDefaults]valueForKey:@"highScore"]]];
        [[CCDirector sharedDirector] presentViewController:tweetSheet animated:YES completion:nil];
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult res)
        {
            
            if(res == TWTweetComposeViewControllerResultDone)
            {
                [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
            }
            if(res == TWTweetComposeViewControllerResultCancelled)
            {
                [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
            }
        };
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                            message:@"Sorry,we were unable to find your Twitter account.Please enter your credential in settings:Twitter and try again.Thanks!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

    
}
-(void)LeaderAction:(id)sender
{
    [self buttonSoundInPause];
    [self.gameCenterManager authenticateLocalUser];

    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = @"01052013";
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [[CCDirector sharedDirector] presentModalViewController: leaderboardController animated: YES];
    }
}
-(void)musicAction:(id)sender
{
    [self buttonSoundInPause];

    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==0)
    {
        [musicOff setVisible:FALSE];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"music"];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume=1;
        
    }
    else
    {
        [musicOff setVisible:TRUE];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"music"];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume=0;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"sf musf %d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]);
    
}
-(void)soundAction:(id)sender
{
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==0)
    {
        [soundOff setVisible:FALSE];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"sound"];
        [SimpleAudioEngine sharedEngine].mute=FALSE;
        
    }
    else
    {
        [soundOff setVisible:TRUE];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"sound"];
        [SimpleAudioEngine sharedEngine].mute=TRUE;
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self buttonSoundInPause];

    NSLog(@"sf sf %d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]);
}
-(void)helpAction:(id)sender
{
    [self buttonSoundInPause];

}
-(void)aboutAction:(id)sender
{
    [self buttonSoundInPause];

}
#pragma mark CallPauseView
-(void)DisplayPausePage
{
    NSString *strForBgName=@"home.jpg";
    if (ScreenSize.width==568)
    {
        strForBgName=[NSString stringWithFormat:@"home%@.jpg",@"_iphone5"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"highScore"] integerValue]<[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentScore"] integerValue])
    {
        GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:@"01052013"] autorelease];
        scoreReporter.value = 111;
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                // handle the reporting error
            }
        }];
        
    }
    

    

    CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
    [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
    [self addChild:homeBg z:1999];
    
    CGPoint playMenuPosition;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    else
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    
    CCMenuItemSprite *playMenuItem;
    playMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"play.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"play.png"]
                                                             target:self selector:@selector(RestartAction:)];
    
    
    CCMenuItemSprite *resumeMenuItem;
    resumeMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"resume.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"resume.png"]
                                                             target:self selector:@selector(ResumeAction:)];
    
    CCMenuItemSprite *faceMenuItem;
    faceMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"facebook.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"facebook.png"]
                                                             target:self selector:@selector(faceAction:)];
    
    CCMenuItemSprite *twitterMenuItem;
    twitterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                 [CCSprite  spriteWithFile:@"twitter.png"]
                                                        selectedSprite:[CCSprite  spriteWithFile:@"twitter.png"]
                                                                target:self selector:@selector(twitterAction:)];
    
    CCMenuItemSprite *gameCenterMenuItem;
    gameCenterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                    [CCSprite  spriteWithFile:@"leaderboard.png"]
                                                           selectedSprite:[CCSprite  spriteWithFile:@"leaderboard.png"]
                                                                   target:self selector:@selector(LeaderAction:)];
    
    CCMenuItemSprite *soundMenuItem;
    soundMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                               [CCSprite  spriteWithFile:@"sound.png"]
                                                      selectedSprite:[CCSprite  spriteWithFile:@"sound.png"]
                                                              target:self selector:@selector(soundAction:)];
    
    CCMenuItemSprite *musicMenuItem;
    musicMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                               [CCSprite  spriteWithFile:@"musicon.png"]
                                                      selectedSprite:[CCSprite  spriteWithFile:@"musicon.png"]
                                                              target:self selector:@selector(musicAction:)];
    
    
    CCMenuItemSprite *aboutMenuItem;
    aboutMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                               [CCSprite  spriteWithFile:@"credit.png"]
                                                      selectedSprite:[CCSprite  spriteWithFile:@"credit.png"]
                                                              target:self selector:@selector(aboutAction:)];
    
    CCMenuItemSprite *helpMenuItem;
    helpMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"help.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"help.png"]
                                                             target:self selector:@selector(helpAction:)];
    
    
    
    soundOff=[CCSprite spriteWithFile:@"musioff.png"];
    musicOff=[CCSprite spriteWithFile:@"musioff.png"];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==0)
    {
        [musicOff setVisible:FALSE];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume=1;
        
        
    }
    else
    {
        
        [musicOff setVisible:TRUE];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume=0;
    }
    
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==0)
        [soundOff setVisible:TRUE];
    else
        [soundOff setVisible:FALSE];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [playMenuItem       setPosition:CGPointMake(0, 200)];
        [resumeMenuItem     setPosition:CGPointMake(0, -30)];
        
        
        [faceMenuItem       setPosition:CGPointMake(-400, -338)];
        [twitterMenuItem    setPosition:CGPointMake(400, -338)];
        [gameCenterMenuItem setPosition:CGPointMake(0, -338)];
        [musicMenuItem      setPosition:CGPointMake(100, -170)];
        [soundMenuItem      setPosition:CGPointMake(-100, -180)];
        [aboutMenuItem      setPosition:CGPointMake(250, 280)];
        [helpMenuItem       setPosition:CGPointMake(420, 280)];
        [soundOff           setPosition:CGPointMake((ScreenSize.width/2.0)-100, (ScreenSize.height/2.0-180))];
        [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)+100, (ScreenSize.height/2.0-170))];
    }
    else
    {
        {
            [playMenuItem       setPosition:CGPointMake(0, 110)];
            [resumeMenuItem     setPosition:CGPointMake(10, 0)];

            [faceMenuItem       setPosition:CGPointMake(-200, -135)];
            [twitterMenuItem    setPosition:CGPointMake(200, -135)];
            [gameCenterMenuItem setPosition:CGPointMake(0, -135)];
            [musicMenuItem      setPosition:CGPointMake(50, -60)];
            [soundMenuItem      setPosition:CGPointMake(-50, -60)];
            [aboutMenuItem      setPosition:CGPointMake(130, 120)];
            [helpMenuItem       setPosition:CGPointMake(205, 120)];
            [soundOff           setPosition:CGPointMake((ScreenSize.width/2.0)-50, (ScreenSize.height/2.0-60))];
            [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)+50, (ScreenSize.height/2.0-60))];

        }
    }
    CCMenu *playMenu =[CCMenu menuWithItems:playMenuItem,resumeMenuItem,faceMenuItem,twitterMenuItem,gameCenterMenuItem,musicMenuItem,soundMenuItem,aboutMenuItem,helpMenuItem, nil];
    [playMenu setPosition:playMenuPosition];
    [self addChild:playMenu z:1999];
    [self addChild:soundOff z:1999];
    [self addChild:musicOff z:1999];
}

-(id) init
{
	if( (self=[super init]))
    {
        ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        [self DisplayPausePage];
        
    }
    return self;
}
@end
