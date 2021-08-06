//
//  ViewController.h
//  emeditation
//
//  Created by admin on 15/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@import Firebase;
@import GoogleSignIn;
@import AuthenticationServices;
@import CommonCrypto;



@interface ViewController : UIViewController<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInBUtton;
- (IBAction)SignInGoogle:(id)sender;
- (IBAction)AddAccount:(id)sender;
- (IBAction)GuestSignIn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *appleVIew;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (strong, nonatomic) NSString *currentNonce;

@end

