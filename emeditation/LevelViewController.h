//
//  LevelViewController.h
//  emeditation
//
//  Created by admin on 27/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelCollectionViewCell.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LevelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
- (IBAction)setLevel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (strong, nonatomic) NSMutableArray *arrayTime;
@property (strong, nonatomic) NSMutableArray *arrayCell;

@property (strong, nonatomic) NSString *selectedLevel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;
- (IBAction)Cancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
