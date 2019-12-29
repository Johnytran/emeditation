//
//  RecommendModalViewController.h
//  emeditation
//
//  Created by admin on 24/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecomendRowTableViewCell.h"
#import <Firebase/Firebase.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendModalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *waveSongImageView;
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;

@property NSMutableArray *songData;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@property (nonatomic) NSString * documentsDirectoryPath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *writablePath;
@property (nonatomic) NSString *theFileName;
@property (strong, nonatomic) NSMutableDictionary *historySession;

@property (strong, nonatomic) AVAudioPlayer *player;
@property NSIndexPath *parentIndex;
@property BOOL expandRow;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


- (void)stopAllCellNonExcep;
-(void)fadeOutAllTool;
- (void)stopAllCell: (NSIndexPath*)exceptIndex;
- (void) PlayMusic: (NSString*) urlString;

- (void)removeAnimate;
- (void) showView: (UIView *) parentView withFrame: (CGRect) frame;

- (IBAction)closeRecommend:(id)sender;


@end

NS_ASSUME_NONNULL_END
