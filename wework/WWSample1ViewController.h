//
//  WWSample1ViewController.h
//  wework
//
//  Created by Peter2 on 1/25/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//
#import "BRCoreViewController.h"
@protocol WWSample1ViewControllerDelegate

- (void) didSelectSomeThing:(NSString*) str;

@end


@interface WWSample1ViewController : BRCoreViewController
{

}

@property (nonatomic, weak) id <WWSample1ViewControllerDelegate>     delegate;

@end
