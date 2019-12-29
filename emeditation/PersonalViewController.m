//
//  PersonalViewController.m
//  emeditation
//
//  Created by admin on 30/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController
@synthesize occupationPicker,sportPicker, mariedPicker, travelPicker,
            lblOccupation, sportLabel, mariedLabel, travelLabel,
            occupationPickerVisible, sportPickerVisible, mariedPickerVisible, travelPickerVisible,
            occupationData, sportData, mariedData, travelData,
            OccupationImageView, SportImageView, MaritalStatusImageView, TravelImageView, dbRef, refModalController, tmpBackgroundProfile, sportTimeData, sportTimeLabel, sportTimeImageView, sportTimePickerVisible, sportTimePicker;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dbRef = [[FIRDatabase database] reference];
    self.occupationData = [[NSMutableArray alloc] init];
    self.sportTimeData = [[NSMutableArray alloc] init];
    self.sportData = [[NSMutableArray alloc] init];
    self.mariedData = [[NSMutableArray alloc] init];
    self.travelData = [[NSMutableArray alloc] init];
    
    
    
    // get extra user information from firebase and show on the pickers
    // get user profile
    // NSLog(@"uid %@", [FIRAuth auth].currentUser.uid);
    FIRDatabaseQuery *profileQuery = [[[self.dbRef child:@"profile"] queryOrderedByChild:@"uid"] queryEqualToValue:[FIRAuth auth].currentUser.uid];

    self.tmpBackgroundProfile = [[NSMutableDictionary alloc] init];
    [profileQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *occupationID = [snapshot.value objectForKey:@"occupation"];
        NSString *sportID = [snapshot.value objectForKey:@"sport"];
        NSString *sportTimeID = [snapshot.value objectForKey:@"sport_time"];
        NSString *travelID = [snapshot.value objectForKey:@"travel"];
        NSString *maritalStatusID = [snapshot.value objectForKey:@"marital_status"];
        
        //NSLog(@"Key: %@ and Object %@", key, obj);
        if(occupationID!=nil)
            [self.tmpBackgroundProfile setObject:occupationID forKey:@"occupation"];
        if(sportTimeID!=nil)
            [self.tmpBackgroundProfile setObject:sportTimeID forKey:@"sport_time"];
        if(sportID!=nil)
            [self.tmpBackgroundProfile setObject:sportID forKey:@"sport"];
        if(maritalStatusID!=nil)
            [self.tmpBackgroundProfile setObject:maritalStatusID forKey:@"marital_status"];
        if(travelID!=nil)
            [self.tmpBackgroundProfile setObject:travelID forKey:@"travel"];
        
        
        // fill up the picker label with the user profile
        
        FIRDatabaseQuery *occupationPropertiesQuery = [[[self.dbRef child:@"occupation"] queryOrderedByChild:@"id"] queryEqualToValue:occupationID];
        [occupationPropertiesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull occupationSnapshot) {
            NSString *occupationName = [occupationSnapshot.value objectForKey:@"name"];
            [self.lblOccupation setText: occupationName];
        }];
        
        FIRDatabaseQuery *sportPropertiesQuery = [[[self.dbRef child:@"sport"] queryOrderedByChild:@"id"] queryEqualToValue:sportID];
        [sportPropertiesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull sportSnapshot) {
            NSString *sportName = [sportSnapshot.value objectForKey:@"name"];
            [self.sportLabel setText: sportName];
        }];
        
        FIRDatabaseQuery *sportTimePropertiesQuery = [[[self.dbRef child:@"sport-time"] queryOrderedByChild:@"id"] queryEqualToValue:sportTimeID];
        [sportTimePropertiesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull sportTimeSnapshot) {
            NSString *sportTimeName = [sportTimeSnapshot.value objectForKey:@"name"];
            [self.sportTimeLabel setText: sportTimeName];
        }];
        
        FIRDatabaseQuery *maritalPropertiesQuery = [[[self.dbRef child:@"marital-status"] queryOrderedByChild:@"id"] queryEqualToValue:maritalStatusID];
        [maritalPropertiesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull maritalSnapshot) {
            NSString *maritalName = [maritalSnapshot.value objectForKey:@"name"];
            [self.mariedLabel setText: maritalName];
        }];
        
        FIRDatabaseQuery *travelPropertiesQuery = [[[self.dbRef child:@"travel"] queryOrderedByChild:@"id"] queryEqualToValue:travelID];
        [travelPropertiesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull travelSnapshot) {
            NSString *travelName = [travelSnapshot.value objectForKey:@"name"];
            [self.travelLabel setText: travelName];
        }];
        
        //NSLog(@"occupation: %@, sport: %@, travel: %@, marital: %@", occupationID, sportID, travelID, maritalStatusID);

    }];
    
    
    // get list occupation from firebase
    FIRDatabaseQuery *occupationQuery = [[self.dbRef child:@"occupation"] queryOrderedByKey];
    
    
    [occupationQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *occupationID = [snapshot.value objectForKey:@"id"];
        NSString *name = [snapshot.value objectForKey:@"name"];
        NSDictionary *aOccupationDictionary = @{
                                    occupationID : name
                                    };
        
        [self.occupationData addObject:aOccupationDictionary];
        
        [self.occupationPicker reloadAllComponents];
        //[self.occupationPicker selectRow:1 inComponent:0 animated:YES];
    }];
    
    // get list sport time from firebase
    FIRDatabaseQuery *sportTimeQuery = [[self.dbRef child:@"sport-time"] queryOrderedByKey];
    
    [sportTimeQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = [snapshot.value objectForKey:@"name"];
        NSString *sportTimeID = [snapshot.value objectForKey:@"id"];
        NSDictionary *aSportTimeDictionary = @{
                                           sportTimeID : name
                                           };
        [self.sportTimeData addObject:aSportTimeDictionary];
        [self.sportTimePicker reloadAllComponents];
    }];
    
    // get list sport from firebase
    FIRDatabaseQuery *sportQuery = [[self.dbRef child:@"sport"] queryOrderedByKey];
    
    [sportQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = [snapshot.value objectForKey:@"name"];
        NSString *sportID = [snapshot.value objectForKey:@"id"];
        NSDictionary *aSportDictionary = @{
                                                sportID : name
                                                };
        [self.sportData addObject:aSportDictionary];
        [self.sportPicker reloadAllComponents];
    }];
    
    // get list martial status from firebase
    FIRDatabaseQuery *maritalQuery = [[self.dbRef child:@"marital-status"] queryOrderedByKey];
    
    [maritalQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = [snapshot.value objectForKey:@"name"];
        NSString *maritalID = [snapshot.value objectForKey:@"id"];
        NSDictionary *aMaritalDictionary = @{
                                           maritalID : name
                                           };
        [self.mariedData addObject:aMaritalDictionary];
        [self.mariedPicker reloadAllComponents];
    }];
    
    // get list travel from firebase
    FIRDatabaseQuery *travelQuery = [[self.dbRef child:@"travel"] queryOrderedByKey];
    
    [travelQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = [snapshot.value objectForKey:@"name"];
        NSString *travelID = [snapshot.value objectForKey:@"id"];
        NSDictionary *aTravelDictionary = @{
                                             travelID : name
                                             };
        [self.travelData addObject:aTravelDictionary];
        [self.travelPicker reloadAllComponents];
    }];
    
    
    // corder and border dropdow box
    [self.OccupationImageView.layer setBorderColor: [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor]];
    [self.OccupationImageView.layer setBorderWidth: 1.0];
    [self.OccupationImageView.layer setCornerRadius: 5.0];
    
    [self.sportTimeImageView.layer setBorderColor: [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor]];
    [self.sportTimeImageView.layer setBorderWidth: 1.0];
    [self.sportTimeImageView.layer setCornerRadius: 5.0];
    
    [self.SportImageView.layer setBorderColor: [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor]];
    [self.SportImageView.layer setBorderWidth: 1.0];
    [self.SportImageView.layer setCornerRadius: 5.0];
    
    [self.MaritalStatusImageView.layer setBorderColor: [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor]];
    [self.MaritalStatusImageView.layer setBorderWidth: 1.0];
    [self.MaritalStatusImageView.layer setCornerRadius: 5.0];
    
    [self.TravelImageView.layer setBorderColor: [[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0] CGColor]];
    [self.TravelImageView.layer setBorderWidth: 1.0];
    [self.TravelImageView.layer setCornerRadius: 5.0];

    
    self.occupationPicker.delegate = self;
    self.occupationPicker.dataSource = self;
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    self.sportTimePicker.delegate = self;
    self.sportTimePicker.dataSource = self;
    self.mariedPicker.delegate = self;
    self.mariedPicker.dataSource = self;
    self.travelPicker.delegate = self;
    self.travelPicker.dataSource = self;
    
    occupationPickerVisible = NO;
    occupationPicker.hidden = YES;
    occupationPicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    sportPickerVisible = NO;
    sportPicker.hidden = YES;
    sportPicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    sportTimePickerVisible = NO;
    sportTimePicker.hidden = YES;
    sportTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    mariedPickerVisible = NO;
    mariedPicker.hidden = YES;
    mariedPicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    travelPickerVisible = NO;
    travelPicker.hidden = YES;
    travelPicker.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)showPickerCell: (UIPickerView*) picker{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    picker.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         picker.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         picker.hidden = NO;
                     }];
}

- (void)hidePickerCell: (UIPickerView*) picker{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    picker.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         picker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         picker.hidden = YES;
                     }];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int numberData=0;
    if(pickerView.tag==1){
        numberData =  (int)[self.occupationData count];
    }else if (pickerView.tag==2){
        numberData =  (int)[self.sportData count];
    }else if (pickerView.tag==3){
        numberData =  (int)[self.sportTimeData count];
    }else if (pickerView.tag==4){
        numberData =  (int)[self.mariedData count];
    }else if (pickerView.tag==5){
        numberData =  (int)[self.travelData count];
    }
    return numberData;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"row: %ld", (long)indexPath.row);
    CGFloat height = 40;
    if (indexPath.row == 0){
        height = 164;
    }
    if (indexPath.row == 1){
        height = 100;
    }
    if (indexPath.row == 3){
        height = self.occupationPickerVisible ? 191.0f : 0.0f;
    }

    if (indexPath.row == 5){
        height = self.sportPickerVisible ? 191.0f : 0.0f;
    }

    if (indexPath.row == 7){
        height = self.sportTimePickerVisible ? 191.0f : 0.0f;
    }
    
    if (indexPath.row == 9){
        height = self.mariedPickerVisible ? 191.0f : 0.0f;
    }

    if (indexPath.row == 11){
        height = self.travelPickerVisible ? 191.0f : 0.0f;
    }
    if (indexPath.row == 12){
        height = 220.0f;
    }
    
    return height;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag==1){
        
        NSDictionary *aDictionary = (NSDictionary*)self.occupationData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            
            [self.lblOccupation setText:[aDictionary objectForKey:key]];
            
        }
//        NSDictionary *aDictionary = (NSDictionary*)self.occupationData[row];
//        [aDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [self.lblOccupation setText:key];
//        }];

        
    }else if (pickerView.tag==2){
        
        NSDictionary *aDictionary = (NSDictionary*)self.sportData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            
            [self.sportLabel setText:[aDictionary objectForKey:key]];
            
        }
        
    }else if (pickerView.tag==3){
        
        NSDictionary *aDictionary = (NSDictionary*)self.sportTimeData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            
            [self.sportTimeLabel setText:[aDictionary objectForKey:key]];
            
        }
        
    }else if (pickerView.tag==4){
        
        NSDictionary *aDictionary = (NSDictionary*)self.mariedData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            
            [self.mariedLabel setText:[aDictionary objectForKey:key]];
            
        }
        
        
    }else if (pickerView.tag==5){
        
        NSDictionary *aDictionary = (NSDictionary*)self.travelData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            
            [self.travelLabel setText:[aDictionary objectForKey:key]];
            
        }
       
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (self.occupationPickerVisible){
            self.occupationPickerVisible = NO;
            [self hidePickerCell:self.occupationPicker];
        } else {
            self.occupationPickerVisible = YES;
            [self showPickerCell:self.occupationPicker];
        }
    }
    else if (indexPath.row == 4) {
        if (self.sportPickerVisible){
            self.sportPickerVisible = NO;
            [self hidePickerCell:self.sportPicker];
            
        } else {
            self.sportPickerVisible = YES;
            [self showPickerCell:self.sportPicker];
            
        }
    }
    else if (indexPath.row == 6) {
        if (self.sportTimePickerVisible){
            self.sportTimePickerVisible = NO;
            [self hidePickerCell:self.sportTimePicker];
            
        } else {
            self.sportTimePickerVisible = YES;
            [self showPickerCell:self.sportTimePicker];
            
        }
    }
    else if (indexPath.row == 8) {
        if (self.mariedPickerVisible){
            self.mariedPickerVisible = NO;
            [self hidePickerCell:self.mariedPicker];
            
        } else {
            self.mariedPickerVisible = YES;
            [self showPickerCell:self.mariedPicker];
            
        }
    }
    else if (indexPath.row == 10) {
        if (self.travelPickerVisible){
            self.travelPickerVisible = NO;
            [self hidePickerCell:self.travelPicker];
            
        } else {
            self.travelPickerVisible = YES;
            [self showPickerCell:self.travelPicker];
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowData= [[NSString alloc] init];
    if(pickerView.tag==1){
        //rowData =  self.occupationData[row];
        NSDictionary *aDictionary = (NSDictionary*)self.occupationData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            rowData = [aDictionary objectForKey:key];
            
        }
    }else if (pickerView.tag==2){
        
        NSDictionary *aDictionary = (NSDictionary*)self.sportData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            rowData = [aDictionary objectForKey:key];
            
        }
    }else if (pickerView.tag==3){
        
        NSDictionary *aDictionary = (NSDictionary*)self.sportTimeData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            rowData = [aDictionary objectForKey:key];
            
        }
    }
    else if (pickerView.tag==4){
        NSDictionary *aDictionary = (NSDictionary*)self.mariedData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            rowData = [aDictionary objectForKey:key];
            
        }
        
    }else if (pickerView.tag==5){
        NSDictionary *aDictionary = (NSDictionary*)self.travelData[row];
        for (NSString* key in aDictionary.allKeys)
        {
            rowData = [aDictionary objectForKey:key];
            
        }
        
    }
    return rowData;
}
- (IBAction)updateProfile:(id)sender {
    
    // for the previous profile
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.myProfile = self.tmpBackgroundProfile;
    
    // then it will be update for the new selection
    NSMutableDictionary *myBackground = [[NSMutableDictionary alloc] init];
    NSInteger row;
    
    if([self.occupationData count]>0){
        // get hidden value of the occupation picker
        row = [self.occupationPicker selectedRowInComponent:0];
        NSDictionary *selectedRowOccupation = (NSDictionary*)[self.occupationData objectAtIndex:row];
        
        [selectedRowOccupation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //NSLog(@"Key: %@ and Object %@", key, obj);
            
            [myBackground setObject:key forKey:@"occupation"];
        }];
    }
    
    
    if([self.sportTimeData count] >0){
        // get hidden value of the sport time picker
        row = [self.sportTimePicker selectedRowInComponent:0];
        NSDictionary *selectedRowSportTime = (NSDictionary*)[self.sportTimeData objectAtIndex:row];
        
        [selectedRowSportTime enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //NSLog(@"Key: %@ and Object %@", key, obj);
            [myBackground setObject:key forKey:@"sport_time"];
        }];
    }
    
    if([self.sportData count] >0){
        // get hidden value of the sport picker
        row = [self.sportPicker selectedRowInComponent:0];
        NSDictionary *selectedRowSport = (NSDictionary*)[self.sportData objectAtIndex:row];
        
        [selectedRowSport enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //NSLog(@"Key: %@ and Object %@", key, obj);
            [myBackground setObject:key forKey:@"sport"];
        }];
    }
    
    if([self.mariedData count] >0){
        // get hidden value of the marital picker
        row = [self.mariedPicker selectedRowInComponent:0];
        NSDictionary *selectedRowMarried = (NSDictionary*)[self.mariedData objectAtIndex:row];
        
        [selectedRowMarried enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //NSLog(@"Key: %@ and Object %@", key, obj);
            [myBackground setObject:key forKey:@"marital_status"];
        }];
    }
    
    if([self.travelData count]>0){
        // get hidden value of the travel picker
        row = [self.travelPicker selectedRowInComponent:0];
        NSDictionary *selectedRowTravel = (NSDictionary*)[self.travelData objectAtIndex:row];
        
        [selectedRowTravel enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //NSLog(@"Key: %@ and Object %@", key, obj);
            [myBackground setObject:key forKey:@"travel"];
        }];
    }
    
//    for (NSString* key in myBackground.allKeys)
//    {
//        // Key: travel, object: 03
//        //NSLog(@"Key: %@, object: %@ ", key, [myBackground objectForKey:key]);
//
//    }
    if([myBackground count] >0){
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.myProfile = myBackground;
        
        NSDictionary *post = @{@"uid": [FIRAuth auth].currentUser.uid,
                               @"occupation": [myBackground objectForKey:@"occupation"],
                               @"sport_time": [myBackground objectForKey:@"sport_time"],
                               @"sport": [myBackground objectForKey:@"sport"],
                               @"marital_status": [myBackground objectForKey:@"marital_status"],
                               @"travel": [myBackground objectForKey:@"travel"]
                               };
        
        [[[self.dbRef child:@"profile"] child:[FIRAuth auth].currentUser.uid] setValue:post withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
            if (error) {
                //NSLog(@"Save profile background could not be saved: %@", error);
                [self showMessage:@"Profile background could not be saved"];
            } else {
                //NSLog(@"Profile background saved successfully.");
                
                [self showMessage:@"Profile background saved successfully."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
    }else{
        [self showMessage:@"Data is not ready to update, please select some fields."];
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
@end
