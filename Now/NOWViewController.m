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
@property (strong, nonatomic) UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;


@end

@implementation NOWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLocalTime) userInfo:nil repeats:YES];
    self.imageURL = [NSURL URLWithString:@"http://imgs.xkcd.com/comics/now.png"];
    [self.loadingLabel setHidden:YES];
    
    self.pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin30h"]];
    self.pinImageView.contentMode = UIViewContentModeBottom;
    self.pinImageView.frame = CGRectMake(self.timeZoneSelectedLabel.frame.origin.x + self.timeZoneSelectedLabel.frame.size.width + 10.0, self.timeZoneSelectedLabel.frame.origin.y - 12, 30, 48);
    [self.view addSubview:self.pinImageView];
    
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)]];
    
    self.notesLabel.text = @"";
    
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

- (IBAction)imageViewTouched:(id)sender {

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (touch.view == self.imageView){
    
        CGPoint location = [touch locationInView:self.view];
        NSLog(@"%f x, %f y",location.x, location.y);
        
        double xFromMid = location.x - self.view.frame.size.width/2.0;
        double yFromMid = location.y - self.view.frame.size.height/2.0;
        double angle = atan2(yFromMid, xFromMid);
        if (angle < 0)
            angle += 2*M_PI;
        
        angle = angle * 180 / M_PI;
        
        int hour = (int)(angle/15.0);
        
        if (hour < 6){
            hour += 18;
        } else {
            hour -= 6;
        }
        
        NSLog(@"hour %i",hour);
        
        NSLog(@"angle from mid %f degrees",angle);
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.pinImageView setFrame:CGRectMake(location.x - 15, location.y - 48, 30, 48)];
        }];
        
        NSTimeZone *timeZone = [self timeZoneForHour:hour];
        NSLog(@"time zone is %@",timeZone.name);
        self.timeZoneSelectedLabel.text = [timeZone localizedName:NSTimeZoneNameStyleStandard locale:[NSLocale currentLocale]];
        self.notesLabel.text = [self notesForHour:hour];
    }
    
}

- (NSTimeZone*)timeZoneForHour:(int)hourSelected {

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"H"];
    
    int localHour = [df stringFromDate:[NSDate date]].intValue;
    
    int difference = hourSelected - localHour;
    
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSTimeInterval secondsFromGMT = [localTimeZone secondsFromGMT];
    double localGMT = (int)(secondsFromGMT / 60.0 / 60.0);
    
    double newGMT = localGMT + difference;
    
    if (newGMT < -10.0)
        newGMT +=24;
    if (newGMT > 13.0)
        newGMT -=24;
    
    return [NSTimeZone timeZoneForSecondsFromGMT:newGMT * 60 * 60];

    
}

- (NSString *)notesForHour:(int)hourSelected {
    if (hourSelected >= 9 && hourSelected < 17){
        return @"It's business time.";
    } else if (hourSelected >=22 || hourSelected < 8){
        return @"Rude to call.";
    } else {
        return @"";
    }
    
}

- (NSString *)regionsForHour:(int)hourSelected {
  
    return @"";
}

- (NSString *)continentsForHour:(int)hourSelected {
    
    
    return @"";
}

@end
