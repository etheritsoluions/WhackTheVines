//
//  IntroLayer.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 04/04/13.
//  Copyright Ether IT Solutions 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "MainClass.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(void)callMain
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.01 scene:[MainClass scene] ]];
}
-(void)restartButtonAction:(id)sender
{
    NSLog(@"redghsdhj sgj");

}

-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *background;
        background = [CCSprite spriteWithFile:@"intro.jpg"];
		background.position = ccp(size.width/2, size.height/2);
        
        
        
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"music"]integerValue]==1&&[[[NSUserDefaults standardUserDefaults]valueForKey:@"sound"]integerValue]==1)
        {
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume=1;

        }
        else
            [SimpleAudioEngine sharedEngine].backgroundMusicVolume=0;
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"splashScreen.mp3"];

      
		// add the label as a child to this Layer
		[self addChild: background];
        
        CGPoint restartButtonPos;
        CGSize   ScreenSize                  =   [[CCDirector sharedDirector] winSize];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            restartButtonPos    =    CGPointMake(512.0, 384.0);
        
        else if(ScreenSize.width==568)
            restartButtonPos    =    CGPointMake(284.0, 160.0);
        
        else
            restartButtonPos    =    CGPointMake(240.0, 160.0);
        
        CCMenuItemSprite *restratMenuItem;
        restratMenuItem        =    [CCMenuItemSprite itemWithNormalSprite:
                                     [CCSprite  spriteWithFile:@"Icon.png"]
                                                            selectedSprite:[CCSprite  spriteWithFile:@"Icon.png"]
                                                                    target:self selector:@selector(restartButtonAction:)];
        
        CCMenu *restartButton =[CCMenu menuWithItems:restratMenuItem,nil];
        [restartButton setPosition:restartButtonPos];
      //  [self addChild:restartButton z:999];
        
        id action2= [CCCallFunc actionWithTarget:self selector:@selector(callMain)];
        id action1=[CCDelayTime actionWithDuration:0.3];
        [self runAction:[CCSequence actions:action1,action2,nil]];

        
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:25.0 scene:[HelloWorldLayer scene] ]];
}

@end
