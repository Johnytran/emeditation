//
//  ViewController.m
//  emeditation
//
//  Created by admin on 15/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize logoLabel, signInBUtton;
- (void)viewDidLoad {
    [super viewDidLoad];

    

    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    

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
// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)SignInGoogle:(id)sender {
    
    
    
    // animate button loading
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.signInBUtton.frame.size.height,
                                                         self.signInBUtton.frame.size.width, self.signInBUtton.frame.size.height)];
    [v setBackgroundColor:[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0]];
    v.userInteractionEnabled = NO;
    v.exclusiveTouch = NO;
    [self.signInBUtton addSubview:v];
    
    [UIView animateWithDuration:3 animations:^{
        
        CGRect currentRect = v.frame;
        currentRect.origin.y = 0;
        [v setAlpha:1];
        [v setFrame:currentRect];
        [self.signInBUtton sendSubviewToBack:v];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GIDSignIn sharedInstance] signIn];
    });
}

- (IBAction)AddAccount:(id)sender {
    [self performSegueWithIdentifier:@"addAccountSeque" sender:sender];
}
@end
