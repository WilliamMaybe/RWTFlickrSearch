//
//  RWTFlickrSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/2.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearchResults.h"
#import "RWTViewModelServices.h"

@class RWTSearchResultsItemViewModel;

@interface RWTFlickrSearchResultsViewModel : NSObject

- (instancetype)initWithResults:(RWTFlickrSearchResults *)result services:(id<RWTViewModelServices>)services;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<RWTSearchResultsItemViewModel *>  *searchResults;

@end
