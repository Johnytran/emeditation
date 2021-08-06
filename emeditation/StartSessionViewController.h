//
//  StartSessionViewController.h
//  emeditation
//
//  Created by admin on 5/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalBoxViewController.h"
#import "ModalCompleteViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import "ToastViewController.h"

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
@property int isLike;

@property NSTimer *timeOfSession;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
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
- (void)processRecommend;

@end

NS_ASSUME_NONNULL_END
