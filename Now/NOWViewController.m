//
//  NOWViewController.m
//  Now
//
//  Created by Mark Hambly on 2/26/14.
//  Copyright (c) 2014 Mark Hambly. All rights reserved.
//

#import "NOWViewController.h"

@interface NOWViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NOWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLocalTime) userInfo:nil repeats:YES];
    self.imageURL = [NSURL URLWithString:@"http://imgs.xkcd.com/comics/now.png"];
    [self loadImage];
}

- (IBAction)refreshButtonTouched:(id)sender {
    [self loadImage];
}

- (void) loadImage {
    [self.refreshButton setEnabled:NO];
    [self.activityIndicator startAnimating];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:self.imageURL
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    [self.imageView setImage: [UIImage imageWithData:data]];
                }
                [self.refreshButton setEnabled:YES];
                [self.activityIndicator stopAnimating];
            }] resume];
}

- (void) updateLocalTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm:ss a, z"];
    self.localTimeLabel.text = [df stringFromDate:[NSDate date]];
}

@end
