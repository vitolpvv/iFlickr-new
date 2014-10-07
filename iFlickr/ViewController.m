//
//  ViewController.m
//  iFlickr
//
//  Created by VitaliyP on 07.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic,strong) NSArray *photos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(59.926711, 30.317589), MKCoordinateSpanMake(.02, .02));
    [self.mapView setRegion:region animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getPhotosInfoPressed:(UIBarButtonItem *)sender {
//    FCLocation location = {59.936426,30.310750};
//    location.latitude = 59.936426;
//    location.longitude = 30.310750;
//    float radius = 2;
    FCRegion region = [self p_makeFCRegionFromMapViewRegion:self.mapView.region];
    FlickrClient *client = [FlickrClient new];
    [client getPhotosInfoWithRegion:region completion:^(id data, BOOL success) {
        if (success) {
            [self.mapView removeAnnotations:self.mapView.annotations];
        } else {
            NSLog(@"Request photos finished with error %@", data);
        }
    }];
}

- (FCRegion)p_makeFCRegionFromMapViewRegion:(MKCoordinateRegion)mapRegion {
    FCRegion region;
    region.minimum_latitude = mapRegion.center.latitude - mapRegion.span.latitudeDelta;
    region.minimum_longitude = mapRegion.center.longitude - mapRegion.span.longitudeDelta;
    region.maximum_latitude = mapRegion.center.latitude + mapRegion.span.latitudeDelta;
    region.maximum_longitude = mapRegion.center.longitude + mapRegion.span.longitudeDelta;
    return region;
}

@end
