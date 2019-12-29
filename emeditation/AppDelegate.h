//
//  AppDelegate.h
//  emeditation
//
//  Created by admin on 15/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <CoreData/CoreData.h>
#import "MeditationTabBarController.h"
#import "ViewController.h"

@import Firebase;
@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property int delegateWeakTime;
@property (strong, nonatomic) NSMutableDictionary *myProfile;
@property (strong, nonatomic) NSString *urlCSVFile;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;

@end

