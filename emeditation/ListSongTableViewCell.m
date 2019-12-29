//
//  ListSongTableViewCell.m
//  emeditation
//
//  Created by admin on 16/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ListSongTableViewCell.h"

@implementation ListSongTableViewCell
@synthesize parentController, playButton, meditationButton, currentSong, loadingImageView, indexPath, parentTabController, beingPlay, isSubPlayed;
- (void)awakeFromNib {
    [super awakeFromNib];
    // loading animation image for waiting song
    FLAnimatedImage *loadingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading_buffer" ofType:@"gif"]]];
    
    self.loadingImageView.animatedImage = loadingImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) getParentController: (MusicViewController*) parent{
    self.parentController = parent;
    
}
- (void)resetPlay{
    // turn off play sign
    [UIView animateWithDuration:.25 animations:^{
        self.loadingImageView.alpha = 0;
        [self.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
    }];
}
- (void)PlayNewMusic{
    
    MusicViewController *parent = (MusicViewController*)self.parentController;
    
    [parent stopAllCell:indexPath];
    
    // update index song in the list for parent
    [parent setIndexPlaying:self.indexPath];
    [parent setLoadingImageSubView:self.loadingImageView];
    // store current button to parent controller
    [parent setSelectedPlayButton: self.playButton];
    
    [parent PlayMusic:[self.currentSong songLink]];
}
- (IBAction)quickListen:(id)sender {
    MusicViewController *parent = (MusicViewController*)self.parentController;
    
    // store current button to parent controller
    [parent setSelectedPlayButton: self.playButton];
    [parent setLoadingImageSubView: self.loadingImageView];
    [parent stopAllCell:indexPath];
    
    
    if(self.isSubPlayed){
        
        //stop loading iamge
        [UIView animateWithDuration:.25 animations:^{
            self.loadingImageView.alpha = 0;
        }];
        
        [[parent player] pause];
        
        [[parent playMainButton] setImage:[UIImage imageNamed:@"play_music"] forState:(UIControlState)UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
        [parent setIsPlayed:NO];
        self.isSubPlayed = NO;
        beingPlay = YES;
    }else{
        
        if(!beingPlay){
            [parent setIndexPlaying:self.indexPath];
            [parent PlayMusic:[self.currentSong songLink]];
            beingPlay = YES;
        }else{
            [[parent player] play];
            self.loadingImageView.alpha = 1;
            [[parent playMainButton] setImage:[UIImage imageNamed:@"pause_music"] forState:(UIControlState)UIControlStateNormal];
            [self.playButton setImage:[UIImage imageNamed:@"pause_trial"] forState:(UIControlState)UIControlStateNormal];
        }
        self.isSubPlayed = YES;
        [parent setIsPlayed:YES];
    }
    
}

- (IBAction)chooseThis:(id)sender {
    int index = 1; // home view controller
    self.parentTabController.selectedIndex = index;
    
    MusicViewController *parent = (MusicViewController*)self.parentController;
    [[parent player] stop];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *myProfile = delegate.myProfile;
    [myProfile setObject:self.currentSong forKey:@"song"];
   
    [self.parentTabController.viewControllers[index] popToRootViewControllerAnimated:YES];
    
}
@end
