//
//  ResultViewController.m
//  emeditation
//
//  Created by admin on 13/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize chartView, probabilityView, probabilityLabel, appDelegate, myProfile;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.probabilityView.layer.cornerRadius = 30;
    self.doneButton.layer.cornerRadius = 20;
    ChartView *aChartView = (ChartView *)self.chartView;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myProfile = self.appDelegate.myProfile;
    
    NSString *excitementString =  [self.myProfile objectForKey:@"excitement"];
    NSString *engagementString =  [self.myProfile objectForKey:@"engagement"];
    NSString *relaxString =  [self.myProfile objectForKey:@"relax"];
    NSString *stressString =  [self.myProfile objectForKey:@"stress"];
    NSString *interestString =  [self.myProfile objectForKey:@"interest"];
    NSString *probabilities =  [self.myProfile objectForKey:@"probabilities"];
    
    
    aChartView.excitement = [excitementString floatValue] *100;
    aChartView.engagement = [engagementString floatValue] *100;
    aChartView.relax = [relaxString floatValue] *100;
    aChartView.stress = [stressString floatValue] *100;
    aChartView.interest = [interestString floatValue] *100;
    
    float probailitiesRound = ceil([probabilities floatValue]*100);
    [probabilityLabel setText:[NSString stringWithFormat:@"Score: %.2f",probailitiesRound]];
}

- (IBAction)CompleteSession:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
