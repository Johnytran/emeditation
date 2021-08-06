//
//  UserProfileViewController.h
//  emeditation
//
//  Created by admin on 29/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "AppDelegate.h"
@import Firebase;
@import GoogleSignIn;

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
- (IBAction)signout:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentView;
- (IBAction)UpdatePhotoAction:(id)sender;
@property (strong, nonatomic) FIRStorageReference *stRef;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

NS_ASSUME_NONNULL_END
