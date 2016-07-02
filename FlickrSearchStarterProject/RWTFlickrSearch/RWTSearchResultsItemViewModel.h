//
//  RWTSearchResultsItemViewModel.h
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/2.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTFlickrPhoto.h"

@interface RWTSearchResultsItemViewModel : NSObject

- (instancetype)initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services;

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL    *url;
@property (nonatomic, strong) NSNumber *favorites;
@property (nonatomic, strong) NSNumber *comments;

@end
