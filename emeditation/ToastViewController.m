//
//  ToastViewController.m
//  emeditation
//
//  Created by admin on 31/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ToastViewController.h"

@interface ToastViewController ()

@end

@implementation ToastViewController
@synthesize massageLabel, textContent;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.massageLabel setText:self.textContent];
    
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAnimate];
    });
    [self showAnimate];
}

@end
