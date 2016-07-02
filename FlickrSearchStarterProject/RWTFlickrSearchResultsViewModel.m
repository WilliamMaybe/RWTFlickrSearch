//
//  RWTFlickrSearchResultsViewModel.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/2.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResultsViewModel.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTSearchResultsItemViewModel.h"
#import "RWTFlickrPhotoMetadata.h"
#import "RWTFlickrPhoto.h"

@implementation RWTFlickrSearchResultsViewModel

- (instancetype)initWithResults:(RWTFlickrSearchResults *)result services:(id<RWTViewModelServices>)services
{
    self = [super init];
    if (self)
    {
        _title         = result.searchString;
        _searchResults = [result.photos linq_select:^id(RWTFlickrPhoto *photo) {
            return [[RWTSearchResultsItemViewModel alloc] initWithPhoto:photo services:services];
        }];
    }
    return self;
}

@end
