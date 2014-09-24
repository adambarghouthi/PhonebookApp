//
//  DetailViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-15.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "DetailViewController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>

@interface DetailViewController () <MFMailComposeViewControllerDelegate,ABNewPersonViewControllerDelegate>

@end

@implementation DetailViewController

@synthesize profilePictureImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 680)];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.bounds.size.width/2.0;
    self.profilePicture.layer.borderWidth = 6.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePicture.clipsToBounds = YES;
    
    self.usernameLabel.text = self.usernameContent;
    self.fullNameLabel.text = self.fullNameContent;
    self.occupationLabel.text = self.occupationContent;
    self.codeLabel.text = self.codeContent;
    self.phoneNumberLabel.text = self.phoneNumberContent;
    self.countryLabel.text = self.countryContent;
    self.emailLabel.text = self.emailContent;
    self.websiteLabel.text = self.websiteContent;
    self.profilePicture.image = self.profilePictureImg;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// finishing mailcomposecontroller
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

// finishing adding new contact to native contacts app or cancelling
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// syncing contact into native contacts app
- (IBAction)syncButton:(id)sender {
    
    NSString *fullName = self.fullNameContent;
    NSArray *firstLastNames = [fullName componentsSeparatedByString:@" "];
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@", self.codeLabel.text,self.phoneNumberLabel.text];
    
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    
    ABRecordRef newContact = ABPersonCreate();
    CFErrorRef error = NULL;
    
    // first and last name pre-fill
    if (![fullName isEqualToString:@"full name N/A"]) {
        ABRecordSetValue(newContact, kABPersonFirstNameProperty, (__bridge CFTypeRef)firstLastNames[0], &error);
        ABRecordSetValue(newContact, kABPersonLastNameProperty, (__bridge CFTypeRef)firstLastNames[1], &error);
    }
    
    // website pre-fill
    if (![self.websiteContent isEqualToString:@"website N/A"]) {
        ABMutableMultiValueRef websiteMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(websiteMultiValue, (__bridge CFTypeRef)self.websiteContent, (CFStringRef)@"home page", NULL);
        ABRecordSetValue(newContact, kABPersonURLProperty, websiteMultiValue, &error);
    }
    
    // phonenumber pre-fill
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)phoneNumber, (CFStringRef)@"main", NULL);
    ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumberMultiValue, &error);
    
    // email pre-fill
    if (![self.emailContent isEqualToString:@"email N/A"]) {
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)self.emailContent, (CFStringRef)@"work", NULL);
        ABRecordSetValue(newContact, kABPersonEmailProperty, emailMultiValue, &error);
    }
    
    // note pre-fill
    ABRecordSetValue(newContact, kABPersonNoteProperty, (__bridge CFTypeRef)@"Added from Phonebook", &error);
    
    [picker setDisplayedPerson:newContact];
    [self presentViewController:navigation animated:YES completion:nil];

}

// calling phonebook contact
- (IBAction)callButton:(id)sender {
    
    UIApplication *callApp = [UIApplication sharedApplication];
    NSString *phoneNumber = [NSString stringWithFormat:@"telprompt://%@%@", self.codeLabel.text,self.phoneNumberLabel.text];
    NSLog(@"making call with %@",phoneNumber);
    [callApp openURL:[NSURL URLWithString:phoneNumber]];
    
}

// mailing phonebook contact
- (IBAction)mailButton:(id)sender {
    
    NSArray *array = [NSArray arrayWithObject:self.emailContent];
    NSLog(@"%@", array);
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        [controller setToRecipients:array];
        [controller setMessageBody:@"\n\n\nSent using Phonebook.\n\n\n\n\n\n" isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        // Handle the error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention." message:@"Please connect your email account to the Mail app in your iPhone." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

// directing user to website of phonebook contact
- (IBAction)websiteButton:(id)sender {
    
    NSString *website = [NSString stringWithFormat:@"http://%@", self.websiteContent];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    
}

@end
