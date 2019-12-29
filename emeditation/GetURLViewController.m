//
//  GetURLViewController.m
//  emeditation
//
//  Created by admin on 15/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "GetURLViewController.h"

@interface GetURLViewController ()

@end

@implementation GetURLViewController

@synthesize urlTextField, downloadButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloadButton.layer.cornerRadius = 10;
    self.view.layer.cornerRadius = 10;
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
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

- (IBAction)Process:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.urlCSVFile = self.urlTextField.text;
    
    [self removeAnimate];
    //NSLog(@"url: %@", urlText);
}

@end
