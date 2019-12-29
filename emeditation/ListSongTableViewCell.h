//
//  ListSongTableViewCell.h
//  emeditation
//
//  Created by admin on 16/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "MusicViewController.h"
#import "FLAnimatedImage.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListSongTableViewCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet UILabel *duration;
- (IBAction)quickListen:(id)sender;
- (IBAction)chooseThis:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *meditationButton;
-(void)getParentController: (UIViewController*) parent;
@property UIViewController *parentController;
@property NSIndexPath *indexPath;
@property UITabBarController *parentTabController;
- (void)PlayNewMusic;
- (void)resetPlay;
@property (strong, nonatomic) Song *currentSong;
@property BOOL isSubPlayed;
@property BOOL beingPlay;
@end

NS_ASSUME_NONNULL_END
