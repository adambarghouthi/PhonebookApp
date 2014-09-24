//
//  ViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-06.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "ViewController.h"
#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#define kCountriesFileName @"countries.json"

@interface ViewController () <UITextFieldDelegate> {
    NSArray *countriesList;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    self.userName.delegate = self;
    self.userPassword.delegate = self;
    
    self.countryName = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    self.countryNameLabel.text = self.countryName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL _isAllowed = YES;
    
    NSString *tempString = [[self.userName.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.userName.text isEqualToString:tempString] || [tempString length] >= 18) {
        _isAllowed = NO;
    }
    return _isAllowed;
   
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view setFrame:CGRectMake(0, -54, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectCountry:(NSDictionary *)country {
    
    NSLog(@"Selected Country : %@", country);
    _countryCodeLabel.text = [country valueForKey:kCountryCallingCode];
    _countryNameLabel.text = [country valueForKey:kCountryCode];
    
}

- (void) checkingFieldsComplete {
    
    if ([_countryCodeLabel.text isEqualToString:@"+ code"] || [_phoneNumber.text isEqualToString:@""] || [_userName.text isEqualToString:@""] || [_userPassword.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"One or more fields are incomplete." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else
        [self registerNewUser];
    
}

- (void) registerNewUser {
    
    [_signUpBtn setTitle:@"Signing Up..." forState:UIControlStateNormal];
    [_signUpBtn setEnabled:NO];
    
    NSLog(@"Signing up...");
    PFUser *newUser = [PFUser user];
    NSString *fullName = @"";
    NSString *occupation = @"";
    NSString *websiteURL = @"";
    NSNumber *contactsNumber = [NSNumber numberWithInt:0];
    
    newUser.username = _userName.text;
    newUser.password = _userPassword.text;
    [newUser setObject:_countryCodeLabel.text forKey:@"CountryCode"];
    [newUser setObject:_phoneNumber.text forKey:@"PhoneNumber"];
    [newUser setObject:_countryNameLabel.text forKey:@"CountryName"];
    
    [newUser setObject:fullName forKey:@"FullName"];
    [newUser setObject:occupation forKey:@"Occupation"];
    [newUser setObject:websiteURL forKey:@"WebsiteURL"];
    [newUser setObject:contactsNumber forKey:@"ContactsNumber"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Sign up unsuccessful.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Sign up unsuccessful, please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            [_signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
            [_signUpBtn setEnabled:YES];
        }
        else {
            NSLog(@"Sign up successful!");
            
            [_signUpBtn setTitle:@"Complete!" forState:UIControlStateNormal];
            [_signUpBtn setEnabled:NO];
            
            [[PFInstallation currentInstallation] setObject:newUser forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];
            
            [self continueToAppAfterLogin];
        }
    }];
    
}

- (void) continueToAppAfterLogin {
    
    [self performSegueWithIdentifier:@"login" sender:self];
    
}


- (IBAction)showCountryList:(id)sender {
    
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self presentViewController:cv animated:YES completion:NULL];
    
}


- (IBAction)signUpButton:(id)sender {
    
    [self checkingFieldsComplete];

}


@end
