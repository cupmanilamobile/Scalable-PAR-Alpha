//
//  LoginViewController.h
//  Scalable Tablet PAR
//
//  Created by Julius Lundang on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface LoginViewController : UIViewController <GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
- (IBAction)forgotPassword:(id)sender;

- (IBAction)actionFacebook:(id)sender;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
- (IBAction)actionTwitter:(id)sender;
@end
