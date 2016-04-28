//
//  GifFromURLTableViewController.m
//  GifRefresh
//
//  Created by Jordan Morgan on 4/28/16.
//  Copyright © 2016 Buffer, LLC. All rights reserved.
//

#import "GifFromURLTableViewController.h"

@interface GifFromURLTableViewController ()

@end

@implementation GifFromURLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Gif from URL";
    
    //You can use this gif initializer in several ways, since retrieving NSData comes in many forms.
    NSURL *gifURL = [NSURL URLWithString:@"http://i.imgur.com/jto5jnA.gif"];
    [[[NSURLSession sharedSession] dataTaskWithURL:gifURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifRefresh = [[BFRGifRefreshControl alloc] initWithGifData:data refreshAction:^ {
                [self performFakeDataRefresh];
            }];
            
            //Configure offset values - see property documentation for more information
            self.gifRefresh.dataRefreshOffsetThreshold = 100.0f; //Trigger refresh after user has scrolled this far
            self.gifRefresh.dataRefreshingGifYInset = 100.0f; //Where we want the gif to "hang out" while it performs the block
            self.gifRefresh.dataLoadedYInset = 64.0f; //Account for navbar
            self.gifRefresh.dataLoadedYOffset = -64.0f; //Account for navbar
            
            [self.tableView addSubview:self.gifRefresh];
            self.gifRefresh.frame = CGRectMake(0, -40, self.view.bounds.size.width, 20);
        });
        
    }] resume];
}

@end
