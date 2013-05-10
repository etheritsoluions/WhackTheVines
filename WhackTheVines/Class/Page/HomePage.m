//
//  HomePage.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 18/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "TesterConfigurable.h"

CCSprite *soundOff ,*musicOff;
#define tagForWineInHome 501
#define tagForHandInHome 502
#define tagForHlepBg     503
#define tagForInfo       504
#define tagForMenu       505

@implementation HomePage
@synthesize gameCenterManager;

CGSize ScreenSize ;

-(void)removeSelf
{
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}
#pragma mark playSound
-(void)buttonSound
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button_switch.wav"];

}
#pragma mark Button Actiions
-(void)faceAction:(id)sender
{
    [self buttonSound];
    NSURL * url = [NSURL URLWithString:@"https://www.facebook.com/WeirdCandle?fref=ts"];
    [[UIApplication sharedApplication] openURL: url];
}
-(void)twitterAction:(id)sender
{
    [self buttonSound];
    NSURL * url = [NSURL URLWithString:@"https://twitter.com"];
    [[UIApplication sharedApplication] openURL: url];
}
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
-(void)LeaderAction:(id)sender
{
    [self buttonSound];
    if ([GameCenterManager isGameCenterAvailable]) {
		
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
		
		
	}
    else
    {
            
	}
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
    [self buttonSound];
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
    [self buttonSound];

}
-(void)helpAction:(id)sender
{
    [self buttonSound];
    [self showHelp];


}
-(void)removeTestConfig
{
    CCMenu *playMenu =(CCMenu*)[self getChildByTag:tagForMenu];
    [playMenu setVisible:TRUE];
}
-(void)testconfig
{
    CCMenu *playMenu =(CCMenu*)[self getChildByTag:tagForMenu];
    [playMenu setVisible:FALSE];
    
    TesterConfigurable *testConfig=[TesterConfigurable node];
    [self addChild:testConfig z:2000];
    
}
-(void)aboutAction:(id)sender
{
    [self buttonSound];
    [self testconfig];
    

}
-(void)playAction:(id)sender
{
    [self buttonSound];

    float deltaY=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?960.0:480.0;
    id action1= [CCCallFunc actionWithTarget:self.parent selector:@selector(loadGameNode)];
    id action2= [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, deltaY)];
    id action3= [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
    [self runAction:[CCSequence actions:action1,action2,action3,nil]];
}
-(void)DisplayHomePage
{

    
    CGPoint playMenuPosition;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    else
        playMenuPosition    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    
    CCMenuItemSprite *playMenuItem;
    playMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"play.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"play.png"]
                                                             target:self selector:@selector(playAction:)];
    
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
        [musicOff setVisible:TRUE];
    }
    else
    {
        [musicOff setVisible:FALSE];
    }
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==1)
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
    {
        [soundOff setVisible:TRUE];
        [SimpleAudioEngine sharedEngine].mute=TRUE;

    }
    else
    {
        [soundOff setVisible:FALSE];
        [SimpleAudioEngine sharedEngine].mute=FALSE;

    }


    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [playMenuItem       setPosition:CGPointMake(0, 100)];
        [faceMenuItem       setPosition:CGPointMake(-400, -330)];
        [twitterMenuItem    setPosition:CGPointMake(400, -328)];
        [gameCenterMenuItem setPosition:CGPointMake(0, -316)];
        [musicMenuItem      setPosition:CGPointMake(100, -170)];
        [soundMenuItem      setPosition:CGPointMake(-100, -180)];
        [aboutMenuItem      setPosition:CGPointMake(250, 280)];
        [helpMenuItem       setPosition:CGPointMake(420, 280)];
        
        [soundOff           setPosition:CGPointMake((ScreenSize.width/2.0)-100, (ScreenSize.height/2.0-180))];
        [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)+100, (ScreenSize.height/2.0-170))];
    }
    else
    {
        
            [playMenuItem       setPosition:CGPointMake(0, 80)];
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
    CCMenu *playMenu =[CCMenu menuWithItems:playMenuItem,faceMenuItem,twitterMenuItem,gameCenterMenuItem,musicMenuItem,soundMenuItem,aboutMenuItem,helpMenuItem, nil];
    [playMenu setPosition:playMenuPosition];
    [self addChild:playMenu z:999];
    [self addChild:soundOff z:999];
    [self addChild:musicOff z:999];
    [playMenu setTag:tagForMenu];

}
-(void)cropWineImage:(NSString*)image WithSize:(CGRect)rectInSize atPosition:(CGPoint)oldSpritePosiiton  sizeOfOld:(CGSize)sizeOld firstOrSec:(float)minOrPlus
{
    
    int multBy=1;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==2048 )
            multBy=2;
        
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==960 ||[[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1136  )
            multBy=2;
        
    }
    
    UIImage *orginalImg=[UIImage imageNamed:image];
    CGRect newRect=CGRectMake(rectInSize.origin.x, rectInSize.origin.y, rectInSize.size.width*multBy, rectInSize.size.height*multBy);
    CGImageRef imageRef = CGImageCreateWithImageInRect([orginalImg CGImage], newRect);
    CCTexture2D *tex=[[CCTexture2D alloc] initWithCGImage:imageRef resolutionType:kCCResolutionUnknown];
    CCSprite *sprite = [CCSprite spriteWithTexture:tex];
    [self addChild:sprite z:1200];
    float yVaule=oldSpritePosiiton.y+sprite.boundingBox.size.height/2;
    
    if (yVaule<0)
        yVaule*=-1;
    [sprite setPosition:CGPointMake(oldSpritePosiiton.x+200, oldSpritePosiiton.y+(sizeOld.height- sprite.boundingBox.size.height))];
    CGImageRelease(imageRef);
    int lenght=50;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        lenght=200;
    [sprite runAction:[CCJumpTo actionWithDuration:2 position:CGPointMake(oldSpritePosiiton.x+200, -ScreenSize.height/2) height:lenght jumps:1]];
    
    [sprite setPosition:CGPointMake(oldSpritePosiiton.x+200, oldSpritePosiiton.y+(sizeOld.height- sprite.boundingBox.size.height)-50)];
    [sprite setPosition:CGPointMake(oldSpritePosiiton.x, yVaule+20)];
    
}
-(void)cropImageWieSec:(NSString*)image WithSize:(CGRect)rectInSize atPosition:(CGPoint)oldSpritePosiiton  sizeOfOld:(CGSize)sizeOld firstOrSec:(float)minOrPlus
{
    
    int multBy=1;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==2048 )
            multBy=2;
        
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==960 ||[[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1136  )
            multBy=2;
        
    }
    
    UIImage *orginalImg=[UIImage imageNamed:image];
    CGRect visibleRect1= CGRectMake(rectInSize.origin.x*multBy, rectInSize.size.height*multBy,  multBy*rectInSize.size.width, multBy*( sizeOld.height-rectInSize.size.height));
    CGImageRef secondPart=CGImageCreateWithImageInRect([orginalImg CGImage],visibleRect1 );
    CCTexture2D *texSce=[[CCTexture2D alloc] initWithCGImage:secondPart resolutionType:kCCResolutionUnknown];
    CCSprite *spritetexSce = [CCSprite spriteWithTexture:texSce];
    [self addChild:spritetexSce z:1200];
    float yVaule=minOrPlus-spritetexSce.boundingBox.size.height/2;//((sizeOld.height/2)+
    
    
    [spritetexSce setPosition:CGPointMake(oldSpritePosiiton.x,yVaule)];
    //NSLog(@"sprite sec width= %f %f ",yVaule,rectInSize.size.width);
    CGImageRelease(secondPart);
    int lenght=50;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        lenght=100;
    [spritetexSce  setColor:ccc3(0, 0, 0)];
    [spritetexSce runAction:[CCFadeOut actionWithDuration:1.50]];
    [spritetexSce setPosition:CGPointMake(oldSpritePosiiton.x,yVaule)];
    
}

-(void)showHelp
{
    NSString *strForWine;

    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1024 )
    {
        strForWine=@"wine-ipad.png";
    }
    else   if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==2048 )
    {
        strForWine=@"wine-ipadhd.png";
        
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==480 )
    {
        strForWine=@"wine.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==960 )
    {
        strForWine=@"wine-hd.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1136 )
    {
        strForWine=@"wine-hd.png";
    }
    CCSprite *spriteHand=(CCSprite*)[self getChildByTag:tagForHandInHome];
    id action1= [CCMoveTo actionWithDuration:1 position:CGPointMake(spriteHand.position.x-spriteHand.boundingBox.size.width, spriteHand.position.y)];
    id action2= [CCMoveTo actionWithDuration:1 position:CGPointMake(spriteHand.position.x+(spriteHand.boundingBox.size.width), spriteHand.position.y)];
    [spriteHand runAction:[CCRepeatForever actionWithAction: [CCSequence actions:action1,action2, nil]]];
    CCSprite *wineForSprite=(CCSprite*)[self getChildByTag:tagForWineInHome];
    [wineForSprite stopAllActions];
    
    CCSprite *helpBg=(CCSprite*)[self getChildByTag:tagForHlepBg];
    [helpBg          setVisible:TRUE];

    [helpBg stopAllActions];
    [wineForSprite   setVisible:TRUE];
    [spriteHand      setVisible:TRUE];
    float locationY=spriteHand.position.y+(spriteHand.boundingBox.size.height/2);
    float YYY=wineForSprite.boundingBox.size.width;
    YYY =(wineForSprite.boundingBox.size.height/2)-(locationY - wineForSprite.position.y);
    [wineForSprite setVisible:FALSE];
    CGRect visibleRect= CGRectMake(0 , 0,   wineForSprite.boundingBox.size.width,YYY );
    [self cropWineImage:strForWine WithSize:visibleRect atPosition:wineForSprite.position sizeOfOld:wineForSprite.boundingBox.size firstOrSec:locationY];
    [self cropImageWieSec:strForWine WithSize:visibleRect atPosition:wineForSprite.position sizeOfOld:wineForSprite.boundingBox.size firstOrSec:locationY];
   
    id action4  = [CCDelayTime actionWithDuration:2];
    id action5  = [CCCallFunc actionWithTarget:self selector:@selector(removeHelpAndCallHome)];
    [self runAction:[CCSequence actions:action4,action5, nil]];
}
-(void)removeHelpAndCallHome
{
    CCSprite *hand=(CCSprite*)[self getChildByTag:tagForHandInHome];
    [hand setPosition:CGPointMake(ScreenSize.width/2, hand.boundingBox.size.height/2)];
 
    [hand stopAllActions];
    CCLabelTTF *aboutMessage= (CCLabelTTF*)[self getChildByTag:tagForInfo];
    CCSprite *helpBg=(CCSprite*)[self getChildByTag:tagForHlepBg];
    CCSprite *wine=(CCSprite*)[self getChildByTag:tagForWineInHome];
    [wine stopAllActions];
    
    [helpBg       stopAllActions];
    [wine         setVisible:FALSE];
    [hand         setVisible:FALSE];
    [helpBg       setVisible:FALSE];
    [aboutMessage setVisible:FALSE];

//    [self DisplayHomePage];

}
-(void)callHelpFirstTimeOnly
{
    NSString *strForBgName=@"bg.jpg";
    if (ScreenSize.width==568)
    {
        strForBgName=[NSString stringWithFormat:@"%@",@"bg_iphone5.jpg"];
    }
    CCSprite *helpBg     =   [CCSprite spriteWithFile:strForBgName];
    [helpBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [helpBg setTag:tagForHlepBg];
    [helpBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
    [self addChild:helpBg z:1000];
    
    
    CCSprite *wine=[CCSprite spriteWithFile:@"wine.png"];
    [self addChild:wine z:1000];
    [wine setTag:tagForWineInHome];
    [wine  setPosition:CGPointMake(ScreenSize.width/2, -ScreenSize.height/2)];
    
    
    CCSprite *spriteHand=[CCSprite spriteWithFile:@"hand.png"];
    [self addChild:spriteHand z:1000];

    [spriteHand setPosition:CGPointMake(ScreenSize.width/2, spriteHand.boundingBox.size.height/2)];
    [ wine setPosition:CGPointMake(spriteHand.position.x, spriteHand.position.y)];
    [spriteHand setTag:tagForHandInHome];
    id action1= [CCMoveTo actionWithDuration:1 position:CGPointMake(spriteHand.position.x-spriteHand.boundingBox.size.width, spriteHand.position.y)];
    id action2= [CCMoveTo actionWithDuration:1 position:CGPointMake(spriteHand.position.x+(spriteHand.boundingBox.size.width), spriteHand.position.y)];
    [spriteHand runAction:[CCRepeatForever actionWithAction: [CCSequence actions:action1,action2, nil]]];
    
    
    int font=30;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        font=60;
    CCLabelTTF *aboutMessage=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",@"Whack the Vines \ncopyright: Weird Candle, LLC  \ncredits :Weird Candle, LLC"] fontName:@"Times New Roman" fontSize:font];
    [self addChild:aboutMessage z:1011];
    [aboutMessage setTag:tagForInfo];
    [aboutMessage setPosition:CGPointMake(ScreenSize.width/2, ScreenSize.height/2)];
    [aboutMessage setColor:ccc3(255, 174, 0)];
    [aboutMessage setVisible:FALSE];

    id action4  = [CCDelayTime actionWithDuration:2];
    id action5  = [CCCallFunc actionWithTarget:self selector:@selector(removeHelpAndCallHome)];
    [self runAction:[CCSequence actions:action4,action5, nil]];
    NSLog(@" ghghg last");

}
-(id) init
{
	if( (self=[super init]))
    {
        ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        NSString *strForBgName=@"home.jpg";
        if (ScreenSize.width==568)
        {
            strForBgName=[NSString stringWithFormat:@"home%@.jpg",@"_iphone5"];
        }
        CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
        [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
        [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
        [self addChild:homeBg];
        [self callHelpFirstTimeOnly];
        [self DisplayHomePage];

        NSLog(@" ghghg %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]);

        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"firstTime"]integerValue]!=1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        else
            [self removeHelpAndCallHome];


    }
    return self;
}
@end
