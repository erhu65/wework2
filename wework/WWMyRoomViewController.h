//
//  WWMyRoomViewController.h
//  wework
//
//  Created by Peter2 on 1/28/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "BRCoreViewController.h"

@interface WWMyRoomViewController : BRCoreViewController

@property(nonatomic, strong)NSString* byTagId;
@property(nonatomic, strong)NSString* byTagName;
-(IBAction)unwindBackToMyRoomlViewController:(UIStoryboardSegue *)segue;
@end
