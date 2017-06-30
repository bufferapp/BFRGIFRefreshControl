//
//  DemoBaseTableViewController.h
//  GifRefresh
//
//  Created by Jordan Morgan on 4/28/16.
//  Copyright © 2016 Buffer, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFRGifRefreshControl.h"

@interface DemoBaseTableViewController : UIViewController

@property (strong, nonatomic) BFRGifRefreshControl *gifRefresh;
@property (strong, nonatomic) UITableView *tableView;
- (void)performFakeDataRefresh;

@end
