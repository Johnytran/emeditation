//
//  SignInEmailViewController.h
//  emeditation
//
//  Created by admin on 4/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
#import "CornerTextField.h"
#import "ToastViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignInEmailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
- (IBAction)Cancel:(id)sender;
- (IBAction)SignIn:(id)sender;
@property (weak, nonatomic) IBOutlet CornerTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CornerTextField *passWordTextfield;

@property (strong, nonatomic) ToastViewController *refModalController;

@end

NS_ASSUME_NONNULL_END
