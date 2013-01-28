//
//  WWPhotoMenuViewController.h
//  wework
//
//  Created by Peter2 on 1/27/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "BRCoreViewController.h"
typedef enum menuSelectedType {
    menuSelectedTypePhotoLibrary = 0,
    menuSelectedTypeCamera = 1
    
} menuSelectedType;

@protocol WWPhotoMenuViewControllerDelegate

@required
- (void) WWPhotoMenuViewControllerDelegateDidChooseType:(menuSelectedType) type;

@end

@interface WWPhotoMenuViewController : BRCoreViewController


@property (nonatomic, weak) id <WWPhotoMenuViewControllerDelegate>     delegate;

@end
