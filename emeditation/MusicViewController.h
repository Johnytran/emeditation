//
//  MusicViewController.h
//  emeditation
//
//  Created by admin on 16/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "ListSongTableViewCell.h"
#import <Firebase/Firebase.h>
#import "Album.h"
#import "Song.h"
#import "AppDelegate.h"
#import "FLAnimatedImage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressModalViewController.h"
// check internet connection
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface MusicViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UITableViewDelegate, UITableViewDataSource, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (weak, nonatomic) IBOutlet UILabel *percentLoadingAlbumLabel;
@property (weak, nonatomic) IBOutlet iCarousel *albumList;
@property (strong, atomic) NSMutableArray *albumCollection;
@property NSIndexPath *indexPlaying;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *songArtistLabel;
@property (weak, nonatomic) FLAnimatedImageView *loadingImageSubView;
@property int numberAlbumDisplay;
@property (strong, atomic) NSMutableArray *songByAlbumIDArray;
@property (weak, nonatomic) IBOutlet UITableView *listSongTableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) UIButton *selectedPlayButton;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loadingView;

@property (weak, nonatomic) IBOutlet UIButton *playMainButton;
@property (weak, nonatomic) IBOutlet UIButton *nexMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *preMusicButton;

- (IBAction)playMusicAction:(id)sender;
- (void) PlayMusic: (NSString*) urlString;
- (IBAction)nextSongPlayButton:(id)sender;
- (IBAction)prevSongPlayButton:(id)sender;
@property (strong, nonatomic) AVAudioPlayer *player;
@property BOOL isPlayed;


@property (nonatomic) NSMutableData *musicData;
@property (nonatomic) float downloadSongSize;

@property (strong, nonatomic) ProgressModalViewController *refModalController;

@property (strong, nonatomic) NSManagedObjectContext *managedContext;

@property (nonatomic) NSMutableArray *arrayAlbumCoreData;
@property (nonatomic) NSString * documentsDirectoryPath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *writablePath;
@property (nonatomic) NSString *theFileName;

- (void)stopAllCell: (NSIndexPath*)exceptIndex;

@end

NS_ASSUME_NONNULL_END
