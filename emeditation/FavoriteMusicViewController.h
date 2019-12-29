//
//  FavoriteMusicViewController.h
//  emeditation
//
//  Created by admin on 4/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteSongTableViewCell.h"
#import <Firebase/Firebase.h>
#import "Song.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMusicViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSMutableArray *songData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentView;

@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@property (nonatomic) NSString * documentsDirectoryPath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *writablePath;
@property (nonatomic) NSString *theFileName;

- (void)stopAllCellNonExcep;
@property (strong, nonatomic) AVAudioPlayer *player;

- (void)stopAllCell: (NSIndexPath*)exceptIndex;

- (void) PlayMusic: (NSString*) urlString;

@end

NS_ASSUME_NONNULL_END
