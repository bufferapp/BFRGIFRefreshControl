//
//  GifFromBundleTableViewController.m
//  GifRefresh
//
//  Created by Jordan Morgan on 4/28/16.
//  Copyright © 2016 Buffer, LLC. All rights reserved.
//

#import "GifFromBundleTableViewController.h"

@interface GifFromBundleTableViewController ()

@end

@implementation GifFromBundleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Gif from Bundle";

    self.gifRefresh = [[BFRGifRefreshControl alloc] initWithGifFileName:@"pull-to-refresh@2x" refreshAction:^ {
        //Calls [self.gifRefresh stopAnimating] in base class after data loads
        [self performFakeDataRefresh];
    }];
    
    //Configure offset values - see property documentation for more information
    self.gifRefresh.dataRefreshOffsetThreshold = 86.0f;
    self.gifRefresh.dataRefreshingGifOffset = 115.0f;
    self.gifRefresh.dataLoadedYInset = 64.0f;
    self.gifRefresh.dataLoadedYOffset = -64.0f;
    
    [self.tableView addSubview:self.gifRefresh];
    self.gifRefresh.frame = CGRectMake(0, -40, self.view.bounds.size.width, 20);
}

@end
