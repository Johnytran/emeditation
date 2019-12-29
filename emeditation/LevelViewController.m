//
//  LevelViewController.m
//  emeditation
//
//  Created by admin on 27/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "LevelViewController.h"

@interface LevelViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LevelViewController
@synthesize timeCollectionView, arrayTime, setButton, arrayCell, selectedLevel, cancelTrailing;

- (void)viewDidAppear:(BOOL)animated{
    CGFloat timeCollectionViewWidth = self.timeCollectionView.frame.size.width;
    self.cancelTrailing.constant = timeCollectionViewWidth/2+25;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
        CGFloat timeCollectionViewWidth = self.timeCollectionView.frame.size.width;
        self.cancelTrailing.constant = timeCollectionViewWidth/2+25;
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // loading the selected session time
    NSMutableDictionary *myProfile = [[NSMutableDictionary alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myProfile = delegate.myProfile;
    
    // get selected time
    self.selectedLevel =  [myProfile objectForKey:@"session_level"];
    if(self.selectedLevel==nil)
        self.selectedLevel = @"1";
    
    
    self.arrayCell = [[NSMutableArray alloc] init];
    self.arrayTime = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    [timeCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrayTime count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"myLevelCell";
    [self.timeCollectionView registerNib:[UINib nibWithNibName:@"LevelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    LevelCollectionViewCell *cell = [timeCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if([self.arrayTime count]){
        [[cell levelLabel] setText:[self.arrayTime objectAtIndex:indexPath.row]];
        if(self.selectedLevel==[self.arrayTime objectAtIndex:indexPath.row]){
            cell.bgImageView.image = [UIImage imageNamed:@"length_on"];
        }
        [self.arrayCell addObject:cell];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([arrayCell count]>0){
        for(LevelCollectionViewCell *aCell in arrayCell){
            aCell.bgImageView.image = [UIImage imageNamed:@"minCir"];
        }
    }
    LevelCollectionViewCell *cell = (LevelCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.image = [UIImage imageNamed:@"length_on"];
    self.selectedLevel = [cell.levelLabel text];
}

- (IBAction)setLevel:(id)sender {
    
    if(self.selectedLevel){
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *myProfile = delegate.myProfile;
        [myProfile setObject:self.selectedLevel forKey:@"session_level"];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
