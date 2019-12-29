//
//  WhiteLineButton.m
//  emeditation
//
//  Created by admin on 16/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "WhiteLineButton.h"

@implementation WhiteLineButton

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 20;
    self.layer.borderColor = [self borderColor].CGColor;
    self.layer.masksToBounds = true;
    self.layer.borderWidth=1.0f;
    self.clipsToBounds = YES;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    
}

@end
