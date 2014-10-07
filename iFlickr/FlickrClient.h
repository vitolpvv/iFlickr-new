//
//  FlickrClient.h
//  iFlickr
//
//  Created by VitaliyP on 07.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void(^FlickrClientCompletion)(id data, BOOL success);

typedef struct FCLocation {
    double latitude;
    double longitude;
} FCLocation;

typedef struct FCRegion {
    double minimum_latitude;
    double minimum_longitude;
    double maximum_latitude;
    double maximum_longitude;
} FCRegion;

@interface FlickrClient : AFHTTPRequestOperationManager

- (void)getPhotosInfoWithLocation:(FCLocation)location distance:(double)radius completion:(FlickrClientCompletion)completion;
- (void)getPhotosInfoWithRegion:(FCRegion)region completion:(FlickrClientCompletion)completion;

@end
