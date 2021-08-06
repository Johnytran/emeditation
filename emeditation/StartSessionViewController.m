//
//  StartSessionViewController.m
//  emeditation
//
//  Created by admin on 5/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "StartSessionViewController.h"

@interface StartSessionViewController ()

@end

@implementation StartSessionViewController
@synthesize player, playButton, isPlayed, timeOfSession, remainingTimeLabel, musicTitleLabel, stopButton, secondsLeft, bgImageView, myProfile, dbRef, appDelegate, refModalController, secondsDone, isLike;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // a flag for turn on music player
    isPlayed = NO;
    secondsDone = 0;
    
    self.dbRef = [[FIRDatabase database] reference];
    
    self.tabBarController.tabBar.hidden = YES;
    
    /// loading the session profile
    self.myProfile = [[NSMutableDictionary alloc] init];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myProfile = self.appDelegate.myProfile;
    
    // get selected song
    Song *selectedSong =  [self.myProfile objectForKey:@"song"];
    if(selectedSong!= nil){
        if([selectedSong songLink] != nil){
            [self PlayMusicURL:[selectedSong songLink]];
            [self.musicTitleLabel setText:[selectedSong songName]];
        }
    }else{
        [self PlayMusicLocal:@"rain.mp3"];
    }
    
    
}
- (void) PlayMusicURL: (NSString*) urlString{
    
    
    _documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _theFileName = [[urlString lastPathComponent] stringByDeletingPathExtension];
    
    _fileManager = [NSFileManager defaultManager];
    _writablePath = [_documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", _theFileName]];
    
    if([_fileManager fileExistsAtPath:_writablePath]){
        
        NSURL *soundUrl = [NSURL fileURLWithPath:_writablePath isDirectory:NO];
        NSData *localData = [NSData dataWithContentsOfURL:soundUrl];
        player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
        
    }else{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
             error:&setCategoryError]) {
        // handle error
    }
    
    [player play];
    isPlayed = YES;
}
- (void)showRating{
    
    ModalBoxViewController *modalLikeController = [[ModalBoxViewController alloc] initWithNibName:@"ModalBoxViewController" bundle:nil];
    
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    [modalLikeController setParentController:self];
    [modalLikeController showView: CGRectMake(0,0, widthScreen, heightScreen)];
    [self addChildViewController:modalLikeController];
    [modalLikeController didMoveToParentViewController:self];
    
}
- (void)showCompleteMessage{
    
    ModalCompleteViewController *modalCompleteController = [[ModalCompleteViewController alloc] initWithNibName:@"ModalCompleteViewController" bundle:nil];
    
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    [modalCompleteController setParentController:self];
    [modalCompleteController showView: CGRectMake(0,0, widthScreen, heightScreen)];
    [self addChildViewController:modalCompleteController];
    [modalCompleteController didMoveToParentViewController:self];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    // get selected song
    NSString *selectedTime =  [self.myProfile objectForKey:@"session_time"];
    int selectedTimeInt = [selectedTime intValue];
    int selectedTimeSecond = selectedTimeInt*60;
    if(selectedTimeSecond==0)
        selectedTimeSecond = 300;
    [self startTimer:selectedTimeSecond];
}
- (void)startTimer: (int)duration{
    secondsLeft = duration;
    timeOfSession = [NSTimer scheduledTimerWithTimeInterval:1.0  target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
}
-(void)actionTimer
{
    
    int hours, minutes, seconds;
    secondsLeft--;
    secondsDone++;
    hours = secondsLeft / 3600;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft %3600) % 60;
    [remainingTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]];
    
    if (secondsLeft==0) {
        [timeOfSession invalidate];
        [self.player stop];
        if(!self.appDelegate.isGuest){
            // rating song
            [self showRating];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        //[self processRecommend];
    }
    
}
- (void) PlayMusicLocal: (NSString*) name{
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],name];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.player.numberOfLoops = -1; //Infinite
    [self.player setVolume: 1.0];
    [self.player play];
    isPlayed = YES;
}

- (IBAction)playSession:(id)sender {
    if(isPlayed){
        [self.player pause];
        [timeOfSession invalidate];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:(UIControlState)UIControlStateNormal];
        isPlayed = NO;
    }else{
        [self.player play];
        [self startTimer:secondsLeft];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:(UIControlState)UIControlStateNormal];
        isPlayed = YES;
    }
}

-(void)showMessage:(NSString*)text{
    if(self.refModalController!=nil){
        [self.refModalController removeAnimate];
    }
    
    self.refModalController = [[ToastViewController alloc] initWithNibName:@"ToastViewController" bundle:nil];
    
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    [self.refModalController setTextContent:text];
    [self.refModalController showView:self.view withFrame:CGRectMake(widthScreen/2-100,heightScreen/2-100, 200, 200)];
}

- (void)processRecommend{
    
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:@"https://ussouthcentral.services.azureml.net/workspaces/344b6ea51c1a42d98f6fb211bfa6df9e/services/09110042c01843b1b65c9bb8b70aa849/execute?api-version=2.0&details=true"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request addValue:@"Bearer JvjMNEheo1TjvwnV4N2jUxyLSWjxIlJAfow6iK2u76/56UZ7kqjk/wIxtrwXYpMt7a77+0aatIQxThgjM/w4jA==" forHTTPHeaderField:@"Authorization"];
        
        [request setHTTPMethod:@"POST"];
        
        
        NSArray *columnNameArray = [[NSArray alloc] initWithObjects:
                                    @"occupation",
                                    @"sport_time",
                                    @"sport",
                                    @"marital status",
                                    @"travel",
                                    @"song",
                                    @"result", nil];
        
        
        NSString *occupation = [self.myProfile objectForKey:@"occupation"];
        
        NSString *sport_time = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"sport_time"]];
    
        NSString *sport = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"sport"]];
        
        NSString *marital_status = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"marital_status"]];
        
        NSString *travel = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"travel"]];
        
        Song *song = [self.myProfile objectForKey:@"song"];
        
        //NSLog(@"song:%@", song);
    
        NSString *inputResult = [@(isLike) stringValue];
        
        NSArray *columnValue1Array = [[NSArray alloc] initWithObjects:
                                      occupation,
                                      sport_time,
                                      sport,
                                      marital_status,
                                      travel,
                                      [song songID],
                                      inputResult, nil];
        
        //NSLog(@"columnValue1Array:%@", columnValue1Array);
        NSArray *columnValueArray = [[NSArray alloc] initWithObjects:columnValue1Array, nil];
        
        NSMutableDictionary *contentInput1Dictionary = [[NSMutableDictionary alloc] init];
        [contentInput1Dictionary setObject:columnNameArray forKey:@"ColumnNames"];
        [contentInput1Dictionary setObject:columnValueArray forKey:@"Values"];
        
        
        NSMutableDictionary *input1Dictionary = [[NSMutableDictionary alloc] init];
        [input1Dictionary setObject:contentInput1Dictionary forKey:@"input1"];
        
        //NSLog(@"contentInput1Dictionary:%@", contentInput1Dictionary);
        
        NSMutableDictionary *mapDataDictionary = [[NSMutableDictionary alloc] init];
        [mapDataDictionary setObject:input1Dictionary forKey:@"Inputs"];
        [mapDataDictionary setObject:@"" forKey:@"GlobalParameters"];
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapDataDictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(error == nil)
            {
                
                NSError *error = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                //NSLog(@"JSON:%@", json);
                
                
                if(error!=nil)
                {
                    NSLog(@"error = %@",error);
                    
                }else{
                    NSDictionary *result = [json objectForKey:@"Results"];
                    //NSLog(@"result:%@", result);
                    if(result!=nil){
                        NSDictionary *output1 = [result objectForKey:@"output1"];
                        //NSLog(@"output1:%@", output1);
                        if(output1!=nil){
                            NSDictionary *value = [output1 objectForKey:@"value"];
                            //NSLog(@"value:%@", value);
                            if(value!=nil){
                                NSArray *values = [value objectForKey:@"Values"];
                                //NSLog(@"Values:%@", values);
                                if(values!=nil){
                                    //NSArray *firstResult = [[NSArray alloc] initWithArray:[values firstObject]];
                                    NSArray *firstResult = [values firstObject];
                                    if([firstResult count]>0){
                                        NSString *occupation;
                                        NSString *sport_time;
                                        NSString *sport;
                                        NSString *travel;
                                        NSString *marital_status;
                                        NSString *song;
                                        NSString *result;
                                        
                                        
                                        if([firstResult count]>=0){
                                            occupation = [firstResult objectAtIndex:0];
                                        }
                                        if([firstResult count]>=1){
                                            sport_time = [firstResult objectAtIndex:1];
                                        }
                                        if([firstResult count]>=2){
                                            sport = [firstResult objectAtIndex:2];
                                        }
                                        if([firstResult count]>=3){
                                            marital_status = [firstResult objectAtIndex:3];
                                        }
                                        if([firstResult count]>=4){
                                            travel = [firstResult objectAtIndex:4];
                                        }
                                        if([firstResult count]>=5){
                                            song = [firstResult objectAtIndex:5];
                                        }
                                        if([firstResult count]>=6){
                                            result = [firstResult objectAtIndex:6];
                                        }
                                        
                                        NSString *probabilities = [firstResult lastObject];
                                        
                                        // save to session history in firebase
                                        // get selected time
                                        NSString *selectedTime =  [self.myProfile objectForKey:@"session_time"];
                                        if(selectedTime==nil)
                                            selectedTime = @"5";
                                        
                                    
                                        
                                        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                                        
                                        NSDictionary *post = @{@"uid": [FIRAuth auth].currentUser.uid,
                                                               @"occupation": occupation,
                                                               @"sport_time": sport_time,
                                                               @"sport": sport,
                                                               @"marital_status": marital_status,
                                                               @"travel": travel,
                                                               @"probabilities": probabilities,
                                                               @"session_time": selectedTime,
                                                               @"song": song,
                                                               @"result": result,
                                                               @"date": [dateFormatter stringFromDate:[NSDate date]]
                                                               };
                                        
                                        // update gobal variable
//                                        NSMutableDictionary *newProfile = [post mutableCopy];
//                                        self.appDelegate.myProfile = newProfile;
                                        
                                        // save to history in firebase
                                        [[self.dbRef child:[NSString stringWithFormat:@"history/%@/%@/%@",[FIRAuth auth].currentUser.uid, song, [self.dbRef childByAutoId].key ]]  setValue:post withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref){
                                            if(error==nil){
                                                NSLog(@"Session is save to history");
                                                [self showCompleteMessage];
                                                //[self performSegueWithIdentifier:@"resultSeque" sender:nil];
                                            }else{
                                                NSLog(@"Have error in saving to history: %@", error);
                                            }
                                            
                                        }];
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
                
                
            }
            else{
                
                NSLog(@"Error : %@",error.description);
                
            }
            
            
        }];
        [postDataTask resume];
        
    
}

- (IBAction)stopSession:(id)sender {
    [self.player stop];
    [timeOfSession invalidate];
    //int doneMinutes = (self.secondsDone % 3600) / 60;
    if(!self.appDelegate.isGuest){
        // rating song
        [self showRating];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    

}

@end
