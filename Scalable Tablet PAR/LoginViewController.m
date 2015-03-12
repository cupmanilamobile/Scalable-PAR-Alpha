//
//  LoginViewController.m
//  Scalable Tablet PAR
//
//  Created by Julius Lundang on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "RegisterViewController.h"

static NSString * const kClientId = @"836816363012-g6f7embp8j6hgppb4gg20j62vp2f5939.apps.googleusercontent.com";

@interface LoginViewController () {
    GPPSignIn *signIn;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //    signIn.scopes = @[ @"profile" ];            // "profile" scope
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    __block BOOL proceed = NO;
    UIButton *button = (UIButton *) sender;
    if ([button.titleLabel.text isEqualToString:@"Login"]) {
        if ([[_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                NSError *error;
                PFUser *user = [PFUser logInWithUsername:_txtUsername.text password:_txtPassword.text error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error) {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    } else if (user) {
                        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
                    }
                });
            });
        }
        
        if ([[_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            _txtUsername.backgroundColor = [UIColor redColor];
        }
        
        if ([[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            _txtPassword.backgroundColor = [UIColor redColor];
        }
    } else {
        proceed = YES;
    }
    
    return proceed;
    
}
- (IBAction)forgotPassword:(id)sender {
    if ([_txtUsername.text length] > 0 && [RegisterViewController NSStringIsValidEmail:_txtUsername.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:@"Kindly check your email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [PFUser requestPasswordResetForEmailInBackground:_txtUsername.text];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalide username / email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (IBAction)actionFacebook:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [hud hide:YES];
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occured: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew)
            {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        }
    }];
}

- (IBAction)actionTwitter:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        [hud hide:YES];
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        } else {
            NSLog(@"User logged in with Twitter!");
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        }
    }];
}

#pragma mark - GPPSignInDelegate
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    NSLog(@"user email %@  user id %@  user data %@, ",auth.userEmail,auth.userID, auth.userData);
    
    NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSError *error;
        // 1
        PFUser *user = [PFUser user];
        // 2
        user.username = auth.userEmail;
        user.password = @"Y0\\/c/\nTc33ME!";
        user.email = auth.userEmail;
        user[@"firstName"] = signIn.googlePlusUser.name.givenName;
        user[@"lastName"] = signIn.googlePlusUser.name.familyName;
        // 3
        [user signUp:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                int errorCode = [[[error userInfo] objectForKey:@"code"] intValue];
                if (errorCode == 202) {
                    [PFUser logInWithUsernameInBackground:auth.userEmail password:@"Y0\\/c/\nTc33ME!" block:^(PFUser *user, NSError *error) {
                        [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
                    }];
                }
            } else if (user) {
                [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            }
        });
    });
}
@end
