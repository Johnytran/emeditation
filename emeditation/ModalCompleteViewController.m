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

@implementation ModalCompleteViewController
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
    //self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        //self.view.transform = CGAffineTransformMakeScale(1, 1);
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


- (void) showView: (CGRect) frame{
    
    [self.view setFrame: frame];
    [[self.parentController view] addSubview:self.view];
}
@end
