//
//  Song.h
//  emeditation
//
//  Created by admin on 18/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject
@property (strong, nonatomic) NSString *songID;
@property (strong, nonatomic) NSString *songName;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *artistID;
@property (strong, nonatomic) NSString *songLink;
@property (strong, nonatomic) NSString *introtext;
@property (strong, nonatomic) NSNumber *songScore;

@end

NS_ASSUME_NONNULL_END
