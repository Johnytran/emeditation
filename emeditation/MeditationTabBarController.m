//
//  MeditationTabBarController.m
//  emeditation
//
//  Created by admin on 18/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "MeditationTabBarController.h"

@interface MeditationTabBarController ()

@end

@implementation MeditationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelectedViewController:[self.viewControllers objectAtIndex:1]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
