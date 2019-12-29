//
//  SignUpViewController.m
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SignUpViewController.h"


@interface SignUpViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation SignUpViewController
@synthesize contentView, heightView, logoLabel, emailTextfield, passWordTextfield, confirmPasswordTextfield, refModalController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    CGFloat heightScreen = self.view.frame.size.height;
    if(heightScreen>600){
        self.heightView.constant = 900;
    }
    
    if(heightScreen>800){
        self.heightView.constant = 1000;
    }
    [self.contentView setNeedsUpdateConstraints];
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
- (IBAction)SIgnUp:(id)sender {
    NSString *email = [emailTextfield text];
    NSString *passWord = [self.passWordTextfield text];
    NSString *confirmPass = [self.confirmPasswordTextfield text];
    
    //NSLog(@"email: %@, pass: %@, confirm: %@", email, passWord, confirmPass);
    
    if([passWord isEqualToString:confirmPass]){
        if (passWord.length<6) {
            [self showMessage:@"Password must be 6 characters long or more."];
        }else{
            if(![self validateEmailWithString:email]){
                [self showMessage:@"Email is invalid."];
            }else{
                [[FIRAuth auth] createUserWithEmail:email
                                           password:passWord
                                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                                      NSError * _Nullable error) {
                                             if(error==nil){
                                                 [self showMessage:@"User has been created."];
                                                 
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                     [self performSegueWithIdentifier:@"tabscreen" sender:self];;
                                                 });
                                                 
                                                 
                                                 
                                             }else{
                                                 [self showMessage:@"Cannot create an user."];
                                                 NSLog(@"Cannot create user: %@",error);
                                             }
                                         }];
                
            }
        }
        
        
    }else{
        [self showMessage:@"password and the confirm are not match."];
    }
   
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)CheckingConfirm:(id)sender {
    NSString *passWord = [passWordTextfield text];
    NSString *confirmPass = [confirmPasswordTextfield text];
    self.confirmPasswordTextfield.layer.cornerRadius = 20;
    if(passWord!=confirmPass){
        UIColor *glowColor = [UIColor redColor];
        self.confirmPasswordTextfield.layer.shadowColor = [glowColor CGColor];
        self.confirmPasswordTextfield.layer.shadowRadius = 8.0f;
        self.confirmPasswordTextfield.layer.shadowOpacity = .8;
        self.confirmPasswordTextfield.layer.shadowOffset = CGSizeZero;
        self.confirmPasswordTextfield.layer.masksToBounds = NO;
        
        
    }else{
        self.confirmPasswordTextfield.layer.shadowOpacity = 0;
    }
}

- (IBAction)CheckingEmail:(id)sender {
    NSString *email = [emailTextfield text];
    if(![self validateEmailWithString:email]){
        UIColor *glowColor = [UIColor redColor];
        self.emailTextfield.layer.shadowColor = [glowColor CGColor];
        self.emailTextfield.layer.shadowRadius = 8.0f;
        self.emailTextfield.layer.shadowOpacity = .8;
        self.emailTextfield.layer.shadowOffset = CGSizeZero;
        self.emailTextfield.layer.masksToBounds = NO;
    }else{
        self.emailTextfield.layer.shadowOpacity = 0;
    }
}
@end
