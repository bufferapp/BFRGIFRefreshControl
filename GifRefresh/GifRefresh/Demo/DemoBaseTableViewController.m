//
//  DemoBaseTableViewController.m
//  GifRefresh
//
//  Created by Jordan Morgan on 4/28/16.
//  Copyright © 2016 Buffer, LLC. All rights reserved.
//

#import "DemoBaseTableViewController.h"
#import "BFRGifRefreshControl.h"

@interface DemoBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *fakeDatasource;
@end

@implementation DemoBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fakeDatasource = [@[[NSNumber numberWithInteger:1],
                             [NSNumber numberWithInteger:2],
                             [NSNumber numberWithInteger:3],
                             [NSNumber numberWithInteger:4],
                             [NSNumber numberWithInteger:5]] mutableCopy];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *toggleDisableBtn = [[UIBarButtonItem alloc] initWithTitle:@"Disable" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRefreshControlEnabled:)];
    self.navigationItem.leftBarButtonItem = toggleDisableBtn;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.gifRefresh containingScrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.gifRefresh containingScrollViewDidEndDragging];
}

- (void)performFakeDataRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.fakeDatasource addObject:[NSNumber numberWithInteger:self.fakeDatasource.count + 1]];
        [self.tableView reloadData];
        [self.gifRefresh stopAnimating];
    });
}

#pragma mark - Disable Gif Refresh
- (void)toggleRefreshControlEnabled:(UIBarButtonItem *)sender {
    self.gifRefresh.disabledRefresh = !self.gifRefresh.hasDisabledRefresh;
    sender.title = self.gifRefresh.hasDisabledRefresh ? @"Enable" : @"Disable";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fakeDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = ((NSNumber *)self.fakeDatasource[indexPath.row]).stringValue;
    return cell;
}

@end
