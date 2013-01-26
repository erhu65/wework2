//
//  testInkBrush1ViewController.h
//  testInkBrush1
//
//  Created by Chen Li on 9/2/10.
//  Copyright Chen Li 2010. All rights reserved.
//


@protocol testInkBrush1ViewControllerDelegate

@required
- (void) testInkBrush1ViewControllerDelegateDidCancel;
- (void) testInkBrush1ViewControllerDelegateDidFinish:(NSString*) str;

@end


@interface testInkBrush1ViewController : UIViewController {
    
}

@property (nonatomic, weak) id <testInkBrush1ViewControllerDelegate>     delegate;

@end

