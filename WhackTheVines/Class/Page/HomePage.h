//
//  HomePage.h
//  WhackTheVines
//
//  Created by Ether IT Solutions on 18/04/13.
//  Copyright 2013 Ether IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"


@class GameCenterManager;
@interface HomePage : CCNode <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate> 
{
    GameCenterManager *gameCenterManager;

}
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

@end
