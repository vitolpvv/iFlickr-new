//
//  ViewController.m
//  iFlickr
//
//  Created by VitaliyP on 07.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPhotosPressed:(UIBarButtonItem *)sender {
    FCLocation location;
    location.latitude = 59.0;
    location.longitude = 39.0;
    float radius = 1;
    FlickrClient *client = [FlickrClient new];
    [client getPhotosWithLocation:location distance:radius completion:^(id data, BOOL success) {
        if (success) {
            
        } else {
            NSLog(@"Request photos finished with error %@", data);
        }
    }];
}

@end
