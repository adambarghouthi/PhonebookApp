//
//  CameraViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-23.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "CameraViewController.h"
#import "ProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@interface CameraViewController ()

@property NSData *imageDataGlobal;
@property CGSize sizeCrop;

@end

@implementation CameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

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
    [self.scroller setContentSize:CGSizeMake(320, 568)];
    
    self.profImage.layer.cornerRadius = self.profImage.bounds.size.width/2.0;
    self.profImage.layer.borderWidth = 6.0f;
    self.profImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profImage.clipsToBounds = YES;
    
    self.sizeCrop = CGSizeMake(288, 288);
}

- (void)viewDidAppear:(BOOL)animated {
    
    session = [[AVCaptureSession alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset352x288];
    else
        [session setSessionPreset:AVCaptureSessionPreset352x288];

    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    inputDevice = [self frontCamera];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.cameraView.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    //////////////////////////
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This allows for sole front camera capture
- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

// Capturing image
// Image data to (void)resizeImage
- (IBAction)captureImage:(id)sender {
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            self.imageDataGlobal = [NSData dataWithData:imageData];
            UIImage *tempImg = [UIImage imageWithData:imageData];
            
            //crop image to square
            CGRect cropRect = CGRectMake(0, 0, self.sizeCrop.height, self.sizeCrop.width);
            CGImageRef imageRef = CGImageCreateWithImageInRect([tempImg CGImage], cropRect);
            
            UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:3];
            CGImageRelease(imageRef);
            
            self.profImage.image = cropped;
        }
    }];
    
}

// upload image button
- (IBAction)usePhoto:(id)sender {
    
    NSData *data = UIImageJPEGRepresentation(self.profImage.image, 0.5f);
    PFFile *imgFile = [PFFile fileWithData:data];
    PFUser *user = [PFUser currentUser];
    
    [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [user setObject:imgFile forKey:@"ProfilePic"];
            [user saveInBackground];
            [session stopRunning];
        }
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"backToProfile"]) {
        [[segue destinationViewController] setProfPicImage:self.profImage.image];
        [[segue destinationViewController] setSegue:@"backToProfile"];
    }
    
}

@end
