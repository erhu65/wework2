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
    NSTimer* _timerAutoPlay;

}

@property (nonatomic,strong) UIImage* pickedImage;
@property (nonatomic,strong) UIImage* screenImage;
@property (nonatomic,strong) NSMutableArray* arrayStrokes;
@property (nonatomic,strong) NSMutableArray* arrayAbandonedStrokes;
@property (nonatomic,strong) UIColor* currentColor;
@property float currentSize;




@property (nonatomic,weak) IBOutlet UISlider* sliderSize;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSliderBarButtom;

@property (nonatomic,weak) IBOutlet UIButton* buttonColor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAddBg;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEraser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancelCanvas;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnColorBarButtom;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShare;
@property (nonatomic,weak) IBOutlet UILabel* labelSize;

@property (nonatomic,weak) IBOutlet UIToolbar* toolBar;
@property (nonatomic,strong) NSTimer* timerAutoPlay;



@property (nonatomic,weak) id owner;

-(void) viewJustLoaded;
-(void)prepareGraffiti:(NSMutableArray*)graffiti withBg:(UIImage*)bg;

-(IBAction) didClickChoosePhoto;
-(IBAction) didClickTakePhoto;
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
