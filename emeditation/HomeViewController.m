//
//  HomeViewController.m
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "HomeViewController.h"
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize homeImageView, contentView, pulseImageView, refModalController, performanceView, trainingButton, sessionLevelLabel, myProfile, refToastController, refProgressController, downloadSongSize, musicData, appDelegate, startSessionButton, spinner, refRecommendController, isShowRecommend, guideView, coverGuideImageView, toolGuideView, player, isPlayed, beingPlay, trainingAudioURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.isShowRecommend = NO;
    
    // initialise
    self.dbRef = [[FIRDatabase database] reference];
    
    // show the recommend music
    if(self.isShowRecommend==NO){
        // did user use to have an experimence?
        FIRDatabaseQuery *userHistory = [self.dbRef child:[NSString stringWithFormat:@"history/%@",[FIRAuth auth].currentUser.uid]];
        NSMutableArray * hasRecommend= [[NSMutableArray alloc] init];
        [userHistory observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull userHistorySnapshot) {
            if([hasRecommend count]<=0){
                [hasRecommend addObject:@"yes"];
                //show recommend music box
                [self showRecommendMusic];
                //NSLog(@"test");
            }
            
        }];
        hasRecommend = nil;
        self.isShowRecommend = YES;
    }
    
    // get training audio
    FIRDatabaseQuery *trainingQuery = [[self.dbRef child:@"training"] queryOrderedByKey];
    
    [trainingQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.trainingAudioURL = [snapshot.value objectForKey:@"value"];
        
    }];
    
    
    // corner the cover guide
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.coverGuideImageView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){20.0, 20.}].CGPath;
    
    self.coverGuideImageView.layer.mask = maskLayer;
    
    // corner tool guide
    CAShapeLayer * maskToolGuideLayer = [CAShapeLayer layer];
    maskToolGuideLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.toolGuideView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){20.0, 20.}].CGPath;
    
    self.toolGuideView.layer.mask = maskToolGuideLayer;
    
    
    /// loading the session profile
    self.myProfile = [[NSMutableDictionary alloc] init];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myProfile = self.appDelegate.myProfile;
    
    self.sessionTimeLabel.layer.cornerRadius = 10;
    self.sessionLevelLabel.layer.cornerRadius = 10;
    
    self.trainingButton.layer.cornerRadius = 20;
    [self.trainingButton.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.trainingButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.trainingButton.layer setShadowOpacity:0.8];
    
    
    self.guideView.layer.cornerRadius = 20;
    [self.guideView.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.guideView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.guideView.layer setShadowOpacity:0.8];
    [self.guideView.layer setBorderWidth:2.0];
    [self.guideView.layer setBorderColor:[[UIColor colorWithRed:0.62 green:0.14 blue:0.67 alpha:1.0] CGColor]];
    
    // calculate percentage working this week
    // create a list to store all the score for a user.
    NSMutableArray *probabitiesRound = [[NSMutableArray alloc] init];
    
    FIRDatabaseQuery *userHistory = [self.dbRef child:[NSString stringWithFormat:@"history/%@",[FIRAuth auth].currentUser.uid]];
    
    [userHistory observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull userHistorySnapshot) {
        float sum = 0;
        float avgScore = 0;
        for ( FIRDataSnapshot *child in userHistorySnapshot.children) {
            NSString *probabilities = [child.value objectForKey:@"probabilities"];
            //NSLog(@"date = %@",[child.value objectForKey:@"date"]);
            float floatScore = [probabilities floatValue];
            sum += floatScore;
            //NSLog(@"probabilities = %@",probabilities);

        }
        //        NSLog(@"sum = %f",sum);
        //        NSLog(@"count = %lu",(unsigned long)userHistorySnapshot.childrenCount);
        avgScore = sum/userHistorySnapshot.childrenCount;
        //NSLog(@"average for song = %f",avgScore);

        // store each avg song to a list
        [probabitiesRound addObject:[NSNumber numberWithFloat:avgScore]];

        // calculate final avg in the list
        NSNumber *average = [probabitiesRound valueForKeyPath:@"@avg.self"];

        //NSLog(@"avgScore = %f",[average floatValue]);
        float finalScore = [average floatValue];
        //NSLog(@"final score = %f",finalScore);
        // show the progress
        [self drawProgress: finalScore*100];
        
    }];
    
    
    
    // loading background animation image
    FLAnimatedImage *homeImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"gif"]]];
    self.homeImageView.animatedImage = homeImage;
    
    // loading pulse for bluetooth
    FLAnimatedImage *pulseImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pulse" ofType:@"gif"]]];
    self.pulseImageView.animatedImage = pulseImage;
    
    
    

}

- (float)percentToDegre: (float)percent withStart: (int)start{
    int degree=start;
    float rate = (float)percent / 100;
    float ratio = rate*360;
    degree = start + ratio;
    if(degree<=360){
        return degree;
    }else{
        degree = (((float)percent/100) *360) - 90;
        return degree;
    }
    
}
-(void)drawProgress: (float)percent{
    //drawing a circular background
    CAShapeLayer* outsideShapeLayer = [[CAShapeLayer alloc] init];
    outsideShapeLayer.fillColor = [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor];
    
    outsideShapeLayer.frame = CGRectMake(0, 0, 100, 100);
    outsideShapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:outsideShapeLayer.bounds] CGPath];
    outsideShapeLayer.lineWidth = 5;
    outsideShapeLayer.strokeColor = [[UIColor colorWithRed:0.54 green:0.51 blue:0.78 alpha:1.0]CGColor];
    [self.performanceView.layer addSublayer:outsideShapeLayer];
    
    //drawing a border loading with percent intput
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    CGFloat cirWidth = 100;
    shapeLayer.frame = CGRectMake(0, 0, cirWidth, cirWidth);
    CGFloat radius = cirWidth/2;
    CGPoint center = CGPointMake(cirWidth/2, cirWidth/2);
    
    CGFloat startPoint = degreesToRadians(270);
    
    float conertedDegree = [self percentToDegre:percent withStart:270];
    //NSLog(@"degree: %f", conertedDegree);
    
    CGFloat endPoint = degreesToRadians(conertedDegree);
    //NSLog(@"radian: %f", endPoint);
    shapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startPoint endAngle:(endPoint) clockwise:YES] CGPath];
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 1.5;
    [shapeLayer addAnimation:animation forKey:@"drawLineAnimation"];
    
    [self.performanceView.layer addSublayer:shapeLayer];
    
    
    //creating label show percentage
    CGFloat percentLabelWidth = cirWidth-10;
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,self.performanceView.frame.size.height/2-20, percentLabelWidth,20)];
    [percentLabel setText:[NSString stringWithFormat:@"%ld%%", lroundf(percent)]];
    [percentLabel setTextColor:[UIColor whiteColor]];
    [percentLabel setTextAlignment:NSTextAlignmentCenter];
    [percentLabel setFont:[UIFont boldSystemFontOfSize:21]];
    [self.performanceView addSubview:percentLabel];
    
    
    // creating label this week
    CGFloat subPercentLabelWidth = cirWidth-10;
    UILabel *subPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,percentLabel.frame.origin.y+20, subPercentLabelWidth,20)];
    [subPercentLabel setText:@"this week"];
    [subPercentLabel setTextColor:[UIColor whiteColor]];
    [subPercentLabel setTextAlignment:NSTextAlignmentCenter];
    [subPercentLabel setFont:[UIFont systemFontOfSize:15]];
    [self.performanceView addSubview:subPercentLabel];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    if(self.appDelegate.delegateWeakTime){
        // reset the to normal
        self.appDelegate.delegateWeakTime = 0;
        
        // show warning message
        [self showMessage:@"Your experimence time was short to analyse so please relax and take more time doing meditation."];
    }
    
    
    [refModalController removeAnimate];
    
    if(self.guideView.alpha==1){
        [self closeGuide];
    }
    
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    
    
    
    // get selected time
    NSString *selectedTime =  [self.myProfile objectForKey:@"session_time"];
    if(selectedTime!=nil){
        int minutes = [selectedTime intValue];
        if(minutes<60){
            [self.sessionTimeLabel setText:[NSString stringWithFormat:@"%d minutes", minutes]];
        }else{
            int totalSeconds = 60 * minutes;
            NSString *formatedTime = [self timeFormatted:totalSeconds];
            [self.sessionTimeLabel setText:formatedTime];
        }
        
    }
    // get selected level
    NSString *selectedLevel =  [self.myProfile objectForKey:@"session_level"];
    if(selectedLevel!=nil){
        [self.sessionLevelLabel setText:selectedLevel];
    }
    
    
    //NSLog(@"selected time: %@", selectedTime);
    
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    //int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%2d hour %2d minutes",hours, minutes];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (IBAction)turnBluetooth:(id)sender {
    if(refModalController!=nil){
        [refModalController removeAnimate];
    }
        
    refModalController = [[ModalBoxViewController alloc] initWithNibName:@"ModalBoxViewController" bundle:nil];
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    
    [refModalController showView:self.contentView withFrame:CGRectMake(self.pulseImageView.frame.origin.x+80, self.pulseImageView.frame.origin.y+80, widthScreen, heightScreen)];

}
- (IBAction)training:(id)sender {
    [self showAnimateGuide];
}


- (IBAction)SetLength:(id)sender {
    [self performSegueWithIdentifier:@"session_length_seque" sender:self];
}

- (IBAction)SetLevel:(id)sender {
    [self performSegueWithIdentifier:@"session_level_seque" sender:self];
}

- (void)prepareMusic{
    if(self.refProgressController!=nil){
        [self.refProgressController removeAnimate];
    }
    
    Song *selectedSong =  [self.myProfile objectForKey:@"song"];
    
    if(selectedSong!=nil){
        
        NSString *urlString = [selectedSong songLink];
        
        _documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _theFileName = [[urlString lastPathComponent] stringByDeletingPathExtension];
        
        _fileManager = [NSFileManager defaultManager];
        _writablePath = [_documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", _theFileName]];
        
        if(![_fileManager fileExistsAtPath:_writablePath]){
            // file doesn't exist
            NSLog(@"file doesn't exist");
            
            self.refProgressController = [[ProgressModalViewController alloc] initWithNibName:@"ProgressModalViewController" bundle:nil];
            CGFloat widthScreen = self.view.frame.size.width;
            CGFloat heightScreen = self.view.frame.size.height;
            
            [self.refProgressController showView:self.view withFrame:CGRectMake(0, heightScreen-260, widthScreen, 260)];
            
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
            
            NSURL *url = [NSURL URLWithString: urlString];
            NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL: url];
            
            [dataTask resume];
        }else{
            [self.spinner removeFromSuperview];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self performSegueWithIdentifier:@"startSessesion" sender:self];
        }
    }else{
        [self.spinner removeFromSuperview];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self performSegueWithIdentifier:@"startSessesion" sender:self];
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
    int roundPercent = ceil(percent);
    //NSLog(@"percent: %d", roundPercent);
    [[self.refProgressController dowloadingLabel] setText:[NSString stringWithFormat:@"Song downloading...%d%%", roundPercent]];
    if(roundPercent==100){
        [self.refProgressController removeAnimate];
        NSError *error = nil;
        
        [self.musicData writeToFile:_writablePath options:NSAtomicWrite error:&error];
        
        if (error) {
            NSLog(@"Error Writing Song : %@",error);
        }else{
            NSLog(@"Song %@ Saved SuccessFully",_theFileName);
            [self.spinner removeFromSuperview];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self performSegueWithIdentifier:@"startSessesion" sender:self];
        }
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        [self.refRecommendController removeAnimate];
        if(self.isShowRecommend==NO){
            //show recommend music box
            
            // did user use to have an experimence?
            FIRDatabaseQuery *userHistory = [self.dbRef child:[NSString stringWithFormat:@"history/%@",[FIRAuth auth].currentUser.uid]];
            NSMutableArray * hasRecommend= [[NSMutableArray alloc] init];
            //NSLog(@"has recommend %lu", (unsigned long)[hasRecommend count]);
            [userHistory observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull userHistorySnapshot) {
                if([hasRecommend count]<=0){
                    [hasRecommend addObject:@"yes"];
                    //show recommend music box
                    [self showRecommendMusic];
                    //NSLog(@"test");
                }
                
            }];
            hasRecommend = nil;
            self.isShowRecommend = YES;
        }
        
        
    }];
}
- (void)showMessage: (NSString*)content{
    self.refToastController = [[ToastViewController alloc] initWithNibName:@"ToastViewController" bundle:nil];
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    [self.refToastController setTextContent: content];
    [self.refToastController showView:self.view withFrame:CGRectMake(widthScreen/2-100,heightScreen/2-100, 200, 200)];
}
- (void)showRecommendMusic{
    self.refRecommendController = [[RecommendModalViewController alloc] initWithNibName:@"RecommendModalViewController" bundle:nil];
    CGFloat widthScreen = self.view.frame.size.width;
    CGFloat heightScreen = self.view.frame.size.height;
    //NSLog(@"width screen: %f height: %f", widthScreen, heightScreen);
    
    CGFloat marginWidth = widthScreen*0.10;
    
    if(widthScreen<=568){
        marginWidth = widthScreen*0.15;
    }
    
    if(widthScreen<=1366){
        marginWidth = widthScreen*0.20;
    }
    
    
    CGFloat boxHeight = heightScreen - (marginWidth*2);
    
    if(widthScreen<=320){
        boxHeight = boxHeight-150;
        marginWidth = widthScreen*0.13;
    }
    
    CGFloat boxWidth = widthScreen - (marginWidth*2);
    
    
    if(heightScreen<=896){
        boxHeight = boxHeight - 200;
    }
    
    if(heightScreen<=568){
        boxHeight = (heightScreen - (marginWidth*2))-150;
    }
    CGFloat extraMargin =0;
    if(heightScreen<=414){
        boxHeight = boxHeight-230;
        extraMargin = 60;
    }
    if(heightScreen<=320){
        boxHeight = (heightScreen - (marginWidth*2))+100;
    }
    
    [self.refRecommendController showView:self.view withFrame:CGRectMake(widthScreen/2-(boxWidth/2), heightScreen/2-(boxHeight/2)-extraMargin, boxWidth, boxHeight)];
    
    
}



- (IBAction)StartSession:(id)sender {
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(self.startSessionButton.frame.size.width-30, self.startSessionButton.frame.size.height-30, 24, 24);
    self.spinner.color = [UIColor whiteColor];
    [self.spinner startAnimating];
    [self.startSessionButton addSubview:self.spinner];
    [self.spinner bringSubviewToFront:self.spinner];
    
    // get user profile from firebase and check each item value in the session and update if it is nil
    FIRDatabaseQuery *profileQuery = [[[self.dbRef child:@"profile"] queryOrderedByChild:@"uid"] queryEqualToValue:[FIRAuth auth].currentUser.uid];

    [profileQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *occupationFRID = [snapshot.value objectForKey:@"occupation"];
        NSString *sportFRID = [snapshot.value objectForKey:@"sport"];
        NSString *sportTimeFRID = [snapshot.value objectForKey:@"sport_time"];
        NSString *travelFRID = [snapshot.value objectForKey:@"travel"];
        NSString *maritalStatusFRID = [snapshot.value objectForKey:@"marital_status"];

        NSString *occupationID =  [self.myProfile objectForKey:@"occupation"];
        if(occupationID==nil&&occupationFRID!=nil){
            occupationID = occupationFRID;
            [self.myProfile setObject:occupationFRID forKey:@"occupation"];
        }
        NSString *sportTimeID =  [self.myProfile objectForKey:@"sport_time"];
        if(sportTimeID==nil&&sportTimeFRID!=nil)
            [self.myProfile setObject:sportTimeFRID forKey:@"sport_time"];
        
        NSString *sportID =  [self.myProfile objectForKey:@"sport"];
        if(sportID==nil&&sportFRID!=nil)
            [self.myProfile setObject:sportFRID forKey:@"sport"];

        NSString *maritalStatusID =  [self.myProfile objectForKey:@"marital_status"];
        if(maritalStatusID==nil&&maritalStatusFRID!=nil)
            [self.myProfile setObject:maritalStatusFRID forKey:@"marital_status"];

        NSString *travelID =  [self.myProfile objectForKey:@"travel"];
        if(travelID==nil&&travelFRID!=nil)
            [self.myProfile setObject:travelFRID forKey:@"travel"];

        if(occupationID!=nil){

            //download song before start
            [self prepareMusic];

        }else{
            [self.spinner removeFromSuperview];
            [self showMessage:@"Please update your profile that could give you a better session."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self performSegueWithIdentifier:@"startSessesion" sender:self];
            });

        }

    }];
    
}

- (void)showAnimateGuide
{
    self.guideView.transform = CGAffineTransformMakeScale(1, 1);
    self.guideView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.guideView.alpha = 1;
    }];
}

- (void)removeAnimateGuide
{
    [UIView animateWithDuration:.25 animations:^{
        self.guideView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.guideView.alpha = 0.0;
    }];
}
- (IBAction)PlayGuideMeditation:(id)sender {
    
    if(self.isPlayed){
        self.isPlayed = NO;
        [self.playGuideButton setImage:[UIImage imageNamed:@"btn_play_guide"] forState:UIControlStateNormal];
        [self.player pause];
        
        
    }else{
        if(!self.beingPlay){
            if(![self.trainingAudioURL isEqual:@""]){
                [self PlayMusic: self.trainingAudioURL];
                [self.player play];
                self.beingPlay = YES;
            }
            
        }else{
            [self.player play];
        }
        self.isPlayed = YES;
        [self.playGuideButton setImage:[UIImage imageNamed:@"btn_pause_guide"] forState:UIControlStateNormal];
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
        
        NSError *error = nil;
        
        [data writeToFile:_writablePath options:NSAtomicWrite error:&error];
        
        if (error) {
            NSLog(@"Error Writing audio : %@",error);
        }else{
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        }
        
        
        
    }
    else{
        // file exist
        NSLog(@"file exist");
        
        NSURL *soundUrl = [NSURL fileURLWithPath:_writablePath isDirectory:NO];
        NSData *localData = [NSData dataWithContentsOfURL:soundUrl];
        self.player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
        
    }
    
    
}

-(void) closeGuide{
    self.beingPlay = NO;
    self.isPlayed = NO;
    [self.playGuideButton setImage:[UIImage imageNamed:@"btn_play_guide"] forState:UIControlStateNormal];
    [self.player stop];
    [self removeAnimateGuide];
}

- (IBAction)SkipGuide:(id)sender {
    [self closeGuide];
}
@end
