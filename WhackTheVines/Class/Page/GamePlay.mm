//
//  GamePlay.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 18/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "GamePlay.h"
#import "PausePage.h"
#import "GameData.h"
#import "GameOver.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "MainClass.h"

#define tagFor_menuInGame   101
#define tagFor_FrogInGame   102
#define tagFor_FrogInRight  103
#define tagForRemove        104

#define tagFor_SnakeInGame  500

GameData *gameDataInGame;
CCSprite *musicOff;
b2World* world;
CCLabelTTF *scoreOnTop,*scoreOnTopG;
float PTM_RATIO;
int   frogOnTheWine=0,frogOnTheRightWine=0,lastWineUp=0,wineOnWhich=0,lifeUsed=3,leftFrogColor=0,rightFrogColor=0,wineOnRightWhich=0;
CGPoint locationBegin;
//REVOME
float xValue=0,yValue=0,xValueRight=0,yValueRight=0;
int removeIt=1,wineIsGrowing=0,snakeIsMoving=0,lastWineGrow=2,isWinStatus=0,isPauseStatus=0;




@implementation GamePlay
CGSize ScreenSize;
#pragma mark Clean
-(void) cleanUpFunction
{
    
    [self reSetLifeOption];
    isWinStatus=1;
    [self stopTimers];
    xValue=0;
    yValue=0;
    xValueRight=ScreenSize.width,yValueRight=ScreenSize.height;
    frogOnTheWine=0,lastWineUp=0,wineOnWhich=1,leftFrogColor=0,isWinStatus=0,isPauseStatus=0,rightFrogColor=0,wineOnRightWhich=5,frogOnTheRightWine=0;
    gameDataInGame.wineFirst=0;
    gameDataInGame.wineFouth=0;
    gameDataInGame.wineSec  =0;
    gameDataInGame.wineThrid=0;

    [self stopTimers];

	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3f scene:[MainClass node]]];
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    
//    CCLOG(@"%@<applicationDidReceiveMemoryWarning> : after purge", self.class);
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    CCNode *aChild;
    while((aChild=[self getChildByTag:tagForRemove]) != nil)
        [self removeChild:aChild cleanup:YES];
    while((aChild=[self getChildByTag:tagFor_FrogInGame]) != nil)
        [self removeChild:aChild cleanup:YES];
    while((aChild=[self getChildByTag:tagFor_FrogInRight]) != nil)
        [self removeChild:aChild cleanup:YES];
    [self removeFromParentAndCleanup:YES];

}
#pragma mark Leader Board
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
#pragma mark Button Action
-(void)pauseDirector
{
    [self stopTimers];
    [[CCDirector sharedDirector]pause];
}
-(void)pauseAction:(id)sender
{
    isPauseStatus=1;
    [self playSound:1];
    CCMenu *tempMenuInGame=(CCMenu*)[self getChildByTag:tagFor_menuInGame];
    [tempMenuInGame setVisible:FALSE];
     PausePage *thePauseNode;
     thePauseNode     =   [PausePage node];
    [thePauseNode setPosition:CGPointMake(0, -ScreenSize.height)];
    [self addChild:thePauseNode z:1900];
    
    id action1  =   [CCMoveTo actionWithDuration:0.5 position:CGPointZero];
    id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(pauseDirector)];
    [thePauseNode runAction:[CCSequence actions:action1,action2,nil]];
}
-(void)soundActionInPlay:(id)sender
{
    [self playSound:1];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==0)
    {
        [musicOff setVisible:FALSE];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"sound"];
        [SimpleAudioEngine sharedEngine].mute=FALSE;
    }
    else
    {
        [musicOff setVisible:TRUE];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"sound"];
        [SimpleAudioEngine sharedEngine].mute=TRUE;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)startTimers
{
    wineIsGrowing=0;
    snakeIsMoving=0;
    lifeUsed=0;
    frogOnTheWine=0;
    frogOnTheRightWine=0;
    wineIsGrowing=0;
    snakeIsMoving=0;
    isWinStatus=0;
    isPauseStatus=0;
    [self schedule:@selector(wineAppearTimmer :)     interval:gameDataInGame.wineRandomInterval];
    [self schedule:@selector(snakeAppearTimmer:)     interval:gameDataInGame.snakeRandomInterval];
    [self schedule:@selector(frogAppearTimmer :)     interval:gameDataInGame.FrogRandomInterval];

    
}
-(void)stopTimers
{
    [self unschedule:@selector(wineAppearTimmer:)];
    [self unschedule:@selector(snakeAppearTimmer:)];
    [self unschedule:@selector(frogAppearTimmer:)];

}
-(void)removePausePage
{
    isPauseStatus=0;
    CCMenu *tempMenuInGame=(CCMenu*)[self getChildByTag:tagFor_menuInGame];
    [tempMenuInGame setVisible:TRUE];
    isWinStatus=1;
    isPauseStatus=1;
    [self startTimers];
}

-(void)removePausePageRestart
{
    [self startTimers];
    isWinStatus=0;
    isPauseStatus=0;
    CCMenu *tempMenuInGame=(CCMenu*)[self getChildByTag:tagFor_menuInGame];
    [tempMenuInGame setVisible:TRUE];
    lifeUsed=0;
    [self reSetLifeOption];
    snakeIsMoving=0;
    wineIsGrowing=0;
}
#pragma mark GameOver
-(void)CallgameOver
{
    [self reSetLifeOption];
    [self stopTimers];
    if(isWinStatus==0 && isPauseStatus==0 )
    {
        isWinStatus=1;

        GameOver *thegameNode     =   [GameOver node];
        [thegameNode setPosition:CGPointMake(0,0)];
        [self addChild:thegameNode z:2900];
    }
}
#pragma mark Load Game Design
-(void)DisplayGamePage
{
    ///Sound
    [self playSound:0];
    wineIsGrowing=0;
    snakeIsMoving=0;
    lifeUsed=0;
    
    [self callXInGame];
    
    NSString *strForBgName=@"bg.jpg";
    if (ScreenSize.width==568)
    {
        strForBgName=[NSString stringWithFormat:@"%@",@"bg_iphone5.jpg"];
    }
    CCSprite *homeBg     =   [CCSprite spriteWithFile:strForBgName];
    [homeBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [homeBg setPosition:CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0)];
    [self addChild:homeBg];
    
    musicOff=[CCSprite spriteWithFile:@"musioff.png"];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==0)
        [musicOff setVisible:TRUE];
    else
        [musicOff setVisible:FALSE];
    
    CGPoint pauseButtonPoint;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        pauseButtonPoint    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    else
        pauseButtonPoint    =    CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0);
    
    CCMenuItemSprite *pauseMenuItem;
    pauseMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                              [CCSprite  spriteWithFile:@"gamepause.png"]
                                                     selectedSprite:[CCSprite  spriteWithFile:@"gamepause.png"]
                                                             target:self selector:@selector(pauseAction:)];
    CCMenuItemSprite *soundMenuItem;
    soundMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                               [CCSprite  spriteWithFile:@"soundon.png"]
                                                      selectedSprite:[CCSprite  spriteWithFile:@"soundon.png"]
                                                              target:self selector:@selector(soundActionInPlay:)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [pauseMenuItem    setPosition:CGPointMake(445, -328)];
        [soundMenuItem    setPosition:CGPointMake(-432, -328)];
        [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)-432, (ScreenSize.height/2.0)-328)];
    }
    else
    {
        if(ScreenSize.width == 568)
        {
            [pauseMenuItem    setPosition:CGPointMake(240, -100)];
            [soundMenuItem    setPosition:CGPointMake(-240, -100)];
            [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)-240, (ScreenSize.height/2.0)-100)];
        }
        else
        {
            [pauseMenuItem    setPosition:CGPointMake(205, -100)];
            [soundMenuItem    setPosition:CGPointMake(-205, -100)];
            [musicOff           setPosition:CGPointMake((ScreenSize.width/2.0)-205, (ScreenSize.height/2.0)-100)];
        }
    }
    CCMenu *playMenu =[CCMenu menuWithItems:pauseMenuItem,soundMenuItem,nil];
    [playMenu setPosition:pauseButtonPoint];
    [playMenu setTag:tagFor_menuInGame];
    [self addChild:playMenu z:999];
    
    
    int font=22;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        font=44;

    scoreOnTopG=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"highScore"]] fontName:@"Times New Roman" fontSize:font];
    [self addChild:scoreOnTopG];
    [scoreOnTopG setPosition:CGPointMake(ScreenSize.width-(ScreenSize.width/6), ScreenSize.height-ScreenSize.height/20)];
    [scoreOnTopG setColor:ccc3(255, 216, 0)];
    
    
    CCLabelTTF *scoreOnTopText=[CCLabelTTF labelWithString:@"Score: " fontName:@"Times New Roman" fontSize:font];
    [self addChild:scoreOnTopText];
    [scoreOnTopText setPosition:CGPointMake((ScreenSize.width/2)-(ScreenSize.width/15), ScreenSize.height-ScreenSize.height/20)];
    [scoreOnTopText setColor:ccc3(255, 174, 0)];
    
    scoreOnTop=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",0] fontName:@"Times New Roman" fontSize:font];
    [self addChild:scoreOnTop];
    [scoreOnTop setPosition:CGPointMake(ScreenSize.width/2+(ScreenSize.width/40), ScreenSize.height-ScreenSize.height/20)];
    [scoreOnTop setColor:ccc3(255, 174, 0)];

    CCSprite *crossBlank     =   [CCSprite spriteWithFile:@"lifeoff.png"];
    [crossBlank setPosition:CGPointMake(crossBlank.boundingBox.size.width/1.5, ScreenSize.height-ScreenSize.height/20)];
    [self addChild:crossBlank];
    
    int yIad=16;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        yIad=33;
    CCSprite *iadSpace     =   [CCSprite spriteWithFile:@"iadTest.jpg"];
    [iadSpace setPosition:CGPointMake(ScreenSize.width/2, yIad)];
    [self addChild:musicOff z:999];


    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1)
    {
        [musicOff setVisible:FALSE];
        [SimpleAudioEngine sharedEngine].mute=FALSE;
    }
    else
    {
        [musicOff setVisible:TRUE];
        [SimpleAudioEngine sharedEngine].mute=TRUE;
    }
    
}
-(void)InitialSpriteLoad
{
    CCSpriteBatchNode *_batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frogAnim.png"];
    [self addChild:_batchNode z:2000];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"frogAnim.plist"];

}
#pragma mark -Cross Actions
-(void)reSetLifeOption
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"highScore"] integerValue]<[scoreOnTop.string integerValue])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:[scoreOnTop.string integerValue] forKey:@"currentScore"];
        [scoreOnTopG setString:[NSString stringWithFormat:@"High Score: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currentScore"]]];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:[scoreOnTop.string integerValue] forKey:@"currentScore"];
    lifeUsed=0;
    for (int i=0; i<3; i++)
    {
        CCSprite *removeSprite=(CCSprite*)[self getChildByTag:i+1+900];
        [removeSprite setVisible:FALSE];
    }
}
-(void)callXInGame
{
    int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 40 : 18;
    for (int i=0; i<3; i++)
    {
        CCSprite *spriteX=[CCSprite spriteWithFile:@"life.png"];
        [self addChild:spriteX z:999];
        [spriteX setPosition:CGPointMake(height*i+(spriteX.boundingBox.size.width/1.2), ScreenSize.height-ScreenSize.height/20)];
        [spriteX setTag:900+i+1];
        [spriteX  setVisible:FALSE];
    }
}
-(void)removeLifeAt
{
    
    CCSprite *removeSprite=(CCSprite*)[self getChildByTag:lifeUsed+1+900];
    [removeSprite setVisible:TRUE];
    [self playSound:5];
    lifeUsed+=1;
    if(lifeUsed>=3)
    {
        id action1 = [CCDelayTime actionWithDuration:1];
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(CallgameOver)];
        [self runAction:[CCSequence actions:action1,action2,nil]];
    }
    
    
}
#pragma mark  PlaySound 
-(void)stopWineSound
{
    wineIsGrowing=0;
}

-(void)stopSnakeSound
{
    snakeIsMoving=0;
    [self removeLifeAt];
}

-(void)playLoopSoundForWine
{
    
    if(wineIsGrowing==1&&[[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1&&isWinStatus==0 && isPauseStatus==0)
    {
        float duration=1.0f;
        [[SimpleAudioEngine sharedEngine]playEffect:@"DeleteButtonSound.wav"];
        id action1 = [CCDelayTime actionWithDuration:duration];
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(playLoopSoundForWine)];
        [self runAction:[CCSequence actions:action1,action2,nil]];
    }
}
-(void)playLoopSoundForSnake
{
    //snakeIsMoving=0;
    if(snakeIsMoving==1&&[[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1&&isWinStatus==0 && isPauseStatus==0)
    {
        float duration=4.0f;
        [[SimpleAudioEngine sharedEngine]playEffect:@"SirenSong.wav"];
        id action1 = [CCDelayTime actionWithDuration:duration];
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(playLoopSoundForSnake)];
        [self runAction:[CCSequence actions:action1,action2,nil]];
    }
}
-(void)playSound:(int)soundName
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1 && isWinStatus==0 && isPauseStatus==0)
        switch (soundName)
        {
            case 0:
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==1)
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backGround.wav"];
            break;
            case 1:
                [[SimpleAudioEngine sharedEngine] playEffect:@"Button_switch.wav"];
            break;
            case 2:
                [[SimpleAudioEngine sharedEngine] playEffect:@"UBC1_Sound13.wav"];//wack wine
            break;
            case 3:
                [[SimpleAudioEngine sharedEngine] playEffect:@"cancelbutton.wav"]; // miss wine
            break;
            case 4:
                [[SimpleAudioEngine sharedEngine] playEffect:@"simpleWin.wav"]; //X get One
            break;
            case 5:
                [[SimpleAudioEngine sharedEngine] playEffect:@"WrongAnswerAlarmBuzzer.wav"]; // x remove one
            break;
            case 6:
                [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];//game over
            break;
            case 7:
                [[SimpleAudioEngine sharedEngine] playEffect:@"Man_scream_2.wav"];// frog scream
            break;
            case 8:
                [[SimpleAudioEngine sharedEngine] playEffect:@"dinobugtongue2.wav"];// wack snake
            break;
            case 9:
                [[SimpleAudioEngine sharedEngine] playEffect:@"Button_switch.wav"];
            break;
            case 10:
                [[SimpleAudioEngine sharedEngine] playEffect:@"Frog.wav"];
                break;
            case 11:
                [[SimpleAudioEngine sharedEngine] playEffect:@"Button2.wav"];
                break;
            default:
            break;
        }
}

#pragma mark  Action Animation 
#pragma mark -Blood
-(void) FrogbackTo:(id)sender data:(CCSprite*)sprite
{
    [sprite setPosition:CGPointMake(-160, 10)];
    [sprite runAction:[CCFadeIn actionWithDuration:0.1]];
}
-(void)callBloodSplash:(CCSprite*)lhsprite
{
    [lhsprite stopAllActions];
    CCAnimation *animation = [CCAnimation animation];
    animation.delayPerUnit = 0.03;
    
    for (int i=1; i<10; i++)
        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"splash%d.png",i]];
    id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(FrogbackTo:data:) data:lhsprite];
    [lhsprite runAction:[CCSequence actions: [CCAnimate actionWithAnimation:animation],[CCFadeOut actionWithDuration:0.1],actionMove4, nil]];
    
}
#pragma mark - frog
-(void)frogFellDown
{
    CCSprite *frog =(CCSprite*)[self getChildByTag:tagFor_FrogInGame];//+700
    [frog stopAllActions];
    float speedToFall=(frog.position.y-(-frog.boundingBox.size.height))/(5*100);
    NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInGame;
    id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];

    [frog runAction:[CCSequence actions:[CCMoveTo actionWithDuration:speedToFall position:CGPointMake(frog.position.x, -frog.boundingBox.size.height)],actionMove1, nil]];
    wineOnWhich=1;
    leftFrogColor=0;
    frogOnTheWine=0;
    xValue=0;
    yValue=0;
  
}
-(void)rightFrogFellDown
{
    CCSprite *frog =(CCSprite*)[self getChildByTag:tagFor_FrogInRight];//+700
    [frog stopAllActions];
    float speedToFall=(frog.position.y-(-frog.boundingBox.size.height))/(5*100);
    NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInRight;
    
    id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];
    
    [frog runAction:[CCSequence actions:[CCMoveTo actionWithDuration:speedToFall position:CGPointMake(frog.position.x, -frog.boundingBox.size.height)],actionMove1, nil]];
    rightFrogColor=0;
    wineOnRightWhich=5;
    frogOnTheRightWine=0;
    xValueRight=ScreenSize.width;
    yValueRight=ScreenSize.height;
    
    
}
-(int)cheackFrogCanJumpTo:(int)dir currentFrogPosition:(int)currentWine
{
    int canJump=0;
    switch (dir)
    {
        case 0:
        {
            if (currentWine==0)
            {
                if(gameDataInGame.wineFirst ==1)
                    canJump=1;
            }
            else if (currentWine==1)
            {
                if(gameDataInGame.wineSec   ==1)
                    canJump=1;
            }
            else if(currentWine==2)
            {
                if(gameDataInGame.wineThrid ==1)
                    canJump=1;
            }
            else if (currentWine==3)
            {
                if(gameDataInGame.wineFouth ==1)
                    canJump=1;
            }
            else if (currentWine==4)
            {
                    canJump=1;
            }
        }
        break;
        case 1:
        {
            if (currentWine==5)
            {
                if(gameDataInGame.wineFouth ==1)
                    canJump=1;
            }
            else if (currentWine==4)
            {
                if(gameDataInGame.wineThrid   ==1)
                    canJump=1;
            }
            else if(currentWine==3)
            {
                if(gameDataInGame.wineSec ==1)
                    canJump=1;
            }
            else if (currentWine==2)
            {
                if(gameDataInGame.wineFirst ==1)
                    canJump=1;
            }
            else if (currentWine==1)
            {
                canJump=1;
            }
        }
        break;
        default:
            break;
    }
    return canJump;
}
-(void)callFrogJumpActionToWine:(int)goToWine leafNumber:(int)randomLeaf dir:(int)direction
{
    CCSprite *frog ;
    if (direction==1) 
        frog =(CCSprite*)[self getChildByTag:tagFor_FrogInRight];
    else
        frog =(CCSprite*)[self getChildByTag:tagFor_FrogInGame];
    int distance=76;
    switch (randomLeaf)
    {
        case 3:
            randomLeaf=0;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=20;
            else
                distance=14;
            break;
        case 2:
            randomLeaf=1;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=185;
            else
                distance=86;
            break;
        case 1:
            randomLeaf=2;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=175*2;
            else
                distance=2*76;
            break;
        case 4:
            randomLeaf=-1;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=-135;
            else
                distance=-48;
            break;
        case 5:
            randomLeaf=-2;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=-2*150;
            else
                distance=-2*56;
            break;
        default:
            randomLeaf=2;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                distance=175*2;
            else
                distance=2*76;
            break;
    }
    CCSprite *tempWineSprite=(CCSprite*)[self getChildByTag:goToWine+600];
    if(direction==0)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            xValue+=(((ScreenSize.width/5)*1)-10);
            yValue=tempWineSprite.position.y+distance;
        }
        else
        {
            xValue+=(((ScreenSize.width/5)*1)-0);
            yValue =tempWineSprite.position.y+distance;
        }
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            xValueRight-=(((ScreenSize.width/5)*1)-10);
            yValueRight=tempWineSprite.position.y+distance;
        }
        else
        {
            xValueRight-=(((ScreenSize.width/5)*1)-0);
            yValueRight =tempWineSprite.position.y+distance;
        }
    }
    CGPoint interPoint;
    interPoint=CGPointMake(frog.position.x+((xValue-frog.position.x)/2), yValue+66);
    int randomColor =1;
    if(direction==0)
    {
        if(leftFrogColor==0)
            randomColor = (arc4random()%(5-1))+1;
        else
            randomColor= leftFrogColor;
        leftFrogColor=randomColor;

    }
    else
    {
        if(rightFrogColor==0)
            randomColor = (arc4random()%(5-1))+1;
        else
            randomColor= rightFrogColor;
        rightFrogColor=randomColor;

    }
    
    NSString *strColor=@"orangefrog";
    switch (randomColor)
    {
        case 1:
            strColor=@"bluefrog";
            break;
        case 2:
            strColor=@"redfrog";
            break;
        case 3:
            strColor=@"yellowfrog";
            break;
        case 4:
            strColor=@"greenfrog";
            break;
        case 5:
            strColor=@"orangefrog";
            break;
        default:
            strColor=@"orangefrog";
            break;
    }
    //NSLog(@"xValueRight=%f, yValueRight=%f",xValueRight, yValueRight);
    if (direction==0) 
        [self animationFrog:CGPointMake(xValue, yValue) inter:interPoint color:strColor wineNumber:goToWine dir:direction];
    else
        [self animationFrog:CGPointMake(xValueRight, yValueRight) inter:interPoint color:strColor wineNumber:goToWine dir:direction];
}
-(void) reSetFrog:(id)sender data:(int)tagForFrog
{
    if (tagForFrog==tagFor_FrogInGame)
    {
        CCSprite *frogLeft=(CCSprite*)[self getChildByTag:tagFor_FrogInGame];
        [frogLeft setPosition:CGPointMake(-160, 0)];
        wineOnWhich=1;
        leftFrogColor=0;
        xValue=0;
        yValue=0;
    }
    else
    {
        CCSprite *frogRight=(CCSprite*)[self getChildByTag:tagFor_FrogInRight];
        [frogRight setPosition:CGPointMake(ScreenSize.width+frogRight.boundingBox.size.width, -frogRight.boundingBox.size.height)];
        xValueRight=ScreenSize.width,yValueRight=ScreenSize.height;
        wineOnRightWhich=5;
        rightFrogColor=0;

    }
}
-(void) actionToMoveWineAgain:(id)sender data:(int)intVar1 
{
    frogOnTheRightWine=wineOnRightWhich;
    CCSprite *winetoStop=(CCSprite*)[self getChildByTag:intVar1+600];//tag intVar1
    if (wineOnRightWhich<5)
        [winetoStop stopAllActions];
    if(wineOnRightWhich<=1)
    {
        
        CCSprite *frog =(CCSprite*)[self getChildByTag:tagFor_FrogInRight];//frogOnTheWine+700
        NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInRight;
        
        id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];
        
        int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 200 : 100;
        [frog runAction:[CCSequence actions:[CCJumpTo actionWithDuration:1 position:CGPointMake(frog.position.x-(ScreenSize.width/2), frog.position.y) height:height jumps:1],actionMove1, nil]];
        
        wineOnRightWhich=5;
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:intVar1+600+1];//tag intVar1
        NSInteger *sendInt=(NSInteger*)(intVar1+600+1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];
        
        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                          [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                           action2,actionMove4, nil];
        [winetoStart runAction:seq];
    }
    else if(wineOnRightWhich<5 )
    {
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:intVar1+600+1];//tag intVar1
        NSInteger *sendInt=(NSInteger*)(intVar1+600+1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];
        
        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                           [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                           action2,actionMove4, nil];
        [winetoStart runAction:seq];
    }
}
-(void) actionToMoveWithWine:(id)sender data:(int)intVar1
{
   frogOnTheWine=wineOnWhich-1;
    CCSprite *winetoStop=(CCSprite*)[self getChildByTag:intVar1+600];//tag intVar1
    if (wineOnWhich<5)
        [winetoStop stopAllActions];
    if(wineOnWhich>=5)
    {
        CCSprite *frog =(CCSprite*)[self getChildByTag:tagFor_FrogInGame];//frogOnTheWine+700
        NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInGame;

        id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];

        int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 200 : 100;
        [frog runAction:[CCSequence actions:[CCJumpTo actionWithDuration:1 position:CGPointMake(frog.position.x+(ScreenSize.width/2), frog.position.y) height:height jumps:1],actionMove1, nil]];
        
        wineOnWhich=1;
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:intVar1+600-1];//tag intVar1
        NSInteger *sendInt=(NSInteger*)(intVar1+600-1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];

        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                          [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                           action2,actionMove4, nil];
        [winetoStart runAction:seq];
        
    }
    else if(wineOnWhich>1 )
    {
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:intVar1+600-1];//tag intVar1
        NSInteger *sendInt=(NSInteger*)(intVar1+600-1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];

        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                      [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                       action2,actionMove4, nil];
        [winetoStart runAction:seq];
    }
}
-(void) checkVineIsThereOnJumpFinish:(id)sender data:(int)intVar1
{
    if(intVar1==tagFor_FrogInGame)
    {
        if ([self checkWineIsThere:frogOnTheWine])
        {
            [self playSound:7];
            [self removeLifeAt];
            [self frogFellDown];
        }
    }
    else if (intVar1==tagFor_FrogInRight)
    {
        if ([self checkWineIsThere:frogOnTheRightWine])
        {
            [self playSound:7];
            [self removeLifeAt];
            [self rightFrogFellDown];
        }
    }
}
-(void)animationFrog:(CGPoint)MoveTo inter:(CGPoint)interMediPosi color:(NSString*)colorName wineNumber:(int)wineNo dir:(int)toGo
{
    [self playSound:10];
    CCSpriteFrameCache * cache =[CCSpriteFrameCache sharedSpriteFrameCache];
    CCAnimation *animation = [CCAnimation animation];
    animation.delayPerUnit = 0.03;
    for (int i=1; i<=6; i++)
        [animation addSpriteFrame:[cache spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",colorName,i]]];
    CCAnimation *animation1 = [CCAnimation animation];
    for (int j=6; j>=1; j--)
        [animation1 addSpriteFrame:[cache spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",colorName,j]]];
    animation1.delayPerUnit = 0.05;
    
    id action1  =   [CCAnimate actionWithAnimation:animation];
    id action2  =   [CCAnimate actionWithAnimation:animation1];
    CCSprite *frogForAnim;
    if (toGo==1)
        frogForAnim =(CCSprite*)[self getChildByTag:tagFor_FrogInRight];
    else
        frogForAnim =(CCSprite*)[self getChildByTag:tagFor_FrogInGame];
    int height=60;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        height=120;
    id action6  =   [CCJumpTo actionWithDuration:1 position:MoveTo height:height jumps:1];
    NSInteger *sendInt=(NSInteger*)wineNo;
    NSInteger *sendIntFrog=(NSInteger*)frogForAnim.tag;
    id actionMove8 ;
    if (toGo==1)
        actionMove8= [CCCallFuncND actionWithTarget:self selector:@selector(actionToMoveWineAgain:data:) data:sendInt];
    else
         actionMove8 = [CCCallFuncND actionWithTarget:self selector:@selector(actionToMoveWithWine:data:) data:sendInt];
    id action9 = [CCCallFuncND actionWithTarget:self selector:@selector(checkVineIsThereOnJumpFinish:data:) data:sendIntFrog];
    [frogForAnim runAction:action1];
    [frogForAnim runAction:[CCSequence actions:action6, actionMove8,action9,action2,nil]];
}
-(void)frogAppearTimmer:(ccTime)dt
{
    if([self cheackFrogCanJumpTo:0 currentFrogPosition:wineOnWhich]==1)
    {
        if([self wineCheckAvailable:wineOnWhich]!=0)
        {
            [self callFrogJumpActionToWine:wineOnWhich leafNumber:[self wineCheckAvailable:wineOnWhich] dir:0];
            wineOnWhich+=1;
        } 
    }
    if([self cheackFrogCanJumpTo:1 currentFrogPosition:wineOnRightWhich]==1)
    {
        if([self wineCheckAvailable:wineOnRightWhich-1]!=0)
        {
            [self callFrogJumpActionToWine:wineOnRightWhich-1 leafNumber:[self wineCheckAvailable:wineOnRightWhich-1] dir:1];
            wineOnRightWhich-=1;
        }
    }
}
#pragma mark -snake
-(void)callSnakeAtPositionLRTDDirection:(int)dir speedNeed:(float)speedValue
{
    /// dir==1 , x-->
    /// dir==0 , x<--
    /// dir==2 , y-->
    /// dir==3 , y<--
    CGPoint gotoPosition,fromPosition;
    float speedCal=speedValue;
    float randomY = (arc4random()%(10-2))+2;
    CCSprite *snake =[CCSprite spriteWithFile:@"snake1.png"];
    [self addChild:snake z:100];
    [snake setTag:1199];
    if (dir==1)
    {
        gotoPosition=CGPointMake(ScreenSize.width+(ScreenSize.width/5), ScreenSize.height/randomY);
        fromPosition=CGPointMake(0, ScreenSize.height/randomY);
        speedCal=(gotoPosition.x-0)/(speedValue*100);
    }
    else if (dir==0)
    {
        gotoPosition=CGPointMake(-(ScreenSize.width/5), ScreenSize.height/randomY);
        fromPosition=CGPointMake(ScreenSize.width+(ScreenSize.width/5), ScreenSize.height/randomY);
        speedCal=(fromPosition.x-gotoPosition.x)/(speedValue*100);
        [snake setFlipX:YES];

    }
    else if (dir==2)
    {
        fromPosition=CGPointMake((ScreenSize.width/randomY),  -(ScreenSize.width/5));
        gotoPosition=CGPointMake((ScreenSize.width/randomY), ScreenSize.height*1.3);
        speedCal=(gotoPosition.y-fromPosition.y)/(speedValue*100);
        snake.rotation = 90;
        [snake setFlipX:YES];

    }
    else if (dir==3)
    {
        gotoPosition=CGPointMake((ScreenSize.width/randomY), -(ScreenSize.width/5));
        fromPosition=CGPointMake((ScreenSize.width/randomY), ScreenSize.height);
        speedCal=(fromPosition.x+gotoPosition.x)/(speedValue*100);
        snake.rotation = 90;

    }
    [snake setPosition:fromPosition];
    CCAnimation *animation = [CCAnimation animation];
    for (int i=1; i<=6; i++)
        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"snake%d.png",i]];
    for (int j=5; j>=1; j--)
        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"snake%d.png",j]];
    animation.delayPerUnit = 0.1;
    snakeIsMoving=1;
    [self playLoopSoundForSnake];
    [snake runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(removeWine:data:) data:snake  ];
    id action4  =   [CCCallFunc actionWithTarget:self selector:@selector(stopSnakeSound)];
    [snake runAction:[CCSequence actions:[CCMoveTo actionWithDuration:speedCal position:gotoPosition],action4,actionMove4, nil]];
}
-(void)snakeAppearTimmer:(ccTime)dt
{
    int random = (arc4random()%(3-0))+0;
    [self callSnakeAtPositionLRTDDirection:random speedNeed:2];
}
#pragma mark -Wine
-(void) removeIT:(id)sender data:(int)intVar1
{
    CCSprite *wineOver=(CCSprite*)[self getChildByTag:intVar1];
    [wineOver removeFromParentAndCleanup:YES];
    intVar1=(-1)*(600-intVar1);
    if (intVar1==1 )
    {
        gameDataInGame.wineFirst=0;
    }
    if (intVar1==2 )
    {
        gameDataInGame.wineSec=0;
    }
    if (intVar1==3)
    {
        gameDataInGame.wineThrid=0;
    }
    if (intVar1==4)
    {
        gameDataInGame.wineFouth=0;
    }
}

-(void) ERestore:(id)sender data:(int)intVar1
{
    CCSprite *wineOver=(CCSprite*)[self getChildByTag:intVar1];
    if(wineOver.position.y>=ScreenSize.height/2)
        [self removeLifeAt];

    [wineOver setColor:ccc3(64, 41, 7)];
    NSInteger *sendInt=(NSInteger*)wineOver.tag;

    id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(removeIT:data:) data:sendInt];

    [wineOver runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1],actionMove4, nil] ];
    intVar1=(-1)*(600-intVar1);
    if (intVar1==1 )
    {
        gameDataInGame.wineFirst=0;
    }
    if (intVar1==2 )
    {
        gameDataInGame.wineSec=0;
    }
    if (intVar1==3)
    {
        gameDataInGame.wineThrid=0;
    }
    if (intVar1==4)
    {
        gameDataInGame.wineFouth=0;
    }

}
-(BOOL)checkWineIsThere:(int)random
{
    if (random==1&&gameDataInGame.wineFirst==1)
            return FALSE;
    else if (random==2&&gameDataInGame.wineSec==1)
            return FALSE;
    else if (random==3&&gameDataInGame.wineThrid==1)
            return FALSE;
    else if (random==4&&gameDataInGame.wineFouth==1)
            return FALSE;
    else
        return TRUE;
    return FALSE;
}

-(int)checkNextWine
{
    switch (lastWineUp)
    {
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 1;
            break;
        default:
            return 1;
            break;
    }
    return 1;
}
-(void)NewVineToDisplay:(int)random atSpeed:(float)wineSpeed
{
    float wineXposition=(ScreenSize.width/5)*random;
    CCSprite *wineInPosition =[CCSprite spriteWithFile:@"wine.png"];
    [wineInPosition setPosition:CGPointMake(wineXposition , -ScreenSize.height/2)];
    [self addChild:wineInPosition z:100];
    [wineInPosition setTag:600+random];
    wineIsGrowing=1;
    [self playLoopSoundForWine];
    NSInteger *sendInt=(NSInteger*)wineInPosition.tag;
    id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];
    
    id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
    CCSequence *seq = [CCSequence actions:
                       [CCMoveTo actionWithDuration:(ScreenSize.height/60)*wineSpeed position:CGPointMake(wineXposition, ScreenSize.height/2)],
                       actionMove4,action2, nil];
    [wineInPosition runAction:seq];
    if (random==1 )
    {
        gameDataInGame.wineFirst=1;
    }
    if (random==2 )
    {
        gameDataInGame.wineSec=1;
    }
    if (random==3)
    {
        gameDataInGame.wineThrid=1 ;
    }
    if (random==4)
    {
        gameDataInGame.wineFouth=1;
    }
    lastWineUp=random;
}
-(void)wineAtSpeed:(float)wineSpeed
{
    if (gameDataInGame.wineFirst==0 || gameDataInGame.wineSec==0  || gameDataInGame.wineThrid==0 || gameDataInGame.wineFouth==0)
    {
        int random = [self checkNextWine];
        if ([self checkWineIsThere:random])
        {
            [self NewVineToDisplay:random atSpeed:wineSpeed];
        }
        else if (random+1<=4&&[self checkWineIsThere:random+1])
        {
            random=random+1;
             [self NewVineToDisplay:random atSpeed:wineSpeed];
        }
        else if (random+1>4&&[self checkWineIsThere:1])
            [self NewVineToDisplay:1 atSpeed:wineSpeed];
    }
}
-(int)wineCheckAvailable:(int)wineNo
{
    CCSprite *tempSprite=(CCSprite*)[self getChildByTag:600+wineNo];
    if(tempSprite.position.y==0)
        return 0;

    if (tempSprite.position.y>=tempSprite.boundingBox.size.height/2)
    {
        return 4;
    }
    if (tempSprite.position.y>=tempSprite.boundingBox.size.height/3)
    {
        return 3;
    }
    
    if (tempSprite.position.y>=tempSprite.boundingBox.size.height/5)
    {
        return 3;
    }
    if (tempSprite.position.y>=-tempSprite.boundingBox.size.height/20)
    {
        return 2;
    }
    if (tempSprite.position.y>=-tempSprite.boundingBox.size.height/5)
    {
        return 1;
    }
    return 0;
}
-(void)wineAppearTimmer:(ccTime)dt
{
    [self wineAtSpeed:gameDataInGame.wineSpeed];
}
#pragma mark levelHelper
-(void)cropImage:(NSString*)image WithSize:(CGRect)rectInSize atPosition:(CGPoint)oldSpritePosiiton  sizeOfOld:(CGSize)sizeOld firstOrSec:(int)minOrPlus isRotation:(int)rotation
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
    CGRect newRect=CGRectMake(rectInSize.origin.x, rectInSize.origin.y, rectInSize.size.width*multBy, rectInSize.size.height*multBy);

    if(rotation==1)
        newRect=CGRectMake(rectInSize.origin.x, rectInSize.origin.y, rectInSize.size.width*multBy, rectInSize.size.height*multBy);

    UIImage *orginalImg=[UIImage imageNamed:image];
    CGImageRef imageRef = CGImageCreateWithImageInRect([orginalImg CGImage], newRect);
    CCTexture2D *tex=[[CCTexture2D alloc] initWithCGImage:imageRef resolutionType:kCCResolutionUnknown];
    CCSprite *sprite = [CCSprite spriteWithTexture:tex];
    [self addChild:sprite z:1200];
    float xVaule=oldSpritePosiiton.x-(sizeOld.width/2)+sprite.boundingBox.size.width;
    if (xVaule<0)
        xVaule*=-1;
    if(minOrPlus==0)
        [sprite setPosition:CGPointMake(xVaule,100)];
    else
        [sprite setPosition:CGPointMake(oldSpritePosiiton.x-(sizeOld.width- sprite.boundingBox.size.width), oldSpritePosiiton.y)];
    CGImageRelease(imageRef);
    int lenght=50;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        lenght=100;
    [sprite runAction:[CCJumpTo actionWithDuration:1 position:CGPointMake((sprite.position.x-(sprite.boundingBox.size.width))+lenght, -ScreenSize.height/2) height:200 jumps:1]];

}
-(void)cropImageSec:(NSString*)image WithSize:(CGRect)rectInSize atPosition:(CGPoint)oldSpritePosiiton  sizeOfOld:(CGSize)sizeOld firstOrSec:(int)minOrPlus isRotation:(int)roation
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
    CGRect visibleRect1= CGRectMake(rectInSize.size.width*multBy, rectInSize.origin.y*multBy, multBy*(sizeOld.width-rectInSize.size.width), multBy*rectInSize.size.height);
    if(roation==1)
        visibleRect1= CGRectMake(rectInSize.origin.x*multBy, rectInSize.size.height*multBy,  multBy*rectInSize.size.width, multBy*( sizeOld.height-rectInSize.size.height));

    
    CGImageRef secondPart=CGImageCreateWithImageInRect([orginalImg CGImage],visibleRect1 );
    CCTexture2D *texSce=[[CCTexture2D alloc] initWithCGImage:secondPart resolutionType:kCCResolutionUnknown];
    CCSprite *spritetexSce = [CCSprite spriteWithTexture:texSce];
    [self addChild:spritetexSce z:1200];
    float xVaule=oldSpritePosiiton.x+(sizeOld.width/2)-spritetexSce.boundingBox.size.width;
    [spritetexSce setPosition:CGPointMake(xVaule, oldSpritePosiiton.y)];
    CGImageRelease(secondPart);
    int lenght=50,height=200;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lenght=100;
    }
    if(roation==1)
    {
        height=0;
        lenght=0;
    }

    [spritetexSce runAction:[CCJumpTo actionWithDuration:1 position:CGPointMake((spritetexSce.position.x+(spritetexSce.boundingBox.size.width))+lenght, -ScreenSize.height/2) height:height jumps:1]];
    [self playSound:11];
                             
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
    float yVaule=minOrPlus-spritetexSce.boundingBox.size.height/2;
    

    [spritetexSce setPosition:CGPointMake(oldSpritePosiiton.x,yVaule)];
    CGImageRelease(secondPart);
    int lenght=50;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        lenght=100;
    [spritetexSce setColor:ccc3(64, 41, 7)];
    [spritetexSce runAction:[CCFadeOut actionWithDuration:1.50]];
    [spritetexSce setPosition:CGPointMake(oldSpritePosiiton.x,yVaule)];

}
-(void) removeWine:(id)sender data:(CCSprite*)wineToHide
{
    [wineToHide setVisible:FALSE];
    [wineToHide setTag:tagForRemove];
    [wineToHide removeFromParentAndCleanup:YES];
    
}
-(id) init
{
	if( (self=[super init]))
    {
        ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        [self InitialSpriteLoad];
        CCSprite *frog=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greenfrog1.png"]];
        [frog setPosition:CGPointMake(-160, 10)];
        [self addChild:frog z:200];
        [frog  setTag:tagFor_FrogInGame]; 
        
        CCSprite *frogRight=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greenfrog1.png"]];
        [frogRight setPosition:CGPointMake(ScreenSize.width+160, 10)];
        [self addChild:frogRight z:200];
        [frogRight  setTag:tagFor_FrogInRight]; 
        [frogRight setFlipX:TRUE];
        [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        gameDataInGame=[GameData gameDataInitial];
        [self DisplayGamePage];
        [self schedule:@selector(wineAppearTimmer :)     interval:gameDataInGame.wineRandomInterval];
        [self schedule:@selector(snakeAppearTimmer:)     interval:gameDataInGame.snakeRandomInterval];
        [self schedule:@selector(frogAppearTimmer :)     interval:gameDataInGame.FrogRandomInterval];

        frogOnTheWine=0,lastWineUp=0,wineOnWhich=1,leftFrogColor=0,isWinStatus=0,isPauseStatus=0,wineOnRightWhich=5,frogOnTheRightWine=0;
        xValueRight=ScreenSize.width,yValueRight=ScreenSize.height;
    }
    return self;
}
-(NSString*)callSnakeNameForCut:(CCSprite*)frogRight
{
    NSString *frogWine;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1024 )
    {
        frogWine=@"snake1-ipad.png";
        if(frogRight.rotationX==90.0&&frogRight.flipX)
            frogWine=@"snake1_Up-ipad.png";
        else  if(frogRight.rotationX==90.0&&!frogRight.flipX)
            frogWine=@"snake1_down-ipad.png";
        else if(frogRight.flipX)
            frogWine=@"snake1_Left-ipad.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==2048 )
    {
        frogWine=@"snake1-ipadhd.png";
        if(frogRight.rotationX==90.0&&frogRight.flipX)
            frogWine=@"snake1_Up-ipadhd.png";
        else  if(frogRight.rotationX==90.0&&!frogRight.flipX)
            frogWine=@"snake1_down-ipadhd.png";
        else if(frogRight.flipX)
            frogWine=@"snake1_Left-ipadhd.png";
        
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==480 )
    {
        frogWine=@"snake1.png";
        if(frogRight.rotationX==90.0&&frogRight.flipX)
            frogWine=@"snake1_Up";
        else  if(frogRight.rotationX==90.0&&!frogRight.flipX)
            frogWine=@"snake1_down.png";
        else if(frogRight.flipX)
            frogWine=@"snake1_Left.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==960 )
    {
        frogWine=@"snake1-hd.png";
        if(frogRight.rotationX==90.0&&frogRight.flipX)
            frogWine=@"snake1_Up-hd.png";
        else  if(frogRight.rotationX==90.0&&!frogRight.flipX)
            frogWine=@"snake1_down-hd.png";
        else if(frogRight.flipX)
            frogWine=@"snake1_Left-hd.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1136 )
    {
        frogWine=@"snake1-hd.png";
        if(frogRight.rotationX==90.0&&frogRight.flipX)
            frogWine=@"snake1_Up-hd.png";
        else  if(frogRight.rotationX==90.0&&!frogRight.flipX)
            frogWine=@"snake1_down-hd.png";
        else if(frogRight.flipX)
            frogWine=@"snake1_Left-hd.png";
    }
   return frogWine;
}
#pragma mark Touch Functions For Normal
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    locationBegin=location;
    CCSprite *frog =(CCSprite*)[self getChildByTag:tagFor_FrogInGame];//+700
    if (CGRectContainsPoint(frog.boundingBox, location)) //I think that is the method you need. It's something like that.
    {
        [self callBloodSplash:frog];
        NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInGame;
        id actiondelay= [CCDelayTime actionWithDuration:1];

        id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];
        [frog runAction: [CCSequence actions:actiondelay ,actionMove1, nil]];
        [self playSound:7];
        [self removeLifeAt];
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:wineOnWhich+600-1];//tag intVar1
        NSInteger *sendInt=(NSInteger*)(wineOnWhich+600-1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];
        
        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                           [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                           action2,actionMove4, nil];
        [winetoStart runAction:seq];
        
        wineOnWhich=1;
        leftFrogColor=0;
        frogOnTheWine=0;
        xValue=0;
        yValue=0;
        
    }
    
    CCSprite *frogRight =(CCSprite*)[self getChildByTag:tagFor_FrogInRight];
    if (CGRectContainsPoint(frogRight.boundingBox, location)) 
    {
        
        [self callBloodSplash:frogRight];
        NSInteger *sendIntFrog=(NSInteger*)tagFor_FrogInRight;
        id actionMove1 = [CCCallFuncND actionWithTarget:self selector:@selector(reSetFrog:data:) data:sendIntFrog];
        [frog runAction:actionMove1];
        [self removeLifeAt];
        
        CCSprite *winetoStart=(CCSprite*)[self getChildByTag:wineOnWhich+600-1];
        NSInteger *sendInt=(NSInteger*)(wineOnWhich+600-1);
        id action2  =   [CCCallFunc actionWithTarget:self selector:@selector(stopWineSound)];
        
        id actionMove4  = [CCCallFuncND actionWithTarget:self selector:@selector(ERestore:data:) data:sendInt];
        CCSequence *seq = [CCSequence actions:
                           [CCMoveTo actionWithDuration:(ScreenSize.height/90)*gameDataInGame.wineSpeed position:CGPointMake(winetoStart.position.x, ScreenSize.height/2)],
                           action2,actionMove4, nil];
        [winetoStart runAction:seq];
        wineOnRightWhich    =5;
        rightFrogColor      =0;
        frogOnTheRightWine  =0;
        xValueRight=ScreenSize.width,yValueRight=ScreenSize.height;
    }
    return TRUE;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
{
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    NSString *strForWine,*frogWine;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1024 )
    {
        strForWine=@"wine-ipad.png";
        frogWine=@"snake1-ipad.png";
    }
    else   if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==2048 )
    {
        strForWine=@"wine-ipadhd.png";
        frogWine=@"snake1-ipadhd.png";

    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==480 )
    {
        frogWine=@"snake1.png";
        strForWine=@"wine.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==960 )
    {
        frogWine=@"snake1-hd.png";
        strForWine=@"wine-hd.png";
    }
    else  if([[[NSUserDefaults standardUserDefaults]valueForKey:@"widthOfDevice"]integerValue]==1136 )
    {
        frogWine=@"snake1-hd.png";
        strForWine=@"wine-hd.png";
    }
    
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    CCSprite *frogRight =(CCSprite*)[self getChildByTag:1199];
    if (CGRectContainsPoint(frogRight.boundingBox, location)) 
    {
        float xxx=frogRight.boundingBox.size.width;
        frogWine=[self callSnakeNameForCut:frogRight];
        [scoreOnTop setString:[NSString stringWithFormat:@"%d",[scoreOnTop.string integerValue]+50]];
        CGPoint ToPoint=frogRight.position;
        int value=0;
        if (location.x>frogRight.position.x)
        {
            xxx =(frogRight.boundingBox.size.width/2)+(location.x - frogRight.position.x);
            ToPoint=CGPointMake(frogRight.position.x-(location.x-frogRight.position.x), frogRight.position.y);
            value=1;
        }
        else
        {
            xxx =(frogRight.boundingBox.size.width/2)-(frogRight.position.x - location.x);
            ToPoint=CGPointMake(frogRight.position.x-(frogRight.position.x-location.x), frogRight.position.y);
        }
        [frogRight stopAllActions];
        CGRect visibleRect;
        visibleRect= CGRectMake(0 , 0, xxx , frogRight.boundingBox.size.height );
       
        float YYY=frogRight.boundingBox.size.width;
        int roation=0;
        if(frogRight.rotationX==90.0)
        {   
            if (location.y>frogRight.position.y)
                YYY =(frogRight.boundingBox.size.height/2)-(location.y - frogRight.position.y);
            else
                YYY =(frogRight.boundingBox.size.height/2)+(frogRight.position.y - location.y);
        
            roation=1;
            visibleRect= CGRectMake(0 , 0,   frogRight.boundingBox.size.width,YYY );
        }
        [self cropImage:frogWine WithSize:visibleRect atPosition:frogRight.position sizeOfOld:frogRight.boundingBox.size firstOrSec:1 isRotation:roation];
        [self cropImageSec:frogWine WithSize:visibleRect atPosition:frogRight.position sizeOfOld:frogRight.boundingBox.size firstOrSec:1 isRotation:roation];
        [self callBloodSplash:frogRight];
        [self playSound:8];
        snakeIsMoving=0;
        [frogRight setTag:tagForRemove];
    }
   
   
    for (int i=1; i<5; i++)
    {
    CCSprite *wineForSprite =(CCSprite*)[self getChildByTag:600+i];
    if (CGRectContainsPoint(wineForSprite.boundingBox, location)) 
    {
        switch (i)
        {
            case 1:
                gameDataInGame.wineFirst=0;
                break;
            case 2:
                gameDataInGame.wineSec=0;
                break;
            case 3:
                gameDataInGame.wineThrid=0;
                break;
            case 4:
                gameDataInGame.wineFouth=0;
                break;
            default:
                break;
        }

        if(frogOnTheWine==i)
        {
            [self removeLifeAt];
            [self frogFellDown];
        }
        else if (frogOnTheRightWine==i)
        {
            [self removeLifeAt];
            [self rightFrogFellDown];
        }
        else
        {
            [scoreOnTop setString:[NSString stringWithFormat:@"%d",[scoreOnTop.string integerValue]+10]];

        }

        float YYY=wineForSprite.boundingBox.size.width;
        if (location.y>wineForSprite.position.y)
            YYY =(wineForSprite.boundingBox.size.height/2)-(location.y - wineForSprite.position.y);
        else
            YYY =(wineForSprite.boundingBox.size.height/2)+(wineForSprite.position.y - location.y);
        [wineForSprite stopAllActions];
        CGRect visibleRect= CGRectMake(0 , 0,   wineForSprite.boundingBox.size.width,YYY );
        [self cropWineImage:strForWine WithSize:visibleRect atPosition:wineForSprite.position sizeOfOld:wineForSprite.boundingBox.size firstOrSec:location.y];
        [self cropImageWieSec:strForWine WithSize:visibleRect atPosition:wineForSprite.position sizeOfOld:wineForSprite.boundingBox.size firstOrSec:location.y];
        [wineForSprite setVisible:FALSE];
        [self playSound:2];
        [wineForSprite setTag:tagForRemove];
    }
    }
    
}
@end
