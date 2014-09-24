//
//  loginViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-06.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "loginViewController.h"
#import <Parse/Parse.h>

@interface loginViewController ()

@end

@implementation loginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL _isAllowed = YES;
    
    NSString *tempString = [[self.usernameField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.usernameField.text isEqualToString:tempString] || [tempString length] >= 18) {
        _isAllowed = NO;
    }
    return _isAllowed;
    
}

- (IBAction)loginButton:(id)sender {
    
    [_loginBtn setTitle:@"Logging In..." forState:UIControlStateNormal];
    [_loginBtn setEnabled:NO];
    
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
        if(!error) {
            NSLog(@"Login user!");
                        
            [_usernameField resignFirstResponder];
            [_passwordField resignFirstResponder];
            
            [_loginBtn setTitle:@"Complete!" forState:UIControlStateNormal];
            [_loginBtn setEnabled:NO];
            
            [[PFInstallation currentInstallation] setObject:user forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];
            
            [self performSegueWithIdentifier:@"login" sender:self];

        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Sorry, try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
            [_loginBtn setEnabled:YES];
        }
    }];
    
}
@end
