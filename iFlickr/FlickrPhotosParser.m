//
//  FlickrPhotosParser.m
//  iFlickr
//
//  Created by VitaliyP on 08.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "FlickrPhotosParser.h"
#import "Photo.h"

@implementation FlickrPhotosParser

- (NSArray *)photosWithInfo:(NSArray *)info {
    NSMutableArray *photosArrey = [NSMutableArray new];
    for (NSDictionary *anInfo in info) {
        Photo *photo = [Photo photoWithData:anInfo];
        if (photo) {
            [photosArrey addObject:photo];
        }
    }
    return photosArrey;
}

@end
