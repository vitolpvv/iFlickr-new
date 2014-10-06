//
//  FlickrClient.m
//  iFlickr
//
//  Created by VitaliyP on 07.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "FlickrClient.h"

@implementation FlickrClient

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.flickr.com/services/rest/"]];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer new];
        self.responseSerializer = [AFJSONResponseSerializer new];
    }
    return self;
}

- (void)getPhotosWithLocation:(FCLocation)location distance:(float)radius completion:(FlickrClientCompletion)completion {
    NSDictionary *parameters = @{@"method" : @"flickr.photos.search",
                                 @"api_key" : @"2b2c9f8abc28afe8d7749aee246d951c",
                                 @"has_geo" : @"1",
                                 @"lat" : [NSNumber numberWithFloat:location.latitude],
                                 @"lon" : [NSNumber numberWithFloat:location.longitude],
                                 @"radius" : [NSNumber numberWithFloat:radius],
                                 @"extras" : @"geo,",
                                 @"format" : @"json"};
    [self GET:@""
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
