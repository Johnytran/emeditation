//
//  RecommendModalViewController.m
//  emeditation
//
//  Created by admin on 24/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "RecommendModalViewController.h"

@interface RecommendModalViewController ()

@end

@implementation RecommendModalViewController
@synthesize contentView, waveSongImageView, recommendTableView, songData, dbRef, parentIndex, expandRow, doneButton, historySession;

- (void)viewDidAppear:(BOOL)animated{
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    self.doneButton.layer.cornerRadius = 15;
    [self.doneButton.layer setBorderWidth: 1.0];
    [self.doneButton.layer setBorderColor: [[UIColor colorWithRed:0.58 green:0.10 blue:0.58 alpha:1.0] CGColor] ];
    
    [self.doneButton.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.doneButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.doneButton.layer setShadowOpacity:0.5];
    
    
    
    
    self.expandRow = NO;
    
    self.recommendTableView.delegate = self;
    self.recommendTableView.dataSource = self;
    
    self.dbRef = [[FIRDatabase database] reference];
    
    UIGraphicsBeginImageContext(self.waveSongImageView.frame.size);
    [[UIImage imageNamed:@"wave_song.png"] drawInRect:self.waveSongImageView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.waveSongImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    
   self.historySession = [[NSMutableDictionary alloc] init];
    
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
        
        //NSLog(@"probabilities: %@", [aSong songScore]);
        
        
        
        [self.recommendTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
}

- (void)stopAllCell: (NSIndexPath*)exceptIndex{
    
    if([self.songData count]>0){
        for(int i=0;i<[self.songData count]; i++){
            NSIndexPath *aIndex = [NSIndexPath indexPathForRow:i inSection:0];
            RecomendRowTableViewCell *aCell = [self.recommendTableView cellForRowAtIndexPath:aIndex];
            [aCell.playButton setImage:[UIImage imageNamed:@"btn_play_recommend"] forState:(UIControlState)UIControlStateNormal];
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
            RecomendRowTableViewCell *aCell = [self.recommendTableView cellForRowAtIndexPath:aIndex];
            [aCell.playButton setImage:[UIImage imageNamed:@"btn_play_recommend"] forState:(UIControlState)UIControlStateNormal];
            aCell.beingPlay = NO;
        }
    }
}

-(void)fadeOutAllTool{
    [self.player stop];
    if([self.songData count]){
        for(int i=0; i<[self.songData count]; i++){
            NSIndexPath *aIndex = [NSIndexPath indexPathForRow:i inSection:0];
            RecomendRowTableViewCell *cell = [self.recommendTableView cellForRowAtIndexPath:aIndex];
            cell.toolView.layer.opacity = 0;
            if(self.parentIndex!=aIndex)
                cell.isExpaned = NO;
        }
    }
    
}

- (void) PlayMusic: (NSString*) urlString{
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath==self.parentIndex && self.expandRow){
        return 100;
    }else{
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.songData count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"songCell";
    [self.recommendTableView registerNib:[UINib nibWithNibName:@"RecomendRowTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    RecomendRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    Song *aSong = [self.songData objectAtIndex:indexPath.row];
    
    
    // display artist label
    if(![[aSong artistID] isEqualToString:@""]){
        // get artist by ID
        FIRDatabaseQuery *singleArtistQuery = [[[self.dbRef child:@"artist"] queryOrderedByChild:@"id"] queryEqualToValue:[aSong artistID]];
        [singleArtistQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
            
            NSString *artistName = [snapshot.value objectForKey:@"name"];
            [cell.artistLabel setText:artistName];
        }];
    }
    if((indexPath.row+1)<10){
        [cell.rankLabel setText:[NSString stringWithFormat:@"0%ld", (long)(indexPath.row+1)]];
    }else{
        [cell.rankLabel setText:[NSString stringWithFormat:@"%ld", (long)(indexPath.row+1)]];
    }
    [cell.songNameLabel setText:[aSong songName]];
    //[cell.artistLabel setText:[aSong ar]]
    [cell.durationLabel setText:[aSong duration]];
    cell.currentIndex = indexPath;
    cell.currentSong = aSong;
    cell.parentView = self;
    
    // change selected row background
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.62 green:0.09 blue:0.65 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void) showView: (UIView *) parentView withFrame: (CGRect) frame{
    
    [self.view setFrame: frame];
    [parentView addSubview:self.view];
    [self showAnimate];
}

- (IBAction)closeRecommend:(id)sender {
    [self.player stop];
    [self removeAnimate];
}

@end
