//
//  PersonalViewController.h
//  emeditation
//
//  Created by admin on 30/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "ToastViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *occupationPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *mariedPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *travelPicker;
@property (weak, nonatomic) IBOutlet UILabel *lblOccupation;
@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sportTimeImageView;

@property (weak, nonatomic) IBOutlet UILabel *mariedLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *OccupationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *SportImageView;


@property (weak, nonatomic) IBOutlet UIImageView *MaritalStatusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TravelImageView;
@property (weak, nonatomic) IBOutlet UIPickerView *sportTimePicker;


@property BOOL occupationPickerVisible;
@property BOOL sportPickerVisible;
@property BOOL sportTimePickerVisible;
@property BOOL mariedPickerVisible;
@property BOOL travelPickerVisible;

@property NSMutableArray *occupationData;
@property NSMutableArray *sportData;
@property NSMutableArray *sportTimeData;
@property NSMutableArray *mariedData;
@property NSMutableArray *travelData;

@property (strong, nonatomic) NSMutableDictionary *tmpBackgroundProfile;

@property (strong, nonatomic) ToastViewController *refModalController;

@property (strong, nonatomic) FIRDatabaseReference *dbRef;

- (IBAction)updateProfile:(id)sender;



@end

NS_ASSUME_NONNULL_END
