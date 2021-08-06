//
//  ProgressModalViewController.m
//  emeditation
//
//  Created by admin on 23/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ProgressModalViewController.h"

@interface ProgressModalViewController ()

@end

@implementation ProgressModalViewController
@synthesize dowloadingLabel, percentImageView;
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void) showView: (UIView *) parentView withFrame: (CGRect) frame{
    [self.view setFrame: frame];
    [parentView addSubview:self.view];
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


@end
