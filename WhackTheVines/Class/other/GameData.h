//
//  GameData.h
//  WhackTheVines
//
//  Created by Ether IT Solutions on 22/04/13.
//  Copyright (c) 2013 Ether IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
{
    NSMutableArray *FrogPositionArray;
    NSMutableArray *WinePositionArray;

    float wineFirst;
    float wineSec;
    float wineThrid;
    float wineFouth;
    float wine1;

    float wineSpeed;
    int   FrogRandomInterval;
    int   wineRandomInterval;
    int   snakeRandomInterval;

}
@property (strong,nonatomic)    NSMutableArray *FrogPositionArray;
@property (strong,nonatomic)    NSMutableArray *WinePositionArray;

@property(nonatomic,assign)     int     snakeRandomInterval;
@property(nonatomic,assign)     int     wineRandomInterval;
@property(nonatomic,assign)     int     FrogRandomInterval;
@property(nonatomic,assign)     float   wineFirst;
@property(nonatomic,assign)     float   wineSec;
@property(nonatomic,assign)     float   wineThrid;
@property(nonatomic,assign)     float   wineFouth;
@property(nonatomic,assign)     float   wineSpeed;
@property(nonatomic,assign)     float   wine1;


+(id)gameDataInitial;
@end
