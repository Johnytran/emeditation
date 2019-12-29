//
//  ModalBoxViewController.h
//  emeditation
//
//  Created by admin on 17/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModalBoxViewController : UIViewController
- (IBAction)nextButton:(id)sender;
- (void)removeAnimate;
@property (weak, nonatomic) IBOutlet UIView *popView;
- (void) showView: (UIView *) parentView  withFrame: (CGRect) frame;
@end

NS_ASSUME_NONNULL_END
