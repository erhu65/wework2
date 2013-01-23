//
//  WWDetailViewController.h
//  wework
//
//  Created by Peter2 on 1/23/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
