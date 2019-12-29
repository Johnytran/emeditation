//
//  ViewController.h
//  emeditation
//
//  Created by admin on 15/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import GoogleSignIn;

@interface ViewController : UIViewController<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInBUtton;
- (IBAction)SignInGoogle:(id)sender;
- (IBAction)AddAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;

@end

