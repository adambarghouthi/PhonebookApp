//
//  ProfileViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-08.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *ProfPic;
@property (strong, nonatomic) IBOutlet UIImage *profPicImage;

@property (strong, nonatomic) IBOutlet NSString *segue;

@property (strong, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *savedLabel;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *websiteURL;
@property (strong, nonatomic) IBOutlet UITextField *occupation;
@property (strong, nonatomic) IBOutlet UIButton *saveChanges;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UITextField *fullName;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;


- (IBAction)imagePicker:(id)sender;
- (IBAction)logoutButton:(id)sender;
- (IBAction)saveChangesButton:(id)sender;
- (IBAction)countryPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end
