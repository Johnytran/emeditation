//
//  LevelCollectionViewCell.h
//  emeditation
//
//  Created by admin on 27/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

NS_ASSUME_NONNULL_END
