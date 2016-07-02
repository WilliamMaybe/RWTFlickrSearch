//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewController.h"
#import "RWTSearchResultsTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CETableViewBindingHelper.h"
#import "RWTFlickrPhoto.h"

@interface RWTSearchResultsViewController () < UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (nonatomic, strong) RWTFlickrSearchResultsViewModel *viewModel;
@property (nonatomic, strong) CETableViewBindingHelper *bindingHelper;

@end

@implementation RWTSearchResultsViewController

- (instancetype)initWithViewModel:(RWTFlickrSearchResultsViewModel *)viewModel
{
    self = [super init];
    if (self)
    {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.searchResultsTable.dataSource = self;
    
    [self.searchResultsTable registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    
    [self bindViewModel];
}

- (void)bindViewModel
{
    self.title = self.viewModel.title;
    
    UINib *nib = [UINib nibWithNibName:@"RWTSearchResultsTableViewCell" bundle:nil];
    self.bindingHelper = [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable sourceSignal:RACObserve(self.viewModel, searchResults) selectionCommand:nil templateCell:nib];
//    self.bindingHelper.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray<RWTSearchResultsTableViewCell *> *cells = [self.searchResultsTable visibleCells];
    [cells enumerateObjectsUsingBlock:^(RWTSearchResultsTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = -40 + (obj.frame.origin.y - scrollView.contentOffset.y) / 5;
        [obj setParallax:value];
    }];
}

@end
