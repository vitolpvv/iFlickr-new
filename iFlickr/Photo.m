//
//  Photo.m
//  iFlickr
//
//  Created by VitaliyP on 08.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (instancetype)photoWithData:(NSDictionary *)data {
    if ([data valueForKey:@"url_q"] && ([data valueForKey:@"url_o"] || [data valueForKey:@"url_l"])) {
        Photo *newPhoto = [Photo new];
        newPhoto.owner = data[@"ownername"];
        newPhoto.title = data[@"title"];
        newPhoto.dateTaken = data[@"datetaken"];
        newPhoto.urlImageLarge = data[@"url_l"];
        newPhoto.urlImageOriginal = data[@"url_o"];
        newPhoto.urlImageSquare = data[@"url_q"];
        newPhoto.coordinate = CLLocationCoordinate2DMake([data[@"latitude"] doubleValue], [data[@"longitude"] doubleValue]);
        return newPhoto;
    }   
    return nil;
}

//- (CLLocationCoordinate2D)coordinate
//{
//    return self.coordinates;
//}

@end
