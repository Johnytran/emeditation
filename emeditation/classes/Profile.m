//
//  Profile.m
//  emeditation
//
//  Created by Owner on 8/1/20.
//  Copyright © 2020 admin. All rights reserved.
//

#import "Profile.h"
#import <Firebase/Firebase.h>
#import "FBLPromises.h"

@implementation Profile
@synthesize uid, sport, sport_time, occupation, marital_status;

- (void)getProfileDB:(FIRDatabaseReference*) dbRef completion:(nullable void (^)(Profile * _Nullable))callback{
    
      // initialise
      Profile *p = [[Profile alloc] init];
    NSString *uid = [FIRAuth auth].currentUser.uid;
      // get user profile from firebase and check each item value in the session and update if it is nil
    if(uid!=nil){
        FIRDatabaseQuery *profileQuery = [[[dbRef child:@"profile"] queryOrderedByKey] queryEqualToValue:uid];
        
          [profileQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
              
              if([snapshot exists]){
                  NSDictionary *tmp = snapshot.value;
    //              for (NSString *key in user) {
    //                  id value = user[key];
    //                  NSLog(@"Value: %@ for key: %@", value, key);
    //              }
                  //NSLog(@"sport: %@",tmp[uid][@"occupation"]);
                  NSString *occupationFRID = tmp[uid][@"occupation"];
                  NSString *sportFRID = tmp[uid][@"sport"];
                  NSString *sportTimeFRID = tmp[uid][@"sport_time"];
                  NSString *travelFRID = tmp[uid][@"travel"];
                  NSString *maritalStatusFRID = tmp[uid][@"marital_status"];
                  [p setUid:[FIRAuth auth].currentUser.uid];
                  [p setSport: sportFRID];
                  [p setTravel: travelFRID];
                  [p setOccupation: occupationFRID];
                  [p setMarital_status: maritalStatusFRID];
                  [p setSport_time: sportTimeFRID];
                  //NSLog(@"sport: %@",sportTimeFRID);
        //          NSLog(@"sport p: %@",[p marital_status]);
                  callback(p);
              }else{
                  NSLog(@"profile: nil test");
                  callback(nil);
              }
          }withCancelBlock:^(NSError * _Nonnull error) {
              //NSLog(@"profile: %@",error);
          }];
    }else{
        NSLog(@"profile: nil test");
        callback(nil);
    }
      //NSLog(@"profile: %@",p);
    
}

@end
