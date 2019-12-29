//
//  FavoriteSongTableViewCell.h
//  emeditation
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteMusicViewController.h"
#import "Song.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteSongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property NSIndexPath *indexPath;
@property UITabBarController *parentTabController;

@property (strong, nonatomic) Song *currentSong;
@property (strong, nonatomic) UIViewController *parentController;

@property BOOL beingPlay;
@property BOOL isPlayed;

- (IBAction)doMeditate:(id)sender;
- (IBAction)listenTrial:(id)sender;


@end

NS_ASSUME_NONNULL_END
