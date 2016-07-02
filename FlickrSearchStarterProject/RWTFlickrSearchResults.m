//
//  RWTFlickrSearchResults.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResults.h"

@implementation RWTFlickrSearchResults

- (NSString *)description
{
    return [NSString stringWithFormat:@"searchString = %@, totalResult = %@, photots = %@",self.searchString, @(self.totalResults), self.photos];
}

@end
