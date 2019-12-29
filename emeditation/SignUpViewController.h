//
//  SignUpViewController.h
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MeditationTabBarController.h"
#import "HomeNavigationController.h"
#import "CornerTextField.h"
#import "ToastViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet CornerTextField *emailTextfield;
- (IBAction)Cancel:(id)sender;
- (IBAction)SIgnUp:(id)sender;
@property (weak, nonatomic) IBOutlet CornerTextField *passWordTextfield;
@property (weak, nonatomic) IBOutlet CornerTextField *confirmPasswordTextfield;

@property (strong, nonatomic) ToastViewController *refModalController;
- (IBAction)CheckingConfirm:(id)sender;
- (IBAction)CheckingEmail:(id)sender;

@end

NS_ASSUME_NONNULL_END
