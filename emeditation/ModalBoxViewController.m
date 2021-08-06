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
@synthesize contentView, parentController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.shadowOpacity = 0.8;
    self.contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
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
-(void)getParentController: (StartSessionViewController*) parent{
    self.parentController = parent;
}


- (IBAction)likeSong:(id)sender {
    StartSessionViewController *parent = (StartSessionViewController*)self.parentController;
    [parent setIsLike:1];
    [self removeAnimate];
    [parent processRecommend];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [parent.navigationController popToRootViewControllerAnimated:YES];
    });
    
}

- (IBAction)disLikeSong:(id)sender {
    StartSessionViewController *parent = (StartSessionViewController*)self.parentController;
    [parent setIsLike:0];
    [self removeAnimate];
    [parent processRecommend];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [parent.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void) showView: (CGRect) frame{
    
    [self.view setFrame: frame];
    //[parentView addSubview:self.view];
    [[self.parentController view] addSubview:self.view];
}
@end
