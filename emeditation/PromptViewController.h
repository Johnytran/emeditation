//
//  PromptViewController.h
//  emeditation
//
//  Created by Owner on 6/4/20.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PromptViewController : UIViewController

- (void)removeAnimate;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property UIViewController *parentController;
@property (strong, nonatomic) NSString *textContent;
- (void) showView: (CGRect) frame;
- (IBAction)PerformDownload:(id)sender;
- (IBAction)CancelDownload:(id)sender;

@end

NS_ASSUME_NONNULL_END
