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

@end

@implementation NOWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://imgs.xkcd.com/comics/now.png"]]]];
}


@end
