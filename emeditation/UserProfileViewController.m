//
//  UserProfileViewController.m
//  emeditation
//
//  Created by admin on 29/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
@synthesize userImageButton, heightContentView, userNameLabel, stRef;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stRef = [[FIRStorage storage] reference];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    
    NSData *data = [NSData dataWithContentsOfURL:[user photoURL]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [userImageButton setImage:img forState:UIControlStateNormal];
    
    [userNameLabel setText:[user displayName]];
    
    //creating round user photo
    self.userImageButton.layer.cornerRadius = 50;
    
    // set dynamic height constraint
    CGFloat heightScreen = self.view.frame.size.height;
    if(heightScreen>600){
        self.heightContentView.constant = 800;
    }
    
    if(heightScreen>800){
        self.heightContentView.constant = 800;
    }
    if(heightScreen>1000){
        self.heightContentView.constant = 900;
    }
    //NSLog(@"%f", heightScreen);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (IBAction)signout:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [[GIDSignIn sharedInstance] signOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)UpdatePhotoAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIControlState state = UIControlStateNormal;
    
    if (chosenImage != nil)
    {
        FIRStorage *storage = [FIRStorage storage];
        self.stRef = [storage referenceForURL:@"gs://meditation-f0fd5.appspot.com/user"];
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName = [NSString stringWithFormat:@"ProfilePictures/%@.jpg",imageID];
        FIRStorageReference *profilePicRef = [self.stRef child:imageName];
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.8);
        
        [profilePicRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
         {
             if (!error)
             {
                 [profilePicRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                     if (error != nil) {
                         // Uh-oh, an error occurred!
                     } else {
                         
                         //NSLog(@"download url: %@", URL);
                         FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                         changeRequest.photoURL = URL;
                         [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                             [[self userImageButton] setImage:chosenImage forState:state];
                             [picker dismissViewControllerAnimated:YES completion:NULL];
                         }];
                     }
                 }];
                 
             }
             else if (error)
             {
                 NSLog(@"Failed to upload image");
             }
         }];
    }
    
    
    
}
@end
