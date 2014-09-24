//
//  SearchViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-29.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

- (IBAction)addUserButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *usernameSearchField;
@property (strong, nonatomic) IBOutlet UILabel *requestSentLabel;
@property (strong, nonatomic) IBOutlet UIButton *addUserBtn;

@end
