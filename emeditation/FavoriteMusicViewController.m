//
//  FavoriteMusicViewController.m
//  emeditation
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "FavoriteMusicViewController.h"

@interface FavoriteMusicViewController ()

@end

@implementation FavoriteMusicViewController
@synthesize tableview, songData, heightContentView, player;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.layer.cornerRadius = 20;
    self.dbRef = [[FIRDatabase database] reference];
    
    // set dynamic height constraint
    CGFloat heightScreen = self.view.frame.size.height;
    if(heightScreen>600){
        self.heightContentView.constant = 800;
    }
    
    if(heightScreen>800){
        self.heightContentView.constant = 700;
    }
    if(heightScreen>1000){
        self.heightContentView.constant = 900;
    }
    
    //initial song array
    self.songData = [[NSMutableArray alloc] init];
    
    FIRDatabaseQuery *userHistory = [self.dbRef child:[NSString stringWithFormat:@"history/%@",[FIRAuth auth].currentUser.uid]];
    
    [userHistory observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull userHistorySnapshot) {
        
        //NSLog(@"test %@",userHistorySnapshot.key);
        float sum = 0;
        float avgScore = 0;
        for ( FIRDataSnapshot *child in userHistorySnapshot.children) {
            NSString *probabilities = [child.value objectForKey:@"probabilities"];
            float floatScore = [probabilities floatValue];
            sum += floatScore;
            //NSLog(@"probabilities = %@",probabilities);
            
        }
        //        NSLog(@"sum = %f",sum);
        //        NSLog(@"count = %lu",(unsigned long)userHistorySnapshot.childrenCount);
        avgScore = sum/userHistorySnapshot.childrenCount;
        //NSLog(@"avgScore = %f",avgScore);
        
        [self GetSongByID:userHistorySnapshot.key and:[NSString stringWithFormat:@"%f", avgScore]];
        
    }];
    
}
-(void)GetSongByID:(NSString*)songID and: (NSString*)score{
    // get Song by ID
    FIRDatabaseQuery *singleSongQuery = [[[self.dbRef child:@"song"] queryOrderedByChild:@"id"] queryEqualToValue:songID];
    [singleSongQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        
        //NSLog(@"probabilities: %@", score);
        NSString *songID = [snapshot.value objectForKey:@"id"];
        NSString *songName = [snapshot.value objectForKey:@"name"];
        NSString *songLink = [snapshot.value objectForKey:@"link"];
        NSString *artistID = [snapshot.value objectForKey:@"artistID"];
        NSString *duration = [snapshot.value objectForKey:@"duration"];
        
        //NSLog(@"songlink: %@", songLink);
        
        Song *aSong = [[Song alloc] init];
        [aSong setSongID:songID];
        [aSong setSongName:songName];
        [aSong setSongLink:songLink];
        [aSong setArtistID:artistID];
        [aSong setDuration:duration];
        
        if(score.length > 0){
            NSNumber *num = @([score floatValue]); // convert to nsnumber
            [aSong setSongScore:num];
        }else{
            [aSong setSongScore:[NSNumber numberWithFloat:0]];
        }
        
        
        // add this song to array list
        [self.songData addObject:aSong];
        
        // sort array desc
        NSSortDescriptor *sortDESC = [[NSSortDescriptor alloc] initWithKey:@"songScore" ascending:NO];
        self.songData = [NSMutableArray arrayWithArray:[self.songData sortedArrayUsingDescriptors:@[sortDESC]]];
        
        NSLog(@"probabilities: %@", [aSong songScore]);
        
        
        
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
}
- (void)stopAllCell: (NSIndexPath*)exceptIndex{
    if([self.songData count]>0){
        for(int i=0;i<[self.songData count]; i++){
            NSIndexPath *aIndex = [NSIndexPath indexPathForRow:i inSection:0];
            FavoriteSongTableViewCell *aCell = (FavoriteSongTableViewCell *)[self.tableview cellForRowAtIndexPath:aIndex];
            [aCell.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
            aCell.beingPlay = NO;
            if(i!=exceptIndex.row){
                aCell.isPlayed = NO;
            }
        }
    }
}
- (void)stopAllCellNonExcep{
    if([self.songData count]>0){
        for(int i=0;i<[self.songData count]; i++){
            NSIndexPath *aIndex = [NSIndexPath indexPathForRow:i inSection:0];
            FavoriteSongTableViewCell *aCell = (FavoriteSongTableViewCell *)[self.tableview cellForRowAtIndexPath:aIndex];
            [aCell.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
            aCell.beingPlay = NO;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.songData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"songCell";
    [self.tableview registerNib:[UINib nibWithNibName:@"FavoriteSongTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    FavoriteSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    Song *aSong = [self.songData objectAtIndex:indexPath.row];
    
    if(aSong!=nil){
        [cell.songTitle setText:[aSong songName]];
        cell.currentSong = aSong;
        cell.parentController = self;
        [cell setIndexPath:indexPath];
        [cell setParentTabController:self.tabBarController];
        float score = 0;
        if([aSong songScore]!=nil)
            score = [[aSong songScore] floatValue];
        
        [cell.scoreLabel setText:[NSString stringWithFormat:@"Score: %.1f %%", score*100]];
        [cell.durationLabel setText:[aSong duration]];
        // change selected row background
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    }
    return cell;
    
}

- (void) PlayMusic: (NSString*) urlString{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
             error:&setCategoryError]) {
        // handle error
    }
    
    _documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _theFileName = [[urlString lastPathComponent] stringByDeletingPathExtension];
    
    _fileManager = [NSFileManager defaultManager];
    _writablePath = [_documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", _theFileName]];
    
    if(![_fileManager fileExistsAtPath:_writablePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //save Image From URL
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
    }
    else{
        // file exist
        NSLog(@"file exist");
        
        NSURL *soundUrl = [NSURL fileURLWithPath:_writablePath isDirectory:NO];
        NSData *localData = [NSData dataWithContentsOfURL:soundUrl];
        self.player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
        
    }
    
    
}

@end
