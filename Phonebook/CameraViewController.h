//
//  CameraViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-23.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIImageView *profImage;
@property (strong, nonatomic) IBOutlet UIView *cameraView;

- (IBAction)usePhoto:(id)sender;
- (IBAction)captureImage:(id)sender;


@end
