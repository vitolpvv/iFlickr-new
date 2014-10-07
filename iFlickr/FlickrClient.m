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

- (void)getPhotosInfoWithLocation:(FCLocation)location distance:(double)radius completion:(FlickrClientCompletion)completion {
    NSDictionary *parameters = @{@"method" : @"flickr.photos.search",
                                 @"api_key" : @"2b2c9f8abc28afe8d7749aee246d951c",
                                 @"has_geo" : @"1",
                                 @"lat" : [NSNumber numberWithFloat:location.latitude],
                                 @"lon" : [NSNumber numberWithFloat:location.longitude],
                                 @"radius" : [NSNumber numberWithFloat:radius],
                                 @"extras" : @"geo,url_s,url_q,url_o,",
                                 @"format" : @"json",
                                 @"nojsoncallback" : @"1",
                                 @"content_type" : @"1",
                                 @"tags" : @"beauty"};
    [self p_getPhotoWithParameters:parameters completion:completion];
}

- (void)getPhotosInfoWithRegion:(FCRegion)region completion:(FlickrClientCompletion)completion {
    NSString *bbox = [NSString stringWithFormat:@"%f,%f,%f,%f", region.minimum_longitude, region.minimum_latitude, region.maximum_longitude, region.maximum_latitude];
    NSDictionary *parameters = @{@"method" : @"flickr.photos.search",
                                 @"api_key" : @"2b2c9f8abc28afe8d7749aee246d951c",
                                 @"has_geo" : @"1",
                                 @"bbox" : bbox,
                                 @"extras" : @"geo,url_s,url_q,url_o,",
                                 @"format" : @"json",
                                 @"nojsoncallback" : @"1",
                                 @"content_type" : @"1",
                                 @"tags" : @"beauty"};
    [self p_getPhotoWithParameters:parameters completion:completion];
}

- (void)p_getPhotoWithParameters:(NSDictionary *)parameters completion:(FlickrClientCompletion)completion {
    [self GET:@""
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"stat"] isEqualToString:@"fail"]) {
              completion(responseObject, NO);
          } else {
              completion([self p_parsePhotosWithData:responseObject[@"photos"][@"photo"]], YES);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          completion([self p_parseError:error], NO);
      }];
}

- (NSArray *)p_parsePhotosWithData:(id)data {
    NSMutableArray *photos = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [photos addObject:obj];
    }];
    return photos;
}

- (NSDictionary *)p_parseError:(NSError *)error {
    return [NSDictionary dictionaryWithObjects:@[@"fail", [NSNumber numberWithInteger:error.code], error.localizedDescription]
                                       forKeys:@[@"stat", @"code", @"message"]];
}

@end
