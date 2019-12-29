//
//  Album.h
//  emeditation
//
//  Created by admin on 17/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Album : NSObject
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSData *albumPhotoCover;
@end

NS_ASSUME_NONNULL_END
