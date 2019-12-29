//
//  CircularProgressView.h
//  emeditation
//
//  Created by admin on 20/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircularProgressView : UIView
@property (nonatomic) IBInspectable int progress;
@property UIColor *outlineColor;
@property UIColor *counterColor;
@end

NS_ASSUME_NONNULL_END
