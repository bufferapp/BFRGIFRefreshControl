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
    self.gifRefresh.dataRefreshOffsetThreshold = 100.0f; //Trigger refresh after user has scrolled this far
    self.gifRefresh.dataRefreshingGifYInset = 100.0f; //Where we want the gif to "hang out" while it performs the block
    self.gifRefresh.dataLoadedYInset = 64.0f; //Account for navbar
    self.gifRefresh.dataLoadedYOffset = -64.0f; //Account for navbar
    
    [self.tableView addSubview:self.gifRefresh];
    self.gifRefresh.frame = CGRectMake(0, -40, self.view.bounds.size.width, 20);
    
    // TESTING
    self.gifRefresh.triggerView = self.navigationController.navigationBar;
    self.gifRefresh.loadingOffset = 44;
}

@end
