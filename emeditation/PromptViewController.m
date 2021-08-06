//
//  PromptViewController.m
//  emeditation
//
//  Created by Owner on 6/4/20.
//  Copyright © 2020 admin. All rights reserved.
//

#import "PromptViewController.h"

@interface PromptViewController ()

@end

@implementation PromptViewController
@synthesize parentController, lblText, textContent;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblText.layer.cornerRadius = 10;
    [self.lblText setText:textContent];
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
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
-(void)getParentController: (MusicViewController*) parent{
    self.parentController = parent;
}


- (IBAction)CancelDownload:(id)sender {
    MusicViewController *parent = (MusicViewController*) self.parentController;
    [parent CancelDownload];
}

- (IBAction)PerformDownload:(id)sender {
    MusicViewController *parent = (MusicViewController*) self.parentController;
    [parent PerformDownload];
}

- (void) showView: (CGRect) frame{
    
    [self.view setFrame: frame];
    [[self.parentController view] addSubview:self.view];
}

@end
