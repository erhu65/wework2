//
//  WWMasterViewController.h
//  wework
//
//  Created by Peter2 on 1/23/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWDetailViewController;

@interface WWMasterViewController : UITableViewController

@property (strong, nonatomic) WWDetailViewController *detailViewController;

@end
