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
@synthesize player, playButton, isPlayed, timeOfSession, remainingTimeLabel, musicTitleLabel, stopButton, secondsLeft, bgImageView, myProfile, dbRef, appDelegate, refModalController, secondsDone, refCSVModalController, csvEmotionURL;
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
    
    
    
    // creating background
    NSString * homeBundle = [[NSBundle mainBundle]pathForResource:@"waterfall" ofType:@"gif"];
    FLAnimatedImage *imageHome = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:homeBundle]];
    bgImageView.animatedImage = imageHome;
    
    
    
    
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

    [player play];
    isPlayed = YES;
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
        //[self processRecommend];
        if(refCSVModalController!=nil){
            [refCSVModalController removeAnimate];
        }
        
        refCSVModalController = [[GetURLViewController alloc] initWithNibName:@"GetURLViewController" bundle:nil];
        CGFloat widthScreen = self.view.frame.size.width;
        CGFloat heightScreen = self.view.frame.size.height;
        
        [refCSVModalController showView:self.view withFrame:CGRectMake(widthScreen/2-125, heightScreen/2-100, 250, 200)];
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

- (void)processRecommend:(NSArray*) emotionData{
    
    if([emotionData count]>2){
    
        NSString *firstRow = [emotionData firstObject];
        NSString *lastRow = [emotionData objectAtIndex:[emotionData count]-2];
        
    
    
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
        
        
        NSArray *columnNameArray = [[NSArray alloc] initWithObjects:@"engagement",
                                    @"relax",
                                    @"stress",
                                    @"excitement",
                                    @"interest",
                                    @"occupation",
                                    @"sport_time",
                                    @"sport",
                                    @"marital status",
                                    @"travel",
                                    @"song",
                                    @"result", nil];
        
        
        NSString *occupation = [self.myProfile objectForKey:@"occupation"];
        if(occupation==nil){
            occupation = @"1"; // set default
            // update profile to firebase
            NSDictionary *post = @{@"uid": [FIRAuth auth].currentUser.uid,
                                   @"occupation": @"01",
                                   @"sport_time": @"01",
                                   @"sport": @"01",
                                   @"marital_status": @"01",
                                   @"travel": @"01",
                                   @"song": @"song01"
                                   };
            
            [[[self.dbRef child:@"profile"] child:[FIRAuth auth].currentUser.uid] setValue:post withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
                if (error) {
                    NSLog(@"Save default profile background could not be saved: %@", error);
                    //[self showMessage:@"Profile background could not be saved"];
                } else {
                    NSLog(@"Default profile background saved successfully.");
                    
                    //[self showMessage:@"Profile background saved successfully."];
                    
                }
            }];
        }
        NSString *sport_time = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"sport_time"]];
        if(sport_time==nil)
            sport_time = @"1"; // set default
        NSString *sport = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"sport"]];
        if(sport==nil)
            sport = @"1"; // set default
        NSString *marital_status = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"marital_status"]];
        if(marital_status==nil)
            marital_status = @"1"; // set default
        NSString *travel = [NSString stringWithFormat:@"%@",[self.myProfile objectForKey:@"travel"]];
        if(travel==nil)
            travel = @"1"; // set default
        Song *song = [self.myProfile objectForKey:@"song"];
        NSString *songID = @"";
        if(song==nil){
            songID = @"song01"; // set default
        }else{
            songID = [song songID];
        }
        
        
        
         // first session
        NSString *stress;
        if(firstRow!=nil){
            NSArray* columns1 = [firstRow componentsSeparatedByString:@","];
            if([columns1 count] >0){
                stress = columns1[2];
                //NSLog(@"stress: %@", stress);
            }
        }
        NSString *engagement_end;
        NSString *relax_end;
        NSString *stress_end;
        NSString *excitement_end;
        NSString *interest_end;
        // last session
        if(lastRow!=nil){
            NSArray* columns2 = [lastRow componentsSeparatedByString:@","];
            if([columns2 count] >0){
                engagement_end = columns2[0];
                relax_end = columns2[1];
                stress_end = columns2[2];
                excitement_end = columns2[3];
                interest_end = columns2[4];
                //NSLog(@"engagement: %@", engagement);
            }
        }
        
        float firstStressFloat = [stress floatValue];
        
//        float excitementFloat = [excitement_end floatValue];
//        float engagementFloat = [engagement_end floatValue];
//        float relaxFloat = [relax_end floatValue];
        float stressFloat = [stress_end floatValue];
        //float interestFloat = [interest_end floatValue];
        
        NSString *inputResult = @"0";
        if(stressFloat<firstStressFloat)
            inputResult = @"1";
        
        
        NSArray *columnValue1Array = [[NSArray alloc] initWithObjects:engagement_end,
                                      relax_end,
                                      stress_end,
                                      excitement_end,
                                      interest_end,
                                      occupation,
                                      sport_time,
                                      sport,
                                      marital_status,
                                      travel,
                                      songID,
                                      inputResult, nil];
        
        
        NSArray *columnValueArray = [[NSArray alloc] initWithObjects:columnValue1Array, nil];
        
        NSMutableDictionary *contentInput1Dictionary = [[NSMutableDictionary alloc] init];
        [contentInput1Dictionary setObject:columnNameArray forKey:@"ColumnNames"];
        [contentInput1Dictionary setObject:columnValueArray forKey:@"Values"];
        
        
        NSMutableDictionary *input1Dictionary = [[NSMutableDictionary alloc] init];
        [input1Dictionary setObject:contentInput1Dictionary forKey:@"input1"];
        
        
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
                                        NSString *engagement = [firstResult firstObject];
                                        NSString *relax;
                                        NSString *stress;
                                        NSString *excitement;
                                        NSString *interest;
                                        NSString *occupation;
                                        NSString *sport_time;
                                        NSString *sport;
                                        NSString *travel;
                                        NSString *marital_status;
                                        NSString *song;
                                        NSString *result;
                                        if([firstResult count]>=1){
                                            relax = [firstResult objectAtIndex:1];
                                        }
                                        if([firstResult count]>=2){
                                            stress = [firstResult objectAtIndex:2];
                                        }
                                        if([firstResult count]>=3){
                                            excitement = [firstResult objectAtIndex:3];
                                        }
                                        if([firstResult count]>=4){
                                            interest = [firstResult objectAtIndex:4];
                                        }
                                        
                                        if([firstResult count]>=5){
                                            occupation = [firstResult objectAtIndex:5];
                                        }
                                        if([firstResult count]>=6){
                                            sport_time = [firstResult objectAtIndex:6];
                                        }
                                        if([firstResult count]>=7){
                                            sport = [firstResult objectAtIndex:7];
                                        }
                                        if([firstResult count]>=8){
                                            marital_status = [firstResult objectAtIndex:8];
                                        }
                                        if([firstResult count]>=9){
                                            travel = [firstResult objectAtIndex:9];
                                        }
                                        if([firstResult count]>=10){
                                            song = [firstResult objectAtIndex:10];
                                        }
                                        if([firstResult count]>=11){
                                            result = [firstResult objectAtIndex:11];
                                        }
                                        
                                        NSString *probabilities = [firstResult lastObject];
                                        
                                        // save to session history in firebase
                                        // get selected time
                                        NSString *selectedTime =  [self.myProfile objectForKey:@"session_time"];
                                        if(selectedTime==nil)
                                            selectedTime = @"5";
                                        
                                        // get selected time
                                        NSString *selectedLevel =  [self.myProfile objectForKey:@"session_level"];
                                        if(selectedLevel==nil)
                                            selectedLevel = @"1";
                                        
                                        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                                        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                                        
                                        NSDictionary *post = @{@"uid": [FIRAuth auth].currentUser.uid,
                                                               @"occupation": occupation,
                                                               @"sport_time": sport_time,
                                                               @"sport": sport,
                                                               @"marital_status": marital_status,
                                                               @"travel": travel,
                                                               @"engagement": engagement,
                                                               @"relax": relax,
                                                               @"stress": stress,
                                                               @"excitement": excitement,
                                                               @"interest": interest,
                                                               
                                                               @"probabilities": probabilities,
                                                               @"session_time": selectedTime,
                                                               @"session_level": selectedLevel,
                                                               @"song": song,
                                                               @"result": result,
                                                               @"date": [dateFormatter stringFromDate:[NSDate date]]
                                                               };
                                        
                                        // update gobal variable
                                        NSMutableDictionary *newProfile = [post mutableCopy];
                                        self.appDelegate.myProfile = newProfile;
                                        
                                        // save to history in firebase
                                        [[self.dbRef child:[NSString stringWithFormat:@"history/%@/%@/%@",[FIRAuth auth].currentUser.uid, song, [self.dbRef childByAutoId].key ]]  setValue:post withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref){
                                            if(error==nil){
                                                NSLog(@"Session is save to history");
                                                [self performSegueWithIdentifier:@"resultSeque" sender:nil];
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
        
    }else{
        [self showMessage:@"Data from your EEG device is not ready to process"];
        [self performSegueWithIdentifier:@"resultSeque" sender:nil];
    }
}

- (IBAction)stopSession:(id)sender {
    [self.player stop];
    [timeOfSession invalidate];
    int doneMinutes = (self.secondsDone % 3600) / 60;
    
    if(refCSVModalController!=nil){
        [refCSVModalController removeAnimate];
    }
    
    refCSVModalController = [[GetURLViewController alloc] initWithNibName:@"GetURLViewController" bundle:nil];
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    
    [refCSVModalController showView:self.view withFrame:CGRectMake(widthScreen/2-125, heightScreen/2-100, 250, 200)];
    
    
    

    
    
    
    
//    if(doneMinutes>=5){
//        [self processRecommend];
//    }else{// too short time for getting experiment
//
//        self.appDelegate.delegateWeakTime = 1;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    

}
- (IBAction)ProcessAction:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *csvURL = [[NSString alloc] initWithString:delegate.urlCSVFile];
    if(![csvURL isEqual:@""]){
        NSMutableString *stringToTrim = [csvURL mutableCopy];
        
        //pass it by reference to CFStringTrimSpace
        CFStringTrimWhitespace((__bridge CFMutableStringRef) stringToTrim);
        
        NSURL *urlCSV = [NSURL URLWithString:stringToTrim];
        
        NSError* error;
        NSString *reply = [NSString stringWithContentsOfURL:urlCSV encoding:NSUTF8StringEncoding error:&error];
        NSArray* rows = [reply componentsSeparatedByString:@"\n"];
        
        [self processRecommend: rows];
        

    }
}
@end
