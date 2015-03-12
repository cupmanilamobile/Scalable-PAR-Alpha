//
//  RegisterViewController.h
//  Scalable Tablet PAR
//
//  Created by Julius Lundang on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;

@interface RegisterViewController : UIViewController <GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;

- (IBAction)actionFacebook:(id)sender;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
- (IBAction)actionTwitter:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;

- (IBAction)actionRegister:(id)sender;
- (IBAction)actionReset:(id)sender;

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
@end
