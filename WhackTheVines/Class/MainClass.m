//
//  MainClass.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 04/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import "MainClass.h"
#import "HomePage.h"
#import "GamePlay.h"
#import "GameOver.h"
#import "PausePage.h"

@implementation MainClass
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainClass *layer = [MainClass node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
#pragma mark - call Game 
-(void)loadGameNode
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    
    CCLOG(@"%@<applicationDidReceiveMemoryWarning> : after purge", self.class);
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    [self addChild:[GamePlay node]];

}
-(void)callPause
{
    [self addChild:[PausePage node]];

}
-(void)callGameOverInMain
{
    [self addChild:[GameOver node]];

}
-(void)callHome
{
    [self addChild:[HomePage node]];

}
-(id) init
{
	if( (self=[super init]))
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"RestartGame"]integerValue]==0)
            [self callHome];
        else
            [self loadGameNode];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RestartGame"];

    }
    return self;
    
}

@end
