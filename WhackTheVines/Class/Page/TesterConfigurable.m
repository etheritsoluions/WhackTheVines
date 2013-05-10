//
//  TesterConfigurable.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 25/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "TesterConfigurable.h"
#import "GameData.h"
CCLabelTTF *frogRandomCount,*wineRandomCount,*snakeSpeed,*wineSpeed;
GameData *testGmaeData;
@implementation TesterConfigurable
-(void)plusFrogRandom:(id)sender
{
    NSLog(@"helpMenuItem");
    if ( testGmaeData.FrogRandomInterval<30)
    testGmaeData.FrogRandomInterval +=1;
    [frogRandomCount setString:[NSString stringWithFormat:@"%d",testGmaeData.FrogRandomInterval]];
}
-(void)removeSelf
{
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}
-(void)homeActionInTest:(id)sender
{
    
    
    float deltaY=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?960.0:480.0;
    id action1= [CCCallFunc actionWithTarget:self.parent selector:@selector(removeTestConfig)];
    id action3= [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
    id action2= [CCMoveTo actionWithDuration:0.5 position:CGPointMake(self.position.x, -deltaY)];
    [self runAction:[CCSequence actions:action1,action2,action3,nil]];
    
    
    
}
-(void)minFrogRandom:(id)sender
{

    if ( testGmaeData.FrogRandomInterval>10)
        testGmaeData.FrogRandomInterval -=1;
    [frogRandomCount setString:[NSString stringWithFormat:@"%d",testGmaeData.FrogRandomInterval]];

}
-(void)minwineRandomAction:(id)sender
{

    if ( testGmaeData.wineRandomInterval>3)
        testGmaeData.wineRandomInterval -=1;
    [wineRandomCount setString:[NSString stringWithFormat:@"%d",testGmaeData.wineRandomInterval]];

}
-(void)plusWineRandomAction:(id)sender
{

    if ( testGmaeData.wineRandomInterval<20)
        testGmaeData.wineRandomInterval +=1;
    [wineRandomCount setString:[NSString stringWithFormat:@"%d",testGmaeData.wineRandomInterval]];

}
-(void)PlusSnakeSpeedAction:(id)sender
{
    if ( testGmaeData.snakeRandomInterval<20)
        testGmaeData.snakeRandomInterval +=1;
    [snakeSpeed setString:[NSString stringWithFormat:@"%d",testGmaeData.snakeRandomInterval]];
}
-(void)minSnakeSpeedAction :(id)sender
{
    if ( testGmaeData.snakeRandomInterval>3)
        testGmaeData.snakeRandomInterval -=1;
    [snakeSpeed setString:[NSString stringWithFormat:@"%d",testGmaeData.snakeRandomInterval]];
}
-(void)pluswineSpeedAction :(id)sender
{
 
    if ( testGmaeData.wineSpeed<25)
        testGmaeData.wineSpeed +=1;
    [wineSpeed setString:[NSString stringWithFormat:@"%d",(int)testGmaeData.wineSpeed]];
}
-(void)minwineSpeedAction:(id)sender
{
    if ( testGmaeData.wineSpeed>5)
        testGmaeData.wineSpeed -=1;
    [wineSpeed setString:[NSString stringWithFormat:@"%d",(int)testGmaeData.wineSpeed]];
  
}
-(id) init
{
	if( (self=[super init]))
    {
        CGSize ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        NSString *strForBgName=@"bg.jpg";
        if (ScreenSize.width==568)
        {
            strForBgName=[NSString stringWithFormat:@"%@",@"bg_iphone5.jpg"];
        }
        CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
        [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
        [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
        [self addChild:homeBg];
        
        CCMenuItemSprite *playMenuItem1;
        playMenuItem1        =    [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite  spriteWithFile:@"up.png"]
                                                         selectedSprite:[CCSprite  spriteWithFile:@"up.png"]
                                                                 target:self selector:@selector(pluswineSpeedAction:)];
        
        CCMenuItemSprite *playMenuItem;
        playMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite  spriteWithFile:@"up.png"]
                                                         selectedSprite:[CCSprite  spriteWithFile:@"up.png"]
                                                                 target:self selector:@selector(pluswineSpeedAction:)];
        
        CCMenuItemSprite *faceMenuItem;
        faceMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite  spriteWithFile:@"down.png"]
                                                         selectedSprite:[CCSprite  spriteWithFile:@"down.png"]
                                                                 target:self selector:@selector(minwineSpeedAction:)];
        
        CCMenuItemSprite *twitterMenuItem;
        twitterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                     [CCSprite  spriteWithFile:@"up.png"]
                                                            selectedSprite:[CCSprite  spriteWithFile:@"up.png"]
                                                                    target:self selector:@selector(PlusSnakeSpeedAction:)];
        
        CCMenuItemSprite *gameCenterMenuItem;
        gameCenterMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                        [CCSprite  spriteWithFile:@"down.png"]
                                                               selectedSprite:[CCSprite  spriteWithFile:@"down.png"]
                                                                       target:self selector:@selector(minSnakeSpeedAction:)];
        
        CCMenuItemSprite *soundMenuItem;
        soundMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                   [CCSprite  spriteWithFile:@"down.png"]
                                                          selectedSprite:[CCSprite  spriteWithFile:@"down.png"]
                                                                  target:self selector:@selector(minwineRandomAction:)];
        
        CCMenuItemSprite *musicMenuItem;
        musicMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                   [CCSprite  spriteWithFile:@"up.png"]
                                                          selectedSprite:[CCSprite  spriteWithFile:@"up.png"]
                                                                  target:self selector:@selector(plusWineRandomAction :)];
        
        
        CCMenuItemSprite *aboutMenuItem;
        aboutMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                   [CCSprite  spriteWithFile:@"up.png"]
                                                          selectedSprite:[CCSprite  spriteWithFile:@"up.png"]
                                                                  target:self selector:@selector(plusFrogRandom :)];
        CCMenuItemSprite *backButton;
        backButton        =    [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite  spriteWithFile:@"homeButton.png"]
                                                         selectedSprite:[CCSprite  spriteWithFile:@"homeButton.png"]
                                                                 target:self selector:@selector(homeActionInTest:)];
    
        CCMenuItemSprite *helpMenuItem;
        helpMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite  spriteWithFile:@"down.png"]
                                                         selectedSprite:[CCSprite  spriteWithFile:@"down.png"]
                                                                 target:self selector:@selector(minFrogRandom:)];
        CCMenu *playMenu =[CCMenu menuWithItems:playMenuItem,faceMenuItem,twitterMenuItem,gameCenterMenuItem,musicMenuItem,soundMenuItem,aboutMenuItem,helpMenuItem,backButton, nil];
        [playMenu setPosition:CGPointMake(ScreenSize.width/2, ScreenSize.height/2)];
        [self addChild:playMenu z:2001];//
        
        int font=22;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            font=38;
            [playMenuItem       setPosition:CGPointMake(ScreenSize.width/15, 120)];
            [faceMenuItem       setPosition:CGPointMake(ScreenSize.width/5, 120)];
            [playMenuItem1      setPosition:CGPointMake(ScreenSize.width/15, -100)];
            [twitterMenuItem    setPosition:CGPointMake(ScreenSize.width/15, 0)];
            [gameCenterMenuItem setPosition:CGPointMake(ScreenSize.width/5, 0)];
            
            [musicMenuItem      setPosition:CGPointMake(ScreenSize.width/15, -120)];
            [soundMenuItem      setPosition:CGPointMake(ScreenSize.width/5,  -120)];
            
            
            
            [aboutMenuItem      setPosition:CGPointMake(ScreenSize.width/15, -230)];
            [helpMenuItem       setPosition:CGPointMake(ScreenSize.width/5,  -230)];
            [backButton          setPosition:CGPointMake(ScreenSize.width/5, 150)];

        }
        else
        {
            [playMenuItem       setPosition:CGPointMake(ScreenSize.width/15, 60)];
            [faceMenuItem       setPosition:CGPointMake(ScreenSize.width/5, 60)];
            
            
            [twitterMenuItem    setPosition:CGPointMake(ScreenSize.width/15, 0)];
            [gameCenterMenuItem setPosition:CGPointMake(ScreenSize.width/5, 0)];
            
            [musicMenuItem      setPosition:CGPointMake(ScreenSize.width/15, -60)];
            [soundMenuItem      setPosition:CGPointMake(ScreenSize.width/5,  -60)];
            
            [aboutMenuItem      setPosition:CGPointMake(ScreenSize.width/15, -100)];
            [helpMenuItem       setPosition:CGPointMake(ScreenSize.width/5,  -100)];
            [backButton          setPosition:CGPointMake(-ScreenSize.width/10, 120)];

        
        }
        
        CCLabelTTF *labelw = [CCLabelTTF labelWithString:@"frog Random" fontName:@"Times New Roman" fontSize:font];
        [self addChild:labelw];
        [labelw setPosition:CGPointMake(ScreenSize.width/5, ScreenSize.height/5)];
        
        
         testGmaeData=[GameData gameDataInitial];
        
        
        frogRandomCount=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",testGmaeData.FrogRandomInterval] fontName:@"Times New Roman" fontSize:font];
        [self addChild:frogRandomCount];
        [frogRandomCount setPosition:CGPointMake(ScreenSize.width/5+(ScreenSize.width/6), ScreenSize.height/5)];
        
        
        
        CCLabelTTF *labelwine = [CCLabelTTF labelWithString:@"wine Random" fontName:@"Times New Roman" fontSize:font];
        [self addChild:labelwine];
        [labelwine setPosition:CGPointMake(ScreenSize.width/5, ScreenSize.height/3)];
        wineRandomCount=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",testGmaeData.wineRandomInterval] fontName:@"Times New Roman" fontSize:font];
        [self addChild:wineRandomCount];
        [wineRandomCount setPosition:CGPointMake(ScreenSize.width/5+(ScreenSize.width/6), ScreenSize.height/3)];
        
        
        CCLabelTTF *labels = [CCLabelTTF labelWithString:@"snake Random" fontName:@"Times New Roman" fontSize:font];
        [self addChild:labels];
        [labels setPosition:CGPointMake(ScreenSize.width/5, ScreenSize.height/2)];
        
        
        snakeSpeed=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",testGmaeData.snakeRandomInterval] fontName:@"Times New Roman" fontSize:font];
        [self addChild:snakeSpeed];
        [snakeSpeed setPosition:CGPointMake(ScreenSize.width/5+(ScreenSize.width/6), ScreenSize.height/2)];
        
        
        CCLabelTTF *labelwineSpeed = [CCLabelTTF labelWithString:@"wine Speed" fontName:@"Times New Roman" fontSize:font];
        [self addChild:labelwineSpeed];
        [labelwineSpeed setPosition:CGPointMake(ScreenSize.width/5, ScreenSize.height/1.5)];
        
        wineSpeed=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(int)testGmaeData.wineSpeed] fontName:@"Times New Roman" fontSize:font];
        [self addChild:wineSpeed];
        [wineSpeed setPosition:CGPointMake(ScreenSize.width/5+(ScreenSize.width/6), ScreenSize.height/1.5)];
        

        
        
    }
    return self;
}
@end
