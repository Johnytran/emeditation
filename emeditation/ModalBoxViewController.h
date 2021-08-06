//
//  ModalBoxViewController.h
//  emeditation
//
//  Created by admin on 17/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartSessionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModalBoxViewController : UIViewController
- (void)removeAnimate;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)likeSong:(id)sender;
- (IBAction)disLikeSong:(id)sender;
-(void)getParentController: (UIViewController*) parent;
@property UIViewController *parentController;
- (void) showView: (CGRect) frame;
@end

NS_ASSUME_NONNULL_END
