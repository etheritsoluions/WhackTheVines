//
//  GameData.m
//  WhackTheVines
//
//  Created by Ether IT Solutions on 22/04/13.
//  Copyright (c) 2013 Ether IT Solutions. All rights reserved.
//

#import "GameData.h"
static GameData *gameDataObject=nil;

@implementation GameData
@synthesize FrogPositionArray,wineFirst,wineSec,wineFouth,wineThrid,WinePositionArray,wineSpeed,FrogRandomInterval,wineRandomInterval,snakeRandomInterval,wine1;
+(id)gameDataInitial
{
    @synchronized(self)
    {
        if(gameDataObject == nil)
            gameDataObject = [[super allocWithZone:NULL] init];
    }
    
    return gameDataObject;
}
- (id)init
{
    if ((self = [super init]))
    {

        FrogPositionArray=[[NSMutableArray alloc]init];
        WinePositionArray=[[NSMutableArray alloc]init];
        wineFirst=0;
        wineSec=0;
        wineThrid=0;
        wineFouth=0;
        wineSpeed=5;
        FrogRandomInterval=10;
        wineRandomInterval=3;
        snakeRandomInterval=3;
        wine1=0;
    }
    return self;
}

@end
