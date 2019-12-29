//
//  ResultViewController.h
//  emeditation
//
//  Created by admin on 13/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *probabilityLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *probabilityView;

@property AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableDictionary *myProfile;

- (IBAction)CompleteSession:(id)sender;


@end

NS_ASSUME_NONNULL_END
