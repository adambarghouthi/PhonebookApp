//
//  loginViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-06.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginButton:(id)sender;

@end
