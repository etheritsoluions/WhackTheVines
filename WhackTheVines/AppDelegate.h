//
//  AppDelegate.h
//  WhackTheVines
//
//  Created by Ether IT Solutions on 04/04/13.
//  Copyright Ether IT Solutions 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
extern NSString *const FBSessionStateChangedNotification;

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
//http://www.learn-cocos2d.com/2012/11/optimize-memory-usage-bundle-size-cocos2d-app/


/*
 
 • Button Clicked: Button Switch                                            Button_switch.wav
 • Growing Vine: Delete Button Sounds (looped)                              DeleteButtonSound.wav
 • Whack Vines: Ultimate Button Sound 13                                    UBC1_Sound13.wav
 • Missed Vines: Cancel Button 1                                            cancelbutton.wav
 • Adding an X (opportunity): Wrong Answer Alarm Buzzer                     simpleWin.wav           (simpleWin&Notif_2_snd_1) we think
 • Removing an X (opportunity): Simple Winning & Notification Sound (#1)    WrongAnswerAlarmBuzzer.wav                         we think
 • Snake: Siren Song Spell (looped)                                         SirenSong.wav
 • Whack Snake: Sticky Tongue                                               dinobugtongue2.wav
 • Frog: Frog Button Sound
 • Frog Scream: Man Scream Sounds 9 (#3)                                    Man_scream_2.wav
 • Game Over Explosion: Explosion                                           explosion.wav
 • Killing a Snake: Beep Button 2
 • Score Counting Up: Beep Button 2 (looped)
 • High Score Reached: Winning Trumpet                                      WinningTrumpet.mp3
 
 ////
 
 
 • Splash Screen: Dragged to Hell (looped)                                  splashScreen.mp3                    (Dragged_to_Hell.mp3
 • Game Background: ADG3_culturePack 1: The Serpent  -                      backGround.wav                      (adg3.com_theSerpent.wav)
 
 */

//// - (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err    need to chaeck
