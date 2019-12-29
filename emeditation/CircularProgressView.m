//
//  CircularProgressView.m
//  emeditation
//
//  Created by admin on 20/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "CircularProgressView.h"

@implementation CircularProgressView
@synthesize counterColor, outlineColor, progress;
int NoOfGlasses = 8;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self != nil) {
        progress = 5;
    }
    
    return self;
}

-(void)setCounter:(int)inCounter {
    if (progress <= NoOfGlasses) {
        progress = inCounter;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect {
    
    [self setCounterColor:[UIColor colorWithRed:87.0f/255.0f green:218.0f/255.0f blue:213.0f/255.0f alpha:1.0f]];
    [self setOutlineColor:[UIColor colorWithRed:34.0f/255.0f green:110.0f/255.0f blue:110.0f/255.0f alpha:1.0f]];
    
    CGRect bounds = self.bounds;
    
    // Draw base arc
    CGPoint center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    CGFloat radius = MIN(bounds.size.width,bounds.size.height);
    CGFloat arcWidth = 6.0;
    CGFloat startAngle = 3 * M_PI / 4;
    CGFloat endAngle = M_PI / 4;
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2 - arcWidth/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [aPath setLineWidth:arcWidth];
    [counterColor setStroke];
    [aPath stroke];
    
    //Outline arc
    CGFloat angleDifference = 2 * M_PI - startAngle + endAngle;
    CGFloat arcLengthPerGlass = angleDifference / (CGFloat)NoOfGlasses;
    CGFloat outlineEndAngle = arcLengthPerGlass * (CGFloat)[self progress] + startAngle;

    //draw outer arc
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithArcCenter:center radius:bounds.size.width/2-5 startAngle:startAngle endAngle:outlineEndAngle clockwise:YES];
    //draw inner arc
    [outlinePath addArcWithCenter:center radius:bounds.size.width/2 - arcWidth+2.5 startAngle:outlineEndAngle endAngle:startAngle clockwise:NO];
    //close path
    [outlinePath closePath];

    [outlineColor setStroke];
    [outlinePath setLineWidth:5.0f];
    [outlinePath stroke];
}

@end
