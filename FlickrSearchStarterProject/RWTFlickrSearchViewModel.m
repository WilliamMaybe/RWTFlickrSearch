//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTFlickrSearchResultsViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

- (instancetype)initWithServices:(id<RWTViewModelServices>)services
{
    self = [super init];
    if (self)
    {
        _services = services;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _title      = @"Flickr Search";
    _searchText = @"search Text";
    
    RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id(NSString *text) {
        return @(text.length > 3);
    }]
    // 只有值变化了才执行
    distinctUntilChanged];
    
    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal signalBlock:^RACSignal *(id input) {
        return [self executeSearchSignal];
    }];
}

- (RACSignal *)executeSearchSignal
{
    return [[[self.services getFlickrSearchService] flickrSearchSignal:self.searchText] doNext:^(id result) {
        RWTFlickrSearchResultsViewModel *resultsViewModel = [[RWTFlickrSearchResultsViewModel alloc] initWithResults:result services:self.services];
        [self.services pushViewModel:resultsViewModel];
    }];
    
    
    // log all. next, error, completed 都会输出，只要接受到,然后延时2s，再次输出
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

@end
