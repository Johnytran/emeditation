//
//  LengthViewController.m
//  emeditation
//
//  Created by admin on 22/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "LengthViewController.h"

@interface LengthViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LengthViewController
@synthesize timeCollectionView, arrayTime, pickTimeView, arrayPickerTime, timeSetView, contentView, timeSettingView, SetButton, arrayCell, isExtra, moreTimeButton, selectedTime,cancelTrailing;


- (void)viewDidAppear:(BOOL)animated{
    CGFloat timeSettingViewWidth = self.timeSettingView.frame.size.width;
    self.cancelTrailing.constant = timeSettingViewWidth/2;
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
        
        CGFloat timeSettingViewWidth = self.timeSettingView.frame.size.width;
        self.cancelTrailing.constant = timeSettingViewWidth/2;
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // loading the selected session time
    NSMutableDictionary *myProfile = [[NSMutableDictionary alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myProfile = delegate.myProfile;
    
    // get selected time
    self.selectedTime =  [myProfile objectForKey:@"session_time"];
    if(self.selectedTime==nil)
        self.selectedTime = @"5";
    
    
    
    self.isExtra = NO;
    // create corner for controls
    self.timeSettingView.layer.cornerRadius = 10;
    
    [self.contentView setNeedsUpdateConstraints];
    
    // initial arrays
    self.arrayCell = [[NSMutableArray alloc] init];
    
    self.arrayPickerTime = @[@[@"0",@"1", @"2", @"3"],@[@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60"]];
    self.arrayTime = [[NSMutableArray alloc] initWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", nil];
    [timeCollectionView reloadData];
    
    
    // classified selected time
    int selectedTimeInt = [self.selectedTime intValue];
    selectedTimeInt = selectedTimeInt*60;
    int selectedTimeMinutes = (selectedTimeInt / 60) % 60;
    int selectedTimeHours = selectedTimeInt / 3600;
    
    // only apply for picker view
    if(selectedTimeInt>60){
        NSArray *arrayHours = [[NSArray alloc] init];
        arrayHours = self.arrayPickerTime[0];
        NSString *strHour = [NSString stringWithFormat:@"%d",selectedTimeHours];
        NSInteger indexSelectedHour = [arrayHours indexOfObject:strHour];
        [self.pickTimeView selectRow:indexSelectedHour inComponent:0 animated:YES];
        if(selectedTimeMinutes>5){
            NSArray *arrayMinute = [[NSArray alloc] init];
            arrayMinute = self.arrayPickerTime[1];
            NSString *strMinutes = [NSString stringWithFormat:@"%d",selectedTimeMinutes];
            NSInteger indexSelectedMinute = [arrayMinute indexOfObject:strMinutes];
            [self.pickTimeView selectRow:indexSelectedMinute inComponent:1 animated:YES];
        }
    }
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"timepicker_bg.png"] drawInRect:self.view.bounds];
    UIImage *imageTimePicker = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.timeSetView.backgroundColor = [UIColor colorWithPatternImage:imageTimePicker];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.arrayPickerTime[component] count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.arrayPickerTime[component][row];
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = self.arrayPickerTime[component][row];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrayTime count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"myCell";
    [self.timeCollectionView registerNib:[UINib nibWithNibName:@"LengthCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    LengthCollectionViewCell *cell = [timeCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if([self.arrayTime count]){
        [[cell timeLabel] setText:[self.arrayTime objectAtIndex:indexPath.row]];
        [self.arrayCell addObject:cell];
        if(self.selectedTime == [self.arrayTime objectAtIndex:indexPath.row]){
            cell.bgImageView.image = [UIImage imageNamed:@"length_on"];
        }
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([arrayCell count]>0){
        for(LengthCollectionViewCell *aCell in arrayCell){
            aCell.bgImageView.image = [UIImage imageNamed:@"minCir"];
        }
    }
    LengthCollectionViewCell *cell = (LengthCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.image = [UIImage imageNamed:@"length_on"];
    self.selectedTime = [cell.timeLabel text];
}

- (IBAction)setTime:(id)sender {
    if(self.isExtra){
        NSInteger selectedHour = [self.pickTimeView selectedRowInComponent:0];
        NSInteger selectedMinuteIndex = [self.pickTimeView selectedRowInComponent:1];
        NSString *selectedMinute = self.arrayPickerTime[1][selectedMinuteIndex];
        
        int minutes = [selectedMinute intValue];
        int hour = (int) selectedHour;
        
        int totalMinute = hour * 60 + minutes;
        if(totalMinute >0){
            NSString *stringTime = [NSString stringWithFormat:@"%d", totalMinute];
            
            // get profile from global store
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSMutableDictionary *myProfile = delegate.myProfile;
            [myProfile setObject:stringTime forKey:@"session_time"];
        }
        //NSLog(@"total minutes: %d", totalMinute);
        //NSLog(@"Hour: %ld minutes: %@",(long)selectedHour , selectedMinute );
        
    }else{
        // get profile from global store
        if(self.selectedTime){
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSMutableDictionary *myProfile = delegate.myProfile;
            [myProfile setObject:self.selectedTime forKey:@"session_time"];
        }
        //NSLog(@"selected time: %@", selectedTime );
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)MoreTime:(id)sender {
    
    [UIView transitionWithView:self.moreTimeButton
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        self.moreTimeButton.hidden = YES;
                        self.isExtra = YES;
                    }
                    completion:NULL];
}

- (IBAction)Cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
