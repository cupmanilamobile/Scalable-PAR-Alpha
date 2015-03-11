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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    
}
@end
