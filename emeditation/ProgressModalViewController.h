//
//  ProgressModalViewController.h
//  emeditation
//
//  Created by admin on 23/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressModalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dowloadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *percentImageView;
- (void) showView: (UIView *) parentView withFrame: (CGRect) frame;
- (void)removeAnimate;
@end

NS_ASSUME_NONNULL_END
