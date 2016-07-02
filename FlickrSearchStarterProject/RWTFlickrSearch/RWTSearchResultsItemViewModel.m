//
//  RWTSearchResultsItemViewModel.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/2.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsItemViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWTFlickrPhotoMetadata.h"

@interface RWTSearchResultsItemViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;
@property (nonatomic, strong) RWTFlickrPhoto *photo;

@end

@implementation RWTSearchResultsItemViewModel

- (instancetype)initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services
{
    self = [super init];
    if (self)
    {
        _title = photo.title;
        _url = photo.url;
        _services = services;
        _photo    = photo;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    RACSignal *fetchMetadata = [RACObserve(self, isVisible) filter:^BOOL(id value) {
        return [value boolValue];
    }];
    
    [fetchMetadata subscribeNext:^(id x) {
        [[[self.services getFlickrSearchService] flickrImageMetadata:self.photo.identifier]
         subscribeNext:^(RWTFlickrPhotoMetadata *metadata) {
             self.favorites = @(metadata.favorites);
             self.comments  = @(metadata.comments);
         }];
    }];
}

@end
