//
//  RWTFlickrPhotoMetadata.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/2.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetadata.h"

@implementation RWTFlickrPhotoMetadata

- (NSString *)description
{
    return [NSString stringWithFormat:@"metadata: comments=%lu, favorites=%lu", self.comments, self.favorites];
}

@end
