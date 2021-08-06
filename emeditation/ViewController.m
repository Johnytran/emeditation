//
//  ViewController.m
//  emeditation
//
//  Created by admin on 15/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize logoLabel, signInBUtton, currentNonce;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [GIDSignIn sharedInstance].presentingViewController = self;
    
    if (@available(iOS 13.0, *)) {
        [self observeAppleSignInState];
        
        // Sign In With Apple Button
        ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton new];
            
        appleIDButton.frame =  CGRectMake((self.appleVIew.frame.size.width/2)-(190/2), .0, 190, 37);
        
        CGRect frame = appleIDButton.frame;
        appleIDButton.frame = frame;
        appleIDButton.cornerRadius = CGRectGetHeight(appleIDButton.frame) * 0.5;
        [self.appleVIew addSubview:appleIDButton];
        [appleIDButton addTarget:self action:@selector(signInWithApplePressed:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        // Fallback on earlier versions
    }
    

}

- (void)signInWithApplePressed:(UIButton *)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isGuest = 0;
    if (@available(iOS 13.0, *)) {
        NSString *nonce = [self randomNonce:32];
        self.currentNonce = nonce;
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        request.nonce = [self stringBySha256HashingString:nonce];

        ASAuthorizationController *authorizationController =
            [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}


- (NSString *)randomNonce:(NSInteger)length {
  NSAssert(length > 0, @"Expected nonce to have positive length");
  NSString *characterSet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._";
  NSMutableString *result = [NSMutableString string];
  NSInteger remainingLength = length;

  while (remainingLength > 0) {
    NSMutableArray *randoms = [NSMutableArray arrayWithCapacity:16];
    for (NSInteger i = 0; i < 16; i++) {
      uint8_t random = 0;
      int errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random);
      NSAssert(errorCode == errSecSuccess, @"Unable to generate nonce: OSStatus %i", errorCode);

      [randoms addObject:@(random)];
    }

    for (NSNumber *random in randoms) {
      if (remainingLength == 0) {
        break;
      }

      if (random.unsignedIntValue < characterSet.length) {
        unichar character = [characterSet characterAtIndex:random.unsignedIntValue];
        [result appendFormat:@"%C", character];
        remainingLength--;
      }
    }
  }

  return result;
}






- (void)observeAppleSignInState {
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)handleSignInWithAppleStateChanged:(id)noti {
    NSLog(@"%@", noti);
}
- (void)dealloc {
    
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}
//! Tells the delegate from which window it should present content to the user.
 - (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"window：%s", __FUNCTION__);
    return self.view.window;
}

- (void)handleAuthrization:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        
        // Creates a new Apple ID authorization request.
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        // The contact information to be requested from the user during authentication.
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        // A controller that manages authorization requests created by a provider.
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        
        // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
        controller.delegate = self;
        
        // A delegate that provides a display context in which the system can present an authorization interface to the user.
        controller.presentationContextProvider = self;
        
        // starts the authorization flows named during controller initialization.
        [controller performRequests];
    }
}

- (NSString *)stringBySha256HashingString:(NSString *)input {
  const char *string = [input UTF8String];
  unsigned char result[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256(string, (CC_LONG)strlen(string), result);

  NSMutableString *hashed = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
  for (NSInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
    [hashed appendFormat:@"%02x", result[i]];
  }
  return hashed;
}


- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
  if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
    ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
    NSString *rawNonce = self.currentNonce;
    NSAssert(rawNonce != nil, @"Invalid state: A login callback was received, but no login request was sent.");

    if (appleIDCredential.identityToken == nil) {
      NSLog(@"Unable to fetch identity token.");
      return;
    }

    NSString *idToken = [[NSString alloc] initWithData:appleIDCredential.identityToken
                                              encoding:NSUTF8StringEncoding];
    if (idToken == nil) {
      NSLog(@"Unable to serialize id token from data: %@", appleIDCredential.identityToken);
    }

    // Initialize a Firebase credential.
    FIROAuthCredential *credential = [FIROAuthProvider credentialWithProviderID:@"apple.com"
                                                                        IDToken:idToken
                                                                       rawNonce:rawNonce];

    // Sign in with Firebase.
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRAuthDataResult * _Nullable authResult,
                                           NSError * _Nullable error) {
      if (error != nil) {
        // Error. If error.code == FIRAuthErrorCodeMissingOrInvalidNonce,
        // make sure you're sending the SHA256-hashed nonce as a hex string
        // with your request to Apple.
        return;
      }
      // Sign-in succeeded!
        [self performSegueWithIdentifier:@"signinAppleSeque" sender:self];
    }];
  }
}

- (void)authorizationController:(ASAuthorizationController *)controller
           didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
  NSLog(@"Sign in with Apple errored: %@", error);
}



//- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
//
////    NSLog(@"%s", __FUNCTION__);
////    NSLog(@"%@", controller);
////    NSLog(@"%@", authorization);
//
//    NSLog(@"authorization.credential：%@", authorization.credential);
//
//    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
//        // ASAuthorizationAppleIDCredential
////        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
////        NSString *user = appleIDCredential.user;
////        [[NSUserDefaults standardUserDefaults] setValue:user forKey:setCurrentIdentifier];
////        [mStr appendString:user?:@""];
////        NSString *familyName = appleIDCredential.fullName.familyName;
////        [mStr appendString:familyName?:@""];
////        NSString *givenName = appleIDCredential.fullName.givenName;
////        [mStr appendString:givenName?:@""];
////        NSString *email = appleIDCredential.email;
////        [mStr appendString:email?:@""];
//        //NSLog(@"user：%@", user);
//        [self performSegueWithIdentifier:@"signinGoogleSeque" sender:self];
//
//    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
////        ASPasswordCredential *passwordCredential = authorization.credential;
////        NSString *user = passwordCredential.user;
////        NSString *password = passwordCredential.password;
////        [mStr appendString:user?:@""];
////        [mStr appendString:password?:@""];
////        [mStr appendString:@"\n"];
//        //NSLog(@"user：%@", user);
//        [self performSegueWithIdentifier:@"signinGoogleSeque" sender:self];
//    } else {
//
//    }
//}

//- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
//
//    NSLog(@"%s", __FUNCTION__);
//    NSLog(@"error ：%@", error);
//    NSString *errorMsg = nil;
//    switch (error.code) {
//        case ASAuthorizationErrorCanceled:
//            errorMsg = @"ASAuthorizationErrorCanceled";
//            break;
//        case ASAuthorizationErrorFailed:
//            errorMsg = @"ASAuthorizationErrorFailed";
//            break;
//        case ASAuthorizationErrorInvalidResponse:
//            errorMsg = @"ASAuthorizationErrorInvalidResponse";
//            break;
//        case ASAuthorizationErrorNotHandled:
//            errorMsg = @"ASAuthorizationErrorNotHandled";
//            break;
//        case ASAuthorizationErrorUnknown:
//            errorMsg = @"ASAuthorizationErrorUnknown";
//            break;
//    }
//
//    NSLog(@"errorMsg ：%@", errorMsg);
//
//    if (errorMsg) {
//        return;
//    }
//
//    if (error.localizedDescription) {
//        NSLog(@"localizedDescription ：%@", error.localizedDescription);
//    }
//    NSLog(@"controller requests：%@", controller.authorizationRequests);
//    /*
//     ((ASAuthorizationAppleIDRequest *)(controller.authorizationRequests[0])).requestedScopes
//     <__NSArrayI 0x2821e2520>(
//     full_name,
//     email
//     )
//     */
//}

- (void)perfomExistingAccountSetupFlows {
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        
        // An OpenID authorization request that relies on the user’s Apple ID.
        ASAuthorizationAppleIDRequest *authAppleIDRequest = [appleIDProvider createRequest];
        
        // A mechanism for generating requests to perform keychain credential sharing.
        ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];
        
        NSMutableArray <ASAuthorizationRequest *>* mArr = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [mArr addObject:authAppleIDRequest];
        }
        if (passwordRequest) {
            [mArr addObject:passwordRequest];
        }
        // ASAuthorizationRequest：A base class for different kinds of authorization requests.
        NSArray <ASAuthorizationRequest *>* requests = [mArr copy];
        
        // A controller that manages authorization requests created by a provider.
        // Creates a controller from a collection of authorization requests.
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];

        // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
        authorizationController.delegate = self;
        // A delegate that provides a display context in which the system can present an authorization interface to the user.
        authorizationController.presentationContextProvider = self;
        
        // starts the authorization flows named during controller initialization.
        [authorizationController performRequests];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    //[self perfomExistingAccountSetupFlows];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isGuest = 0;
    [self animateLogo];
}
- (void)animateLogo{
    UIColor *glowColor = [UIColor greenColor];
    self.logoLabel.layer.shadowColor = [glowColor CGColor];
    self.logoLabel.layer.shadowRadius = 8.0f;
    self.logoLabel.layer.shadowOpacity = .8;
    self.logoLabel.layer.shadowOffset = CGSizeZero;
    self.logoLabel.layer.masksToBounds = NO;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:5.0];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 1.5;
    anim.repeatCount = HUGE_VALF;
    anim.autoreverses=YES;
    [self.logoLabel.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.logoLabel.layer.shadowOpacity = 0.0;
}
// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
    dismissViewController:(UIViewController *)viewController {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isGuest = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)SignInGoogle:(id)sender {
    
    
    
    // animate button loading
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.signInBUtton.frame.size.height,
                                                         self.signInBUtton.frame.size.width, self.signInBUtton.frame.size.height)];
    [v setBackgroundColor:[UIColor colorWithRed:0.23 green:0.18 blue:0.64 alpha:1.0]];
    v.userInteractionEnabled = NO;
    v.exclusiveTouch = NO;
    [self.signInBUtton addSubview:v];
    
    [UIView animateWithDuration:3 animations:^{
        
        CGRect currentRect = v.frame;
        currentRect.origin.y = 0;
        [v setAlpha:1];
        [v setFrame:currentRect];
        [self.signInBUtton sendSubviewToBack:v];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GIDSignIn sharedInstance] signIn];
    });
}

- (IBAction)GuestSignIn:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isGuest = 1;
    [self performSegueWithIdentifier:@"guestSignIn" sender:sender];
    
    
}

- (IBAction)AddAccount:(id)sender {
    [self performSegueWithIdentifier:@"addAccountSeque" sender:sender];
}
@end
