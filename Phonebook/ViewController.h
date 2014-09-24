//
//  ViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-06.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet NSString *countryName;

@property (strong, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;


- (IBAction)signUpButton:(id)sender;
- (IBAction)showCountryList:(id)sender;


@end

