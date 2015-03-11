//
//  RegisterViewController.m
//  Scalable Tablet PAR
//
//  Created by Julius Lundang on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface RegisterViewController () {
    BOOL _willTransitionToPortrait;
    UITraitCollection *_traitCollection_CompactRegular;
    UITraitCollection *_traitCollection_AnyAny;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email / Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtRePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Country" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    __block BOOL proceed = NO;

    
    

    return proceed;
}

/**
 Determin if string is a valid email
 @param checkString NSString to be checked
 @returns BOOL
 @exception nil
 */
- (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (IBAction)actionFacebook:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
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
        }
    }];
}
- (IBAction)actionGoogle:(id)sender {
}
- (IBAction)actionTwitter:(id)sender {
}
- (IBAction)actionRegister:(id)sender {
    BOOL proceed = YES;
    if ([[_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtUsername.backgroundColor = [UIColor redColor];
        _txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username / Username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtUsername.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self NSStringIsValidEmail:_txtUsername.text]) {
        _txtUsername.backgroundColor = [UIColor redColor];
        _txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email / Username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtUsername.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtPassword.backgroundColor = [UIColor redColor];
        _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtPassword.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[_txtRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtRePassword.backgroundColor = [UIColor redColor];
        _txtRePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtRePassword.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[_txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtFirstName.backgroundColor = [UIColor redColor];
        _txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtFirstName.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtLastName.backgroundColor = [UIColor redColor];
        _txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtLastName.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[_txtCountry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _txtCountry.backgroundColor = [UIColor redColor];
        _txtCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Country" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtCountry.backgroundColor = [UIColor whiteColor];
    }
    
    if (![_txtPassword.text isEqualToString:_txtRePassword.text]) {
        _txtPassword.backgroundColor = [UIColor redColor];
        _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        _txtRePassword.backgroundColor = [UIColor redColor];
        _txtRePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}];
        proceed = NO;
    } else {
        _txtPassword.backgroundColor = [UIColor whiteColor];
        _txtRePassword.backgroundColor = [UIColor whiteColor];
    }
    if (proceed) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            NSError *error;
            // 1
            PFUser *user = [PFUser user];
            // 2
            user.username = _txtUsername.text;
            user.password = _txtPassword.text;
            user.email = _txtUsername.text;
            user[@"firstName"] = _txtFirstName.text;
            user[@"lastName"] = _txtLastName.text;
            user[@"country"] = _txtCountry.text;
            // 3
            [user signUp:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alertView show];
                } else if (user) {
                    [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                }
            });
        });
    }
}

- (IBAction)actionReset:(id)sender {
    _txtUsername.text = @"";
    _txtPassword.text = @"";
    _txtRePassword.text = @"";
    _txtFirstName.text = @"";
    _txtLastName.text = @"";
    _txtCountry.text = @"";
    
    _txtUsername.backgroundColor = [UIColor whiteColor];
    _txtPassword.backgroundColor = [UIColor whiteColor];
    _txtRePassword.backgroundColor = [UIColor whiteColor];
    _txtFirstName.backgroundColor = [UIColor whiteColor];
    _txtLastName.backgroundColor = [UIColor whiteColor];
    _txtCountry.backgroundColor = [UIColor whiteColor];
    
    _txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email / Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtRePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _txtCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Country" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
}
- (IBAction)cancelRegistration:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
