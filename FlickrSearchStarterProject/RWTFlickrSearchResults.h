//
//  RWTFlickrSearchResults.h
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWTSearchResultsItemViewModel;

@interface RWTFlickrSearchResults : NSObject

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSArray<RWTSearchResultsItemViewModel *> *photos;
@property (nonatomic, assign) NSUInteger totalResults;

@end
