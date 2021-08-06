//
//  HomeViewController.h
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalBoxViewController.h"
#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import "ToastViewController.h"
#import "ProgressModalViewController.h"
#import "RecommendModalViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "classes/Profile.h"
#import "PromptViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
- (IBAction)training:(id)sender;
- (IBAction)SetLength:(id)sender;
- (IBAction)StartSession:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *trainingButton;
@property (strong, nonatomic) ToastViewController *refToastController;
@property (strong, nonatomic) ProgressModalViewController *refProgressController;
@property (strong, nonatomic) RecommendModalViewController *refRecommendController;

@property (strong, nonatomic) UIViewController *refPromptController;
@property (strong, nonatomic) NSURLSessionDataTask *refDataSongDownload;


@property (weak, nonatomic) IBOutlet UIButton *recommendSong;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIView *performanceView;

@property (weak, nonatomic) IBOutlet UIButton *startSessionButton;

@property (weak, nonatomic) IBOutlet UILabel *sessionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionLevelLabel;

@property (strong, nonatomic) NSMutableDictionary *myProfile;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;


@property (strong, nonatomic) NSString * documentsDirectoryPath;
@property (strong, nonatomic) Profile * dbProfile;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *writablePath;
@property (strong, nonatomic) NSString *theFileName;
@property float downloadSongSize;
@property (strong, nonatomic) NSMutableData *musicData;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property BOOL isShowRecommend;
@property BOOL isFinishSave;
@property (weak, nonatomic) IBOutlet UIView *guideView;
@property (weak, nonatomic) IBOutlet UIView *coverGuideImageView;
@property (weak, nonatomic) IBOutlet UIView *toolGuideView;
@property (weak, nonatomic) IBOutlet UIButton *playGuideButton;

- (IBAction)PlayGuideMeditation:(id)sender;
- (IBAction)SkipGuide:(id)sender;
- (IBAction)OpenRecommend:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *player;
@property BOOL beingPlay;
@property BOOL isPlayed;
@property (strong, nonatomic) NSString *trainingAudioURL;

@end

NS_ASSUME_NONNULL_END
