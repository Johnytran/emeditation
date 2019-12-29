//
//  CornerTextField.m
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "CornerTextField.h"

@implementation CornerTextField

- (void)drawRect:(CGRect)rect {
    [self.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [self.layer setCornerRadius: 18];
    self.clipsToBounds=YES;
    [self.layer setMasksToBounds:YES];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}

@end
