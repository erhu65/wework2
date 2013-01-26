//
//  ColorPickerController.h
//  testInkBrush1
//
//  Created by Chen Li on 9/3/10.
//  Copyright 2010 Chen Li. All rights reserved.
//



@interface ColorPickerController : UIViewController {

	UIColor* lastColor;
}

@property (nonatomic, weak) IBOutlet UIImageView* imgView;
//@property (nonatomic, retain) UIColor* lastColor;
@property (nonatomic, weak) id pickedColorDelegate;

- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end
