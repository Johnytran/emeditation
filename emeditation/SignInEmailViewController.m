//
//  SignInEmailViewController.m
//  emeditation
//
//  Created by admin on 4/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "SignInEmailViewController.h"

@interface SignInEmailViewController ()

@end

@implementation SignInEmailViewController
@synthesize logoLabel, emailTextField, passWordTextfield, refModalController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [self animateLogo];
}
- (void)animateLogo{
    UIColor *glowColor = [UIColor greenColor];
    self.logoLabel.layer.shadowColor = [glowColor CGColor];
    self.logoLabel.layer.shadowRadius = 8.0f;
    self.logoLabel.layer.shadowOpacity = .8;
    self.logoLabel.layer.shadowOffset = CGSizeZero;
    self.logoLabel.layer.masksToBounds = NO;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:5.0];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 1.5;
    anim.repeatCount = HUGE_VALF;
    anim.autoreverses=YES;
    [self.logoLabel.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.logoLabel.layer.shadowOpacity = 0.0;
}


- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SignIn:(id)sender {
    NSString *email = [emailTextField text];
    NSString *password = [passWordTextfield text];
    
    if(email.length>0 && password.length >0){
        
        [[FIRAuth auth] signInWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 if(error==nil){
                                     [self showMessage:@"Welcome to meditation garden!"];
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self performSegueWithIdentifier:@"signinTotabSeque" sender:nil];
                                     });
                                     
                                 }else{
                                     [self showMessage:@"It has an error in loging"];
                                     NSLog(@"Error: %@", error);
                                 }
                             }];
        
    
    }else{
        [self showMessage:@"Please enter the textbox before sign in"];
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
