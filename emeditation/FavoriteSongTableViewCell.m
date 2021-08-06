//
//  FavoriteSongTableViewCell.m
//  emeditation
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "FavoriteSongTableViewCell.h"

@implementation FavoriteSongTableViewCell
@synthesize songTitle, playButton, isPlayed, currentSong, parentController, scoreLabel, beingPlay, indexPath, parentTabController, durationLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.isPlayed = NO;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doMeditate:(id)sender {
    int index = 1; // home view controller
    self.parentTabController.selectedIndex = index;
    
    FavoriteMusicViewController *parent = (FavoriteMusicViewController *)self.parentController;
    [parent stopAllCellNonExcep];
    [[parent player] stop];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *myProfile = delegate.myProfile;
    [myProfile setObject:self.currentSong forKey:@"song"];
    [self.parentTabController.viewControllers[index] popToRootViewControllerAnimated:YES];
}



- (IBAction)listenTrial:(id)sender {
    FavoriteMusicViewController *parent = (FavoriteMusicViewController *)self.parentController;
    if(self.isPlayed){
        self.isPlayed = NO;
        [self.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:UIControlStateNormal];
        [parent.player pause];
        
        
    }else{
        if(!self.beingPlay){
            if(self.currentSong!=nil){
                if(![[self.currentSong songLink] isEqual:@""]){
                    [parent stopAllCell:indexPath];
                    [parent PlayMusic:[self.currentSong songLink]];
                    [parent.player play];
                    self.beingPlay = YES;
                }
            }
        }else{
            [parent.player play];
        }
        self.isPlayed = YES;
        [self.playButton setImage:[UIImage imageNamed:@"pause_trial"] forState:UIControlStateNormal];
    }
    
}
@end
