//
//  LengthViewController.h
//  emeditation
//
//  Created by admin on 22/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LengthCollectionViewCell.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LengthViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (strong, nonatomic) NSMutableArray *arrayTime;
@property (strong, nonatomic) NSMutableArray *arrayCell;
@property (strong, nonatomic) NSArray *arrayPickerTime;
@property (weak, nonatomic) IBOutlet UIView *timeSetView;
- (IBAction)setTime:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickTimeView;
@property (weak, nonatomic) IBOutlet UIView *timeSettingView;
@property (weak, nonatomic) IBOutlet UIButton *SetButton;

@property (weak, nonatomic) IBOutlet UIButton *moreTimeButton;
@property BOOL isExtra;
@property (strong, nonatomic) NSString *selectedTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;


- (IBAction)MoreTime:(id)sender;
- (IBAction)Cancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
