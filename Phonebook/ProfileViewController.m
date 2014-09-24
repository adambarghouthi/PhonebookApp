//
//  ProfileViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-08.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "ProfileViewController.h"
#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "ViewController.h"
#import <Parse/Parse.h>
@import MobileCoreServices;

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.scroller setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 680)];
    
    self.ProfPic.layer.cornerRadius = self.ProfPic.bounds.size.width/2.0;
    self.ProfPic.layer.borderWidth = 6.0f;
    self.ProfPic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ProfPic.clipsToBounds = YES;
    
    PFUser * user = [PFUser currentUser];
    
    _profileUsernameLabel.text = user.username;
    _userEmail.text = user.email;
    _fullName.text = [user objectForKey:@"FullName"];
    _countryCodeLabel.text = [user objectForKey:@"CountryCode"];
    _countryNameLabel.text = [user objectForKey:@"CountryName"];
    _phoneNumberField.text = [user objectForKey:@"PhoneNumber"];
    _occupation.text = [user objectForKey:@"Occupation"];
    _websiteURL.text = [user objectForKey:@"WebsiteURL"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (BOOL)translatesAutoresizingMaskIntoConstraints {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    PFUser *user = [PFUser currentUser];
    PFImageView *profilePicture = [[PFImageView alloc] init];
    
    if ([_segue isEqualToString: @"backToProfile"]) {
        self.ProfPic.image = self.profPicImage;
        
    }
    else if ([user objectForKey:@"ProfilePic"] != NULL && ![_segue isEqualToString:@"backToProfile"]) {
        profilePicture.file = [user objectForKey:@"ProfilePic"];
        [profilePicture loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                self.ProfPic.image = image;
            }
        }];
    }
    else {
        self.ProfPic.image = [UIImage imageNamed:@"userDefaultPic"];    
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view setFrame:CGRectMake(0, -155, self.view.frame.size.width, self.view.frame.size.height)];
    }];
        
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

- (void)didSelectCountry:(NSDictionary *)country {
    
    NSLog(@"Selected Country : %@", country);
    _countryCodeLabel.text = [country valueForKey:kCountryCallingCode];
    _countryNameLabel.text = [country valueForKey:kCountryCode];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length >= 40 && range.length == 0) {
        return NO;
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveChanges:(UIButton *)sender {
    

    [_saveBtn setEnabled:NO];
    
    PFUser * user = [PFUser currentUser];
    
    [user setObject:_userEmail.text forKey:@"email"];
    [user setObject:_fullName.text forKey:@"FullName"];
    [user setObject:_countryCodeLabel.text forKey:@"CountryCode"];
    [user setObject:_countryNameLabel.text forKey:@"CountryName"];
    [user setObject:_phoneNumberField.text forKey:@"PhoneNumber"];
    [user setObject:_occupation.text forKey:@"Occupation"];
    [user setObject:_websiteURL.text forKey:@"WebsiteURL"];

    [user saveInBackground];
    
    _savedLabel.hidden = NO;
    _savedLabel.text = @"saved.";
    
    [_saveBtn setEnabled:YES];

}

- (IBAction)imagePicker:(id)sender {
    
    [self performSegueWithIdentifier:@"camera" sender:self];
    
}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (IBAction)saveChangesButton:(id)sender {
    
    [self saveChanges:sender];
    [self.fullName resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.userEmail resignFirstResponder];
    [self.occupation resignFirstResponder];
    [self.websiteURL resignFirstResponder];
    
}

- (IBAction)countryPicker:(id)sender {
    
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self presentViewController:cv animated:YES completion:NULL];
    
}

@end
