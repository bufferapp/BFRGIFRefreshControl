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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"");
    
    self.gifRefresh = [[BFRGifRefreshControl alloc] initWithGifFileName:@"pull-to-refresh@2x" scrollView:self.tableView triggerView:self.navigationController.navigationBar refreshAction:^ {
        //Calls [self.gifRefresh stopAnimating] in base class after data loads
        [self performFakeDataRefresh];
    }];
    
    //Configure offset values - see property documentation for more information
    
    self.gifRefresh.dataRefreshingGifYInset = 136.0f; //Where we want the gif to "hang out" while it performs the block
    
    
    [self.tableView addSubview:self.gifRefresh];
    self.gifRefresh.frame = CGRectMake(0, -40, self.view.bounds.size.width, 20);

}
@end
