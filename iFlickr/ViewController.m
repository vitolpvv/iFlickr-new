//
//  ViewController.m
//  iFlickr
//
//  Created by VitaliyP on 07.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"
#import "FlickrPhotosParser.h"
#import "Photo.h"
#import "PhotoAnnotation.h"
@import CoreLocation;

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self p_updeateMapViewWhithLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (IBAction)getPhotosInfoPressed:(UIBarButtonItem *)sender {
    FCRegion region = [self p_makeFCRegionFromMapViewRegion:self.mapView.region];
    FlickrClient *client = [FlickrClient new];
    [client getPhotosInfoWithRegion:region completion:^(id data, BOOL success) {
        if (success) {
            [self p_parsePhotosInfoWithData:data[@"photos"][@"photo"]];
            [self.mapView removeAnnotations:self.mapView.annotations];
        } else {
            NSLog(@"Request photos finished with error %@", data);
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if it is not our office model class annotation just return nil
    //to show annotaion of default presentation style
    if (![annotation isKindOfClass:[Photo class]]){
        return nil;
    }
    NSString *identifier = @"PhotoIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView){
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation
                                                     reuseIdentifier:identifier];
    }
    annotationView.image = [UIImage imageNamed:@"cat_face"];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (!view.leftCalloutAccessoryView) {
        __block MKAnnotationView *annotationView = view;
        __block Photo *photo = view.annotation;
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(backgroundQueue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.urlImageSquare]]];
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [annotationView setLeftCalloutAccessoryView:imageView];
            });
        });
    }
}

- (void)p_parsePhotosInfoWithData:(id)data {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        NSArray *parsedPhotos = [[FlickrPhotosParser new] photosWithInfo:data];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self p_addPhotosOnMapView:parsedPhotos];
        });
    });
}

- (void)p_addPhotosOnMapView:(NSArray *)photos {
    self.photos = photos;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photos];
//    [self.mapView showAnnotations:self.photos animated:YES];
    NSLog(@"parsing complete");
}

- (void)p_updeateMapViewWhithLocation:(CLLocation *)location {    
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.02, .02));
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}

- (FCRegion)p_makeFCRegionFromMapViewRegion:(MKCoordinateRegion)mapRegion {
    CLLocationCoordinate2D center = mapRegion.center;
    MKCoordinateSpan span = mapRegion.span;
    FCRegion region;
    region.minimum_latitude = center.latitude - span.latitudeDelta;
    region.minimum_longitude = center.longitude - span.longitudeDelta;
    if (region.minimum_longitude < 0) {
        region.minimum_longitude += 180;
    }
    region.maximum_latitude = center.latitude + span.latitudeDelta;
    region.maximum_longitude = center.longitude + span.longitudeDelta;
    if (region.maximum_longitude > 180) {
        region.maximum_longitude -= 180;
    }
    return region;
}

@end
