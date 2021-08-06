//
//  Profile.h
//  emeditation
//
//  Created by Owner on 8/1/20.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *travel;
@property (strong, nonatomic) NSString *sport;
@property (strong, nonatomic) NSString *sport_time;
@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *marital_status;

- (void)getProfileDB:(FIRDatabaseReference*) dbRef completion:(nullable void(^)( Profile * _Nullable data))callback;

@end

NS_ASSUME_NONNULL_END
