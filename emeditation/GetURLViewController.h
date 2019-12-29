//
//  GetURLViewController.h
//  emeditation
//
//  Created by admin on 15/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetURLViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;


- (void)removeAnimate;
- (void) showView: (UIView *) parentView  withFrame: (CGRect) frame;
- (IBAction)Process:(id)sender;

@end

NS_ASSUME_NONNULL_END
