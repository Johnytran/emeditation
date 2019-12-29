//
//  RecomendRowTableViewCell.h
//  emeditation
//
//  Created by admin on 27/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModalViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecomendRowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) UIViewController *parentView;

@property BOOL isExpaned;
@property NSIndexPath* currentIndex;
@property (strong, nonatomic) AVAudioPlayer *player;
@property BOOL beingPlay;
@property BOOL isPlayed;
@property (strong, nonatomic) Song *currentSong;


- (IBAction)makeOption:(id)sender;
- (IBAction)doMeditation:(id)sender;
- (IBAction)quickListen:(id)sender;

@end

NS_ASSUME_NONNULL_END
