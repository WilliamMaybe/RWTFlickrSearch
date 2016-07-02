//
//  RWTFlickrSearchViewModelImpl.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTSearchResultsViewController.h"
#import "RWTFlickrSearchResultsViewModel.h"
#import "RWTFlickrSearchImpl.h"

@interface RWTViewModelServicesImpl ()

@property (nonatomic, strong) RWTFlickrSearchImpl *searchService;
@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation RWTViewModelServicesImpl

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self)
    {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

- (id<RWTFlickrSearch>)getFlickrSearchService
{
    return self.searchService;
}

- (void)pushViewModel:(id)viewModel
{
    id viewController;
    if ([viewModel isKindOfClass:[RWTFlickrSearchResultsViewModel class]])
    {
        viewController = [[RWTSearchResultsViewController alloc] initWithViewModel:viewModel];
    }
    else
    {
        NSLog(@"an unknown viewModel was pushed!!");
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
