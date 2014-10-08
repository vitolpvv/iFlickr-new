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

- (void)getPhotosInfoWithLocation:(FCLocation)location distance:(double)radius completion:(FlickrClientCompletion)completionBlock {
    NSDictionary *parameters = @{@"method" : @"flickr.photos.search",
                                 @"api_key" : @"2b2c9f8abc28afe8d7749aee246d951c",
                                 @"has_geo" : @"1",
                                 @"lat" : [NSNumber numberWithFloat:location.latitude],
                                 @"lon" : [NSNumber numberWithFloat:location.longitude],
                                 @"radius" : [NSNumber numberWithFloat:radius],
                                 @"extras" : @"geo, url_l, url_q, url_o, date_taken, owner_name",
                                 @"format" : @"json",
                                 @"nojsoncallback" : @"1",
                                 @"content_type" : @"1",
                                 @"tags" : @"cat"};
    [self p_getPhotoInfoWithParameters:parameters completion:completionBlock];
}

- (void)getPhotosInfoWithRegion:(FCRegion)region completion:(FlickrClientCompletion)completion {
    NSString *bbox = [NSString stringWithFormat:@"%f,%f,%f,%f", region.minimum_longitude, region.minimum_latitude, region.maximum_longitude, region.maximum_latitude];
    NSDictionary *parameters = @{@"method" : @"flickr.photos.search",
                                 @"api_key" : @"2b2c9f8abc28afe8d7749aee246d951c",
                                 @"has_geo" : @"1",
                                 @"bbox" : bbox,
                                 @"extras" : @"geo, url_l, url_q, url_o, date_taken, owner_name",
                                 @"format" : @"json",
                                 @"nojsoncallback" : @"1",
                                 @"content_type" : @"1",
                                 @"tags" : @"cat"};
    [self p_getPhotoInfoWithParameters:parameters completion:completion];
}

- (void)p_getPhotoInfoWithParameters:(NSDictionary *)parameters completion:(FlickrClientCompletion)completion {
    FlickrClientCompletion copiedComplition = [completion copy];
    [self GET:@""
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          copiedComplition(responseObject, [responseObject[@"stat"] isEqualToString:@"ok"]);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          copiedComplition([self p_parseError:error], NO);
      }];
}

- (NSDictionary *)p_parseError:(NSError *)error {
    return [NSDictionary dictionaryWithObjects:@[@"fail", [NSNumber numberWithInteger:error.code], error.localizedDescription]
                                       forKeys:@[@"stat", @"code", @"message"]];
}

@end
