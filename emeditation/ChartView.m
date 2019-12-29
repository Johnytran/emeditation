//
//  ChartView.m
//  emeditation
//
//  Created by admin on 13/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView
@synthesize excitement, engagement, relax, stress, interest;

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    CGFloat lineWidth = 1;
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [linePath setLineWidth: lineWidth];
    [[UIColor grayColor] setStroke];
    
    float posY = bounds.size.height * 0.1;
    float percentSpace = bounds.size.height * 0.1;
    for(int i=0; i<100; i+=10){
        
        
        [linePath moveToPoint:CGPointMake(0, posY)];
        [linePath addLineToPoint:CGPointMake(bounds.size.width, posY)];
        posY += percentSpace;
    }
    
    [linePath stroke];
    NSMutableArray *arrayFillColor = [[NSMutableArray alloc] init];
    [arrayFillColor addObject:[UIColor colorWithRed:0.67 green:0.83 blue:0.45 alpha:1.0]]; // excitement
    [arrayFillColor addObject:[UIColor colorWithRed:0.85 green:0.72 blue:0.46 alpha:1.0]]; //Engagement
    [arrayFillColor addObject:[UIColor colorWithRed:0.90 green:0.37 blue:0.46 alpha:1.0]]; // relax
    [arrayFillColor addObject:[UIColor colorWithRed:0.23 green:0.82 blue:0.82 alpha:1.0]]; // stress
    [arrayFillColor addObject:[UIColor colorWithRed:0.40 green:0.25 blue:0.82 alpha:1.0]]; // interest
   
    
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    [arrayData addObject:[NSNumber numberWithInt:self.excitement]];
    [arrayData addObject:[NSNumber numberWithInt:self.engagement]];
    [arrayData addObject:[NSNumber numberWithInt:self.relax]];
    [arrayData addObject:[NSNumber numberWithInt:self.stress]];
    [arrayData addObject:[NSNumber numberWithInt:self.interest]];
    
    
    float colX = 10;
    float percentSpaceX = bounds.size.width * 0.15;
    for(int i=0;i<[arrayFillColor count];i++){
        CAShapeLayer* outsideShapeLayer = [[CAShapeLayer alloc] init];
        outsideShapeLayer.fillColor = [[arrayFillColor objectAtIndex:i] CGColor];
        int originPercent = [[arrayData objectAtIndex:i] intValue];
        
        float percent = [[arrayData objectAtIndex:i] intValue]/100.0f;
        float percentHeight = - (bounds.size.height * percent);
        
        outsideShapeLayer.frame = CGRectMake(colX, bounds.size.height, 20, percentHeight);
        outsideShapeLayer.path = [[UIBezierPath bezierPathWithRoundedRect:outsideShapeLayer.bounds cornerRadius:20]CGPath];
        
        [self.layer addSublayer:outsideShapeLayer];
        
        float numberY = outsideShapeLayer.frame.origin.y;
        
        UILabel *percentNumber = [[UILabel alloc] initWithFrame:CGRectMake(colX-5, numberY- 40, 50, 50)];
        [percentNumber setTextColor:[UIColor whiteColor]];
        [percentNumber setText:[NSString stringWithFormat:@"%d%%", originPercent]];
        
        [self addSubview:percentNumber];
        
        colX+=percentSpaceX;
    }
    

}


@end
