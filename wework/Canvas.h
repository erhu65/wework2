//
//  Canvas.h
//  testInkBrush1
//
//  Created by Chen Li on 9/2/10.
//  Copyright 2010 Chen Li. All rights reserved.
//



@class ColorPickerController;

@interface Canvas : UIView 
<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {


	
	ColorPickerController* colorPC;
	UIPopoverController* colorPopoverController;
	UIPopoverController* sharePopoverController;
	UIImagePickerController* imagePC;
	UIPopoverController* imagePopoverController;
	UIActivityIndicatorView* activityIndicator;

}

@property (nonatomic,strong) UIImage* pickedImage;
@property (nonatomic,strong) UIImage* screenImage;
@property (nonatomic,strong) NSMutableArray* arrayStrokes;
@property (nonatomic,strong) NSMutableArray* arrayAbandonedStrokes;
@property (nonatomic,strong) UIColor* currentColor;
@property float currentSize;


@property (nonatomic,weak) IBOutlet UISlider* sliderSize;
@property (nonatomic,weak) IBOutlet UIButton* buttonColor;
@property (nonatomic,weak) IBOutlet UIToolbar* toolBar;
@property (nonatomic,weak) IBOutlet UILabel* labelSize;

@property (nonatomic,weak) id owner;

-(void) viewJustLoaded;

-(IBAction) didClickChoosePhoto;
-(IBAction) setBrushSize:(UISlider*)sender;
-(void) setColor:(UIColor*)theColor;
-(IBAction) eraser;
-(IBAction) undo;
-(IBAction) redo;
-(IBAction) clearCanvas;
-(IBAction) savePic;
-(void) saveToPhoto;

- (IBAction) didClickColorButton;
- (void) pickedColor:(UIColor*)color;


@end
