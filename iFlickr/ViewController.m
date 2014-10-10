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
#import "ShowPictureViewController.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) NSArray *photos;
@property (weak, nonatomic) Photo *currentPhoto;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
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
    __block MKAnnotationView *annotationView = view;
    __block Photo *photo = view.annotation;
    self.currentPhoto = photo;
    if (!view.leftCalloutAccessoryView) {
        
        UIButton *showImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [showImageButton setFrame:CGRectMake(0, 0, 50, 20)];
        [showImageButton setTitle:@"Show" forState:UIControlStateNormal];
        [showImageButton addTarget:self action:@selector(p_addOpenFotoButton) forControlEvents:UIControlEventTouchUpInside];
        
        [annotationView setLeftCalloutAccessoryView:showImageButton];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ShowPictureViewController class]]) {
        ShowPictureViewController *controller = segue.destinationViewController;
        NSURL *url = [NSURL URLWithString:self.currentPhoto.urlImageOriginal ? self.currentPhoto.urlImageOriginal : self.currentPhoto.urlImageLarge];
        controller.imageUrl = url;
        controller.title = self.currentPhoto.title;
    }
}

- (void)p_addOpenFotoButton {
    [self performSegueWithIdentifier:@"ShowImage" sender:self];
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

- (FCRegion)p_makeFCRegionFromMapViewRegion:(MKCoordinateRegion)mapRegion {
    CLLocationCoordinate2D center = mapRegion.center;
    MKCoordinateSpan span = mapRegion.span;
    FCRegion region;
    region.minimum_latitude = center.latitude - span.latitudeDelta / 2;
    region.minimum_longitude = center.longitude - span.longitudeDelta / 2;
    if (region.minimum_longitude < -180) {
        region.minimum_longitude += 360;
    }
    region.maximum_latitude = center.latitude + span.latitudeDelta / 2;
    region.maximum_longitude = center.longitude + span.longitudeDelta / 2;
    if (region.maximum_longitude > 180) {
        region.maximum_longitude -= 360;
    }
    
    return region;
}

@end
