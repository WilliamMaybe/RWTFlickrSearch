//
//  RWTAppDelegate.m
//  RWTFlickrSearch
//
//  Created by Colin Eberhardt on 20/05/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTAppDelegate.h"
#import "RWTFlickrSearchViewController.h"
#import "RWTFlickrSearchViewModel.h"
#import "RWTViewModelServicesImpl.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWTAppDelegate ()

@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, strong) RWTFlickrSearchViewModel *viewModel;
@property (nonatomic, strong) RWTViewModelServicesImpl *viewModelService;

@end

@implementation RWTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self testSignal];
    
    // create a navigation controller and perform some simple styling
    self.navigationController = [UINavigationController new];
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  
    // create and navigate to a view controller
    UIViewController *viewController = [self createInitialViewController];
    [self.navigationController pushViewController:viewController animated:NO];

    // show the navigation controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)createInitialViewController {
    self.viewModelService = [[RWTViewModelServicesImpl alloc] initWithNavigationController:self.navigationController];
    self.viewModel = [[RWTFlickrSearchViewModel alloc] initWithServices:self.viewModelService];
    return [[RWTFlickrSearchViewController alloc] initWithViewModel:self.viewModel];
}

- (void)testSignal
{
    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"hahahah test signal sended"];
        return nil;
    }]
     subscribeNext:^(id x) {
         NSLog(@"%@", x);
    }];
}

@end