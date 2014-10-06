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
    float latitude;
    float longitude;
} FCLocation;

@interface FlickrClient : AFHTTPRequestOperationManager

- (void)getPhotosWithLocation:(FCLocation)location distance:(float)radius completion:(FlickrClientCompletion)completion;

@end
