//
//  MusicViewController.m
//  emeditation
//
//  Created by admin on 16/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "MusicViewController.h"

#ifndef kShouldPrintReachabilityFlags
#define kShouldPrintReachabilityFlags 1
#endif

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize albumCollection, listSongTableView, loadingView, songByAlbumIDArray, numberAlbumDisplay, songArtistLabel, songTitleLabel, isPlayed, playMainButton, player, selectedPlayButton, loadingImageSubView, indexPlaying, nexMusicButton, preMusicButton, percentLoadingAlbumLabel, musicData, downloadSongSize, refModalController, managedContext, arrayAlbumCoreData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // a flag for turn on music player
    self.isPlayed = NO;
    
    // set there is no song being selected
    self.indexPlaying = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    // set number album display
    self.numberAlbumDisplay = 7;
    
    // loading background animation image
    FLAnimatedImage *loadingImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading_album" ofType:@"gif"]]];
   
    self.loadingView.animatedImage = loadingImage;
    self.loadingView.layer.zPosition = 1;
    
    _albumList.type = iCarouselTypeCoverFlow2;
    
    self.albumCollection = [[NSMutableArray alloc] init];
    self.songByAlbumIDArray = [[NSMutableArray alloc] init];
    self.arrayAlbumCoreData = [[NSMutableArray alloc] init];
    [self getListAlbum];
    
}
- (void)stopAllCell: (NSIndexPath*)exceptIndex{
    if([self.songByAlbumIDArray count] >0){
        
        for(int i=0; i<[self.songByAlbumIDArray count]; i++){
            NSIndexPath *aIndex = [NSIndexPath indexPathForRow:i inSection:0];
            ListSongTableViewCell *aCell = [self.listSongTableView cellForRowAtIndexPath:aIndex];
            [aCell.playButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
            aCell.loadingImageView.alpha = 0;
            aCell.beingPlay = NO;
            if(i!=exceptIndex.row){
                aCell.isSubPlayed = NO;
            }
        }
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    self.downloadSongSize = [response expectedContentLength];
    self.musicData = [[NSMutableData alloc] init];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.musicData appendData:data];
    NSUInteger dataDownload = [self.musicData length];
    float percent = (float)dataDownload / self.downloadSongSize * 100;
//    NSLog(@"data download: %d ", (int)dataDownload);
//    NSLog(@"data size: %f ", self.downloadSongSize);
    int roundPercent = ceil(percent);
    //NSLog(@"percent: %d", roundPercent);
    [[self.refModalController dowloadingLabel] setText:[NSString stringWithFormat:@"Downloading...%d%%", roundPercent]];
    if(roundPercent==100){
        [self.refModalController removeAnimate];
        NSError *error = nil;
        
        [self.musicData writeToFile:_writablePath options:NSAtomicWrite error:&error];
        
        if (error) {
            NSLog(@"Error Writing Song : %@",error);
        }else{
            NSLog(@"Song %@ Saved SuccessFully",_theFileName);
            
            NSURL *soundUrl = [NSURL fileURLWithPath:_writablePath isDirectory:NO];
            NSData *localData = [NSData dataWithContentsOfURL:soundUrl];
            player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
            // show loading music from that row
            self.loadingImageSubView.alpha = 1;
            // change button to pause in that row
            [self.selectedPlayButton setImage:[UIImage imageNamed:@"pause_trial"] forState:(UIControlState)UIControlStateNormal];
            // change play icon to pause in main control
            [self.playMainButton setImage:[UIImage imageNamed:@"pause_music"] forState:(UIControlState)UIControlStateNormal];
            
            [player play];
            isPlayed = YES;
        }
    }
}
- (void) PlayMusic: (NSString*) urlString{
    
    if(refModalController!=nil){
        [self.refModalController removeAnimate];
    }
    
    _documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _theFileName = [[urlString lastPathComponent] stringByDeletingPathExtension];

    _fileManager = [NSFileManager defaultManager];
    _writablePath = [_documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", _theFileName]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    if(![_fileManager fileExistsAtPath:_writablePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //save Image From URL
        
        self.refModalController = [[ProgressModalViewController alloc] initWithNibName:@"ProgressModalViewController" bundle:nil];
        CGFloat widthScreen = self.view.frame.size.width;
        CGFloat heightScreen = self.view.frame.size.height;
        
        [self.refModalController showView:self.view withFrame:CGRectMake(0, heightScreen-260, widthScreen, 260)];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL: url];
        
        [dataTask resume];
    }
    else{
        // file exist
        //NSLog(@"file exist");
        
        
        
        NSURL *soundUrl = [NSURL fileURLWithPath:_writablePath isDirectory:NO];
        NSData *localData = [NSData dataWithContentsOfURL:soundUrl];
        player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
        
        // show loading music from that row
        self.loadingImageSubView.alpha = 1;
        // change button to pause in that row
        [self.selectedPlayButton setImage:[UIImage imageNamed:@"pause_trial"] forState:(UIControlState)UIControlStateNormal];
        // change play icon to pause in main control
        [self.playMainButton setImage:[UIImage imageNamed:@"pause_music"] forState:(UIControlState)UIControlStateNormal];
        
        [player prepareToPlay];
        [player play];
        isPlayed = YES;
    }

    
}


- (IBAction)nextSongPlayButton:(id)sender {
    
    int nextIndex = (int)self.indexPlaying.row;

    // enable prev button
    [self.preMusicButton setImage:[UIImage imageNamed:@"prev_music"] forState:(UIControlState)UIControlStateNormal];
    
    if(nextIndex<0){ // not selected any song yet
        self.indexPlaying = [NSIndexPath indexPathForRow:0 inSection:0];
        // get the next cell of the list
        ListSongTableViewCell *nextCell = [self.listSongTableView cellForRowAtIndexPath:self.indexPlaying];
        
        [nextCell PlayNewMusic];
        
    }else if(nextIndex<[self.songByAlbumIDArray count]-1){
        // stop the song being played
        [self stopMusic];
        
        // get the next cell of the list
        nextIndex +=1;
        self.indexPlaying = [NSIndexPath indexPathForRow:nextIndex inSection:0];
        // get the next cell of the list
        ListSongTableViewCell *nextCell = [self.listSongTableView cellForRowAtIndexPath:self.indexPlaying];
        
        [nextCell PlayNewMusic];
        if(nextIndex == [self.songByAlbumIDArray count]-1){
            
            // disable next button
            [self.nexMusicButton setImage:[UIImage imageNamed:@"next_music_off"] forState:(UIControlState)UIControlStateNormal];
        }
        
    }
    
}

- (IBAction)prevSongPlayButton:(id)sender {
    int nextIndex = (int)self.indexPlaying.row;
    //enable next button
    [self.nexMusicButton setImage:[UIImage imageNamed:@"next_music"] forState:(UIControlState)UIControlStateNormal];
    
    if(nextIndex<0){ // not selected any song yet
        self.indexPlaying = [NSIndexPath indexPathForRow:0 inSection:0];
        // get the next cell of the list
        ListSongTableViewCell *nextCell = [self.listSongTableView cellForRowAtIndexPath:self.indexPlaying];
        [nextCell PlayNewMusic];
        
        // disable prev button
        [self.preMusicButton setImage:[UIImage imageNamed:@"prev_music_off"] forState:(UIControlState)UIControlStateNormal];
        
    }
    
    if(nextIndex<[self.songByAlbumIDArray count] && nextIndex>0){
        // stop the song being played
        [self stopMusic];
        
        // get the next cell of the list
        nextIndex -=1;
        self.indexPlaying = [NSIndexPath indexPathForRow:nextIndex inSection:0];
        // get the next cell of the list
        ListSongTableViewCell *nextCell = [self.listSongTableView cellForRowAtIndexPath:self.indexPlaying];
        [nextCell PlayNewMusic];
        
    }else{ // index is out of range
        // disable prev button
        [self.preMusicButton setImage:[UIImage imageNamed:@"prev_music_off"] forState:(UIControlState)UIControlStateNormal];
        
    }
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
- (void)getListAlbum{
    
    if (![self connected]) {
        // Not connected
        NSLog(@"No Internet connection");
        [self getAlbumLocalData];
    } else {
        // Connected. Do some Internet stuff
        [self getAlbumInternet];
    }
    
    
    
}
- (void) getAlbumLocalData{
    // get list album from coredata
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AlbumEntity"];
    
    NSManagedObjectContext *context = [[[[UIApplication sharedApplication] delegate] performSelector:@selector(persistentContainer)] viewContext];
    
    self.arrayAlbumCoreData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([self.arrayAlbumCoreData count]>0){
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for(int i=0; i<[self.arrayAlbumCoreData count];i++){
            NSManagedObject *aLocalAlbum = [self.arrayAlbumCoreData objectAtIndex:i];
            Album *aAlbum = [[Album alloc] init];
            
            [aAlbum setAlbumName:[aLocalAlbum valueForKeyPath:@"name"]];
            [aAlbum setAlbumID:[aLocalAlbum valueForKeyPath:@"id"]];
            
            if(![[aLocalAlbum valueForKeyPath:@"cover"] isEqual:@""]){
                NSURL *URL = [NSURL URLWithString:[aLocalAlbum valueForKeyPath:@"cover"]];
                NSString *coverFileName = [[URL lastPathComponent] stringByDeletingPathExtension];
                NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", coverFileName]];
                
                // check exist local album cover
                if([fileManager fileExistsAtPath:writablePath]){
                    NSURL *coverUrl = [NSURL fileURLWithPath:writablePath isDirectory:NO];
                    NSData *localData = [NSData dataWithContentsOfURL:coverUrl];
                    [aAlbum setAlbumPhotoCover: localData];
                }
                
                
            }
            // add to the array album
            [self.albumCollection addObject:aAlbum];
            
            //reload album carousel
            [self.albumList reloadData];
        }
        // turn off loading
        [self hideLoading];
    }
}
- (BOOL)clearAlbumEntity{
    // get list album from coredata
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AlbumEntity"];
    
    NSManagedObjectContext *context = [[[[UIApplication sharedApplication] delegate] performSelector:@selector(persistentContainer)] viewContext];
    NSMutableArray *tmpAlbumData = [[NSMutableArray alloc] init];
    tmpAlbumData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([tmpAlbumData count] >0){
        for (NSManagedObject *object in tmpAlbumData) {
            [context deleteObject:object];
        }
        
        NSError *saveError = nil;
        if (![context save:&saveError]) {
            NSLog(@"Can't delete Album: %@ %@", saveError, [saveError localizedDescription]);
        }
        
        return (saveError == nil);
    }
    return YES;
}
- (void)getAlbumInternet{
    
    BOOL delelteAllLocalAlbum = [self clearAlbumEntity];
    self.ref = [[FIRDatabase database] reference];
    // get list album from firebase
    FIRDatabaseQuery *albumQuery = [[[self.ref child:@"album"] queryOrderedByKey] queryLimitedToFirst:self.numberAlbumDisplay];
    [self showLoading]; // show icon loading
    
    [albumQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *albumName = [snapshot.value objectForKey:@"name"];
        NSString *albumID = [snapshot.value objectForKey:@"id"];
        NSString *albumCoverURL = [snapshot.value objectForKey:@"cover"];
        //NSLog(@"albumid: %@", albumID);
        
        if(delelteAllLocalAlbum){ //clear old data and update new one
            //NSLog(@"albumid: %@", albumID);
            // save to local data
            NSManagedObjectContext *context = [[[[UIApplication sharedApplication] delegate] performSelector:@selector(persistentContainer)] viewContext];
            
            NSManagedObject *album = [NSEntityDescription insertNewObjectForEntityForName:@"AlbumEntity" inManagedObjectContext:context];
            
            [album setValue:albumName forKey:@"name"];
            [album setValue:albumID forKey:@"id"];
            [album setValue:albumCoverURL forKey:@"cover"];
            
            NSError *error = nil;
            
            [context save:&error];
            
            if (error != nil) {
                NSLog(@"Can't Save Local Album! %@ %@", error, [error localizedDescription]);
            }
        }
        
        // prepare for writting data album cover to local file
        NSURL *URL = [NSURL URLWithString:albumCoverURL];
        
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *coverFileName = [[URL lastPathComponent] stringByDeletingPathExtension];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", coverFileName]];
        
        Album *aAlbum = [[Album alloc] init];
        
        [aAlbum setAlbumID:albumID];
        //NSLog(@"albumid: %@", albumID);
        [aAlbum setAlbumName: albumName];
        
        
        if(![fileManager fileExistsAtPath:writablePath]){
            // file doesn't exist
            NSLog(@"file cover album doesn't exist");
            //save Image From URL
            NSData * data = [NSData dataWithContentsOfURL:URL];
            
            NSError *error = nil;
            
            // write photo cover to file
            [data writeToFile:writablePath options:NSAtomicWrite error:&error];
            
            if (error) {
                NSLog(@"Error Writing cover File : %@",error);
            }else{
                NSLog(@"Image cover %@ Saved SuccessFully",coverFileName);
                
                NSURL *localCoverUrl = [NSURL fileURLWithPath:writablePath isDirectory:NO];
                NSData *photoCover = [NSData dataWithContentsOfURL:localCoverUrl];
                
                [aAlbum setAlbumPhotoCover: photoCover];
                //[self.albumList reloadData];
            }
        }
        else{ // loading exist photo cover
            // file exist
            //NSLog(@"file cover exist");
            
            NSURL *coverUrl = [NSURL fileURLWithPath:writablePath isDirectory:NO];
            NSData *localData = [NSData dataWithContentsOfURL:coverUrl];
            //NSLog(@"local data: %@", localData);
            [aAlbum setAlbumPhotoCover: localData];
            //NSLog(@"album: ", aAlbum);
            //[self.albumList reloadData];
        }
        
        
        
        [self.albumCollection addObject:aAlbum];
        [self.albumList reloadData];
        // turn off loading
        [self hideLoading];
    }];
}
-(void)hideLoading{
        [UIImageView animateWithDuration:.25 animations:^{
            [self.loadingView setHidden:YES];
            [self.percentLoadingAlbumLabel setHidden:YES];
        }];
}
-(void)showLoading{
        [UIImageView animateWithDuration:.25 animations:^{
            [self.loadingView setHidden:NO];
            [self.percentLoadingAlbumLabel setHidden:NO];
        }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.songByAlbumIDArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.listSongTableView registerNib:[UINib nibWithNibName:@"ListSongTableViewCell" bundle:nil] forCellReuseIdentifier:@"songItemCell"];
    ListSongTableViewCell *cell = [listSongTableView dequeueReusableCellWithIdentifier:@"songItemCell" forIndexPath:indexPath];
    Song *aSong = [self.songByAlbumIDArray objectAtIndex:indexPath.row];
    [[cell songName] setText:[aSong songName]];
    
    // change selected row background
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:0.6];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.duration setText:[aSong duration]];
    
    [cell getParentController:self];
    [cell setCurrentSong:aSong];
    [cell setIndexPath:indexPath];
    [cell setParentTabController:self.tabBarController];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Song *aSong = [self.songByAlbumIDArray objectAtIndex:indexPath.row];
    [self.songTitleLabel setText:[aSong songName]];

    
    // display artist label
    if(![[aSong artistID] isEqualToString:@""]){
        // get artist by ID
        FIRDatabaseQuery *singleArtistQuery = [[[self.ref child:@"artist"] queryOrderedByChild:@"id"] queryEqualToValue:[aSong artistID]];
        [singleArtistQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
            
            NSString *artistName = [snapshot.value objectForKey:@"name"];
            [self.songArtistLabel setText:artistName];
        }];
    }
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [self.albumList reloadData];
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    return [self.albumCollection count];
}
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return self.numberAlbumDisplay;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    // turn off music when start a new album
    [self changeMusic:YES];
    
    // reset the selected song
    self.indexPlaying = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    if([self.albumCollection count]>0){
        Album *aAlbum = [self.albumCollection objectAtIndex:carousel.currentItemIndex];
        
        // remove and reload list song table
        [self.songByAlbumIDArray removeAllObjects];
        
        [self.listSongTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        //NSLog(@"Album: %@",aAlbum.albumID);
        if([aAlbum albumID].length>0){

            // get list songid by albumid from firebase
            FIRDatabaseQuery *albumSongQuery = [[[self.ref child:@"albumSong"] queryOrderedByChild:@"albumid"] queryEqualToValue:[aAlbum albumID]];
            //NSLog(@"SongID: %@",albumSongQuery);
            [albumSongQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSString *songID = [snapshot.value objectForKey:@"songid"];
                //NSLog(@"SongID: %@",songID);
                
                // get Song by ID
                FIRDatabaseQuery *singleSongQuery = [[[self.ref child:@"song"] queryOrderedByChild:@"id"] queryEqualToValue:songID];
                [singleSongQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
                    //NSLog(@"SongIDSingle: %@",songID);
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
                    
                    // add this song to array list
                    [self.songByAlbumIDArray addObject:aSong];
                    
                    [self.listSongTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

                    //NSLog(@"Album object: %d",[self.songByAlbumIDArray count]);
                }];
                
            }];
        }else{
            NSLog(@"There is no album");
        }
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if([self.albumCollection count]>0){
        Album *aAlbum = [self.albumCollection objectAtIndex:index];
        NSData *coverPhotoData = aAlbum.albumPhotoCover;
        view = [[UIImageView alloc] initWithImage:[UIImage imageWithData:coverPhotoData]];
    }
    
    return view;
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 200;
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}
- (void)pauseMusic{
    //stop loading iamge
    [UIView animateWithDuration:.25 animations:^{
        self.loadingImageSubView.alpha = 0;
    }];
    
    [self.player pause];
    
    [self.playMainButton setImage:[UIImage imageNamed:@"play_music"] forState:(UIControlState)UIControlStateNormal];
    [self.selectedPlayButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
    isPlayed = NO;
}
- (void)stopMusic{
    //stop loading iamge
    [UIView animateWithDuration:.25 animations:^{
        self.loadingImageSubView.alpha = 0;
    }];
    
    [self.player stop];
    
    [self.playMainButton setImage:[UIImage imageNamed:@"play_music"] forState:(UIControlState)UIControlStateNormal];
    [self.selectedPlayButton setImage:[UIImage imageNamed:@"play_trial"] forState:(UIControlState)UIControlStateNormal];
    isPlayed = NO;
}
- (void)playCurrentMusic{
    if(indexPlaying>=0){
        // show loading music
        self.loadingImageSubView.alpha = 1;
        
        [self.player play];
        
        [self.playMainButton setImage:[UIImage imageNamed:@"pause_music"] forState:(UIControlState)UIControlStateNormal];
        [self.selectedPlayButton setImage:[UIImage imageNamed:@"pause_trial"] forState:(UIControlState)UIControlStateNormal];
        isPlayed = YES;
    }
}
-(void)changeMusic: (BOOL) status{
    if(indexPlaying>=0){
        if(status){
            [self pauseMusic];
        }else{
            [self playCurrentMusic];
        }
    }
}
- (IBAction)playMusicAction:(id)sender {
    [self changeMusic:isPlayed];
}
@end
