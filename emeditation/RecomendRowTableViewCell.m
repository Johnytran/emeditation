//
//  RecomendRowTableViewCell.m
//  emeditation
//
//  Created by admin on 27/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "RecomendRowTableViewCell.h"

@implementation RecomendRowTableViewCell
@synthesize rankLabel, songNameLabel, artistLabel, isExpaned, durationLabel, playButton, toolView, currentIndex, parentView, beingPlay, isPlayed, currentSong;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isExpaned = NO;
    self.toolView.layer.opacity = 0;
    self.toolView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)makeOption:(id)sender {
    RecommendModalViewController *parent = (RecommendModalViewController*)self.parentView;
    parent.parentIndex = self.currentIndex;
    [parent stopAllCell:self.currentIndex];
    [parent fadeOutAllTool];
    
    [parent.recommendTableView reloadData];
    
    
    // set one
    if(self.isExpaned){
        self.isExpaned = NO;
        parent.expandRow = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.toolView.layer.opacity = 0;
        }];
        
    }else{
        self.isExpaned = YES;
        parent.expandRow = YES;
        [UIView animateWithDuration:.25 animations:^{
            self.toolView.layer.opacity = 1;
        }];
    }
    
}

- (IBAction)doMeditation:(id)sender {
    RecommendModalViewController *parent = (RecommendModalViewController*)self.parentView;
    [[parent player] stop];
    [parent stopAllCellNonExcep];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *myProfile = delegate.myProfile;
    [myProfile setObject:self.currentSong forKey:@"song"];
    [parent removeAnimate];
}

- (IBAction)quickListen:(id)sender {
    RecommendModalViewController *parent = (RecommendModalViewController*)self.parentView;
    if(self.isPlayed){
        self.isPlayed = NO;
        [self.playButton setImage:[UIImage imageNamed:@"btn_play_recommend"] forState:UIControlStateNormal];
        [parent.player pause];
        
        
    }else{
        if(!self.beingPlay){
            if(self.currentSong!=nil){
                if(![[self.currentSong songLink] isEqual:@""]){
                    [parent stopAllCell:self.currentIndex];
                    [parent PlayMusic:[self.currentSong songLink]];
                    [parent.player play];
                    self.beingPlay = YES;
                }
            }
        }else{
            [parent.player play];
        }
        self.isPlayed = YES;
        [self.playButton setImage:[UIImage imageNamed:@"btn_pause_recommend"] forState:UIControlStateNormal];
    }
}
@end
