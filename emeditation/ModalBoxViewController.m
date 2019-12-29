//
//  ModalBoxViewController.m
//  emeditation
//
//  Created by admin on 17/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ModalBoxViewController.h"

@interface ModalBoxViewController ()

@end

@implementation ModalBoxViewController
@synthesize popView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.popView.layer.cornerRadius = 10;
    self.popView.layer.shadowOpacity = 0.8;
    self.popView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self showAnimate];
    
}
- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}
- (void) showView: (UIView *) parentView withFrame: (CGRect) frame{
    [self.view setFrame: frame];
    [parentView addSubview:self.view];
}


- (IBAction)nextButton:(id)sender {
    [self removeAnimate];
}
@end
