//
//  DetailViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-15.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSString *usernameContent;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) NSString *fullNameContent;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) NSString *occupationContent;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) NSString *codeContent;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) NSString *phoneNumberContent;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) NSString *countryContent;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) NSString *emailContent;
@property (strong, nonatomic) IBOutlet UILabel *websiteLabel;
@property (strong, nonatomic) NSString *websiteContent;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) UIImage *profilePictureImg;

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;

- (IBAction)syncButton:(id)sender;
- (IBAction)callButton:(id)sender;
- (IBAction)mailButton:(id)sender;
- (IBAction)websiteButton:(id)sender;

@end
