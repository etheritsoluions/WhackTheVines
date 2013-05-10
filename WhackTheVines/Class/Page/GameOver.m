//
//  GameOver.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 26/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "GameOver.h"
#import "MainClass.h"
#import "SimpleAudioEngine.h"
CGSize ScreenSize;
#define FrameSetCountForGameOver 8
int animationCount=0;
@implementation GameOver

#pragma mark CallPauseView
-(void)homeAction:(id)sender
{
        [[CCDirector sharedDirector]resume];
        float deltaY=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?960.0:480.0;
        id action1= [CCCallFunc actionWithTarget:self.parent selector:@selector(cleanUpFunction)];
        id action3= [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
        id action2= [CCMoveTo actionWithDuration:1.0 position:CGPointMake(self.position.x, -deltaY)];
        [self runAction:[CCSequence actions:action1,action2,action3,nil]];//,action1
        
}
#pragma mark playSound
-(void)buttonSoundInPause
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button_switch.wav"];
    
}
#pragma mark support for FBConnection
- (void) performPublishAction:(void (^)(void)) action {
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
-(void)DisplayScorePage
{
    NSString *strForBgName=@"home.jpg";
    if (ScreenSize.width==568)
    {
        strForBgName=[NSString stringWithFormat:@"home%@.jpg",@"_iphone5"];
    }
    CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
    [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
    [self addChild:homeBg z:100];
    
    CGPoint playMenuPosition;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    else
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    

    
    CCMenuItemSprite *faceMenuItem;
    faceMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"homeButton.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"homeButton.png"]
                                                             target:self selector:@selector(homeAction:)];
    
    CCMenuItemSprite *twitterMenuItem;
    twitterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                 [CCSprite  spriteWithFile:@"facebook.png"]
                                                        selectedSprite:[CCSprite  spriteWithFile:@"facebook.png"]
                                                                target:self selector:@selector(faceAction:)];
    
    CCMenuItemSprite *gameCenterMenuItem;
    gameCenterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                    [CCSprite  spriteWithFile:@"twitter.png"]
                                                           selectedSprite:[CCSprite  spriteWithFile:@"twitter.png"]
                                                                   target:self selector:@selector(twitterAction:)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [faceMenuItem       setPosition:CGPointMake(-400, -330)];
        [twitterMenuItem    setPosition:CGPointMake(400, -328)];
        [gameCenterMenuItem setPosition:CGPointMake(0, -316)];
        
    }
    else
    {
        {
            [faceMenuItem       setPosition:CGPointMake(-200, -135)];
            [twitterMenuItem    setPosition:CGPointMake(200, -135)];
            [gameCenterMenuItem setPosition:CGPointMake(0, -135)];

            
            
        }
        
        
        
    }
    CCMenu *playMenu =[CCMenu menuWithItems:faceMenuItem,twitterMenuItem,gameCenterMenuItem, nil];
    [playMenu setPosition:playMenuPosition];
    [self addChild:playMenu z:999];
    
    int font=30;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        font=60;
    CCLabelTTF *scoreOnTop=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentScore"] integerValue]] fontName:@"Times New Roman" fontSize:font];
    [self addChild:scoreOnTop z:101];
    [scoreOnTop setPosition:CGPointMake(ScreenSize.width/2, ScreenSize.height/2)];
    [scoreOnTop setColor:ccc3(255, 174, 0)];
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"highScore"] integerValue]<[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentScore"] integerValue])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentScore"]integerValue]forKey:@"highScore"];

        CCSprite *homeBg     =   [CCSprite spriteWithFile:@"newhighscore.png"];
        [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
        [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/1.5)];
        [self addChild:homeBg z:100];
        [scoreOnTop setPosition:CGPointMake(ScreenSize.width/2, ScreenSize.height/3)];

    }


}
-(void)DisplayGameOverPage
{
    NSString *strForBgName=@"bg.jpg";
    if (ScreenSize.width==568)
    {
        strForBgName=[NSString stringWithFormat:@"%@",@"bg_iphone5.jpg"];
    }
    CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
    [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
    [self addChild:homeBg];
   
    
    
    CCSprite *breakAnim =[CCSprite spriteWithFile:@"break1.png"];
    [self addChild:breakAnim ];
    
    [breakAnim setTag:1199];
    
    CCAnimation *animation = [CCAnimation animation];
    for (int i=1; i<=8; i++)
        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"break%d.png",i]];
       
    animation.delayPerUnit = 0.1;
    [breakAnim runAction:[CCAnimate actionWithAnimation:animation]];
    [breakAnim setPosition:CGPointMake(ScreenSize.width/2, ScreenSize.height/4)];

    id actionDelay = [CCDelayTime actionWithDuration:1.0f];
    id actionCallScore  =   [CCCallFunc actionWithTarget:self selector:@selector(DisplayScorePage)];
    [self runAction:[CCSequence actions:actionDelay,actionCallScore, nil]];

    
}
-(void)removeSelf
{
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

-(id) init
{
	if( (self=[super init]))
    {
        [[CCDirector sharedDirector]resume];

        ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        [self DisplayGameOverPage];
        
        
    }
    return self;
}
@end
