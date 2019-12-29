//
//  StartSessionViewController.h
//  emeditation
//
//  Created by admin on 5/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import "ToastViewController.h"
#import "GetURLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartSessionViewController : UIViewController

@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)playSession:(id)sender;
- (IBAction)stopSession:(id)sender;

@property BOOL isPlayed;
@property int secondsLeft;
@property int secondsDone;

@property NSTimer *timeOfSession;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@property (strong, nonatomic) NSMutableDictionary *myProfile;

@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@property AppDelegate *appDelegate;
@property (strong, nonatomic) ToastViewController *refModalController;

@property (nonatomic) NSString * documentsDirectoryPath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *writablePath;
@property (nonatomic) NSString *theFileName;
@property (nonatomic) NSString *csvEmotionURL;

@property (strong, nonatomic) GetURLViewController *refCSVModalController;

@property (weak, nonatomic) IBOutlet UIButton *ProcessMeditation;
- (IBAction)ProcessAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
