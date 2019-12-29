//
//  ToastViewController.h
//  emeditation
//
//  Created by admin on 31/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *massageLabel;
- (void) showView: (UIView *) parentView withFrame: (CGRect) frame;
- (void)removeAnimate;

@property (strong, nonatomic) NSString *textContent;
@end

NS_ASSUME_NONNULL_END
