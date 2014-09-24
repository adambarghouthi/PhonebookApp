//
//  FirstViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-07.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

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
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
    PFUser *user = [PFUser currentUser];
    
    if (user.username != nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
