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
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *loadingTimer;
@property (strong, nonatomic) NSString *loadingString;

@end

@implementation NOWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLocalTime) userInfo:nil repeats:YES];
    self.imageURL = [NSURL URLWithString:@"http://imgs.xkcd.com/comics/now.png"];
    [self.loadingLabel setHidden:YES];
    [self loadImage];
}

- (IBAction)refreshButtonTouched:(id)sender {
    [self loadImage];
}

- (void) loadImage {
    [self startLoadingTimer];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError){
            [self.imageView setImage: [UIImage imageWithData:data]];
        }
        [self stopLoadingTimer];
    }];
}

- (void) updateLocalTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"h:mm:ss a, z"];
    self.localTimeLabel.text = [df stringFromDate:[NSDate date]];
}

- (void) startLoadingTimer {
    [self.refreshButton setHidden:YES];
    [self.loadingLabel setHidden:NO];
    [self.loadingTimer invalidate];
    self.loadingString = @"Loading";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animateLoading) userInfo:nil repeats:YES];
}

- (void)animateLoading {
    if (self.loadingString.length < 10){
        self.loadingString = [self.loadingString stringByAppendingString:@"."];
    } else {
        self.loadingString = @"Loading";
    }
    self.loadingLabel.text = self.loadingString;
}

- (void)stopLoadingTimer {
    [self.loadingTimer invalidate];
    [self.loadingLabel setHidden:YES];
    [self.refreshButton setHidden:NO];
}

@end
