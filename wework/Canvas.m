//
//  Canvas.m
//  testInkBrush1
//
//  Created by Chen Li on 9/2/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

// For the purpose of demo, I just made this view working. 
// However, in terms of design, we can improve this by better seperate M&V, 
// which means the data such as arrayStrokes should be managed by a model class. 

#import "testInkBrush1ViewController.h"
#import "Canvas.h"
#import "ColorPickerController.h"
#import "QuartzCore/QuartzCore.h"
#import "Utils.h"
#import "WWPhotoMenuViewController.h"

#pragma mark Canvas
@implementation Canvas
{
    BOOL _isAllowDraw;
    BOOL _isAutoPlay;


}


-(BOOL)isMultipleTouchEnabled {
	return NO;
}

-(void) viewJustLoaded {
	NSLog(@"viewJustLoaded");
	_isAllowDraw = YES;
    _isAutoPlay = NO;
	// color picker and popover
	colorPC = [[ColorPickerController alloc] init];
	colorPC.pickedColorDelegate = self;
	colorPopoverController = [[UIPopoverController alloc] initWithContentViewController:colorPC];
	[colorPopoverController setPopoverContentSize:colorPC.view.frame.size];
		
	// image picker and popover
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		imagePC = [[UIImagePickerController alloc] init];
		imagePC.delegate = self;
		imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePC];
		//[imagePopoverController setPopoverContentSize:imagePC.view.frame.size];
	}
    
	self.pickedImage = nil;
	self.arrayStrokes = [NSMutableArray array];
	self.arrayAbandonedStrokes = [NSMutableArray array];
	self.currentSize = 5.0;
	self.labelSize.text = @"Size: 5";
	[self setColor:[UIColor blackColor]];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.center = CGPointMake(512, 384);
    
    self.timerAutoPlay = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(_autoPlay)
                                                    userInfo:nil
                                                     repeats:YES];
    [self.timerAutoPlay fire];

	    
}
-(void)prepareGraffiti:(NSMutableArray*)graffiti withBg:(UIImage*)bg{
    self.arrayStrokes = [graffiti mutableCopy];
    if(nil != bg){
        self.pickedImage = bg;
    }
    
    NSMutableArray *barBtns  = [self.toolBar.items mutableCopy];
    [barBtns removeObject:self.btnSliderBarButtom];
    [barBtns removeObject:self.btnColorBarButtom];
    [barBtns removeObject:self.buttonColor];
    [barBtns removeObject:self.btnAddBg];
    [barBtns removeObject:self.btnEraser];
    [barBtns removeObject:self.btnCancelCanvas];
    [barBtns removeObject:self.btnSave];
    [barBtns removeObject:self.btnShare];
    
    UIBarButtonItem *barButtomPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(_play:)];
    UIBarButtonItem *barButtomPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(_pause:)];
    UIBarButtonItem *barButtomFlexiableRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barBtns insertObject:barButtomPlay atIndex:2];
    [barBtns insertObject:barButtomPause atIndex:3];
    [barBtns insertObject:barButtomFlexiableRight atIndex:4];
    

    self.labelSize.hidden = YES;
    self.toolBar.items = barBtns;
    [self setNeedsDisplay];
    _isAllowDraw = NO;
    
    
}

-(void)_play:(UIBarButtonItem*)sender{
    
    _isAutoPlay = YES;
    
    NSMutableArray* arrayStroksTemp = [self.arrayStrokes mutableCopy];
    [arrayStroksTemp enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        [self undo:nil]; 
    }];    
}


-(void)_pause:(UIBarButtonItem*)sender{
    _isAutoPlay = NO;
}

-(void)_autoPlay{
//    
//    PRPLog(@"_isAutoPlay: %d -[%@ , %@]",
//           _isAutoPlay,
//           NSStringFromClass([self class]),
//           NSStringFromSelector(_cmd));
    if(_isAutoPlay){
        [self redo:nil];
    }
     
}


-(IBAction) setBrushSize:(UISlider*)sender {
	self.currentSize = sender.value;
	self.labelSize.text = [NSString stringWithFormat:@"Size: %.0f",sender.value];
}

-(void) setColor:(UIColor*)theColor {
	self.buttonColor.backgroundColor = theColor;
	self.currentColor = theColor;
}

// The implementation of eraser is dirty here: simply use a white pen
-(IBAction) eraser {
	[self setColor:[UIColor whiteColor]];
}

- (IBAction) didClickColorButton {
	
    [colorPopoverController presentPopoverFromRect:CGRectMake(435, 700, 30, 30) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) pickedColor:(UIColor*)color {
    
	NSLog(@"pickedColor");
	[colorPopoverController dismissPopoverAnimated:YES];
	[self setColor:color];
}

// Start new dictionary for each touch, with points and color
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
	
	NSMutableArray *arrayPointsInStroke = [NSMutableArray array];
	NSMutableDictionary *dictStroke = [NSMutableDictionary dictionary];
	[dictStroke setObject:arrayPointsInStroke forKey:@"points"];
	[dictStroke setObject:self.currentColor forKey:@"color"];
	[dictStroke setObject:[NSNumber numberWithFloat:self.currentSize] forKey:@"size"];
	
	CGPoint point = [[touches anyObject] locationInView:self];
	[arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    if(_isAllowDraw){
        [self.arrayStrokes addObject:dictStroke];
    }
	
}

// Add each point to points array
- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    if(!_isAllowDraw) return;
	CGPoint point = [[touches anyObject] locationInView:self];
	CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
	NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"];
	[arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
	
	CGRect rectToRedraw = CGRectMake(\
									 ((prevPoint.x>point.x)?point.x:prevPoint.x)-self.currentSize,\
									 ((prevPoint.y>point.y)?point.y:prevPoint.y)-self.currentSize,\
									 fabs(point.x-prevPoint.x)+2*self.currentSize,\
									 fabs(point.y-prevPoint.y)+2*self.currentSize\
									 );
    if(_isAllowDraw){
        [self setNeedsDisplayInRect:rectToRedraw];
    }
	
    
//    NSString* str_current_point = NSStringFromCGPoint(point);
//    NSString* str_prevPoint = NSStringFromCGPoint(prevPoint);
//    
//    CGPoint current_point = CGPointFromString(str_current_point);
//    CGPoint prev_point = CGPointFromString(str_prevPoint);
//    NSLog(@"curren point: %@", str_current_point);
//    NSLog(@"X = %f Y = %f",current_point.x,current_point.y);

	//[self setNeedsDisplay];
}

// Send over new trace when the touch ends
- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
    if(_isAllowDraw){
        [self.arrayAbandonedStrokes removeAllObjects];
    }
	
}

// Draw all points, foreign and domestic, to the screen
- (void) drawRect: (CGRect) rect
{	
    //UIBezierPath*    aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
//    [aPath moveToPoint:CGPointMake(100.0, 0.0)];
//    
//    // Draw the lines
//    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
//    [aPath addLineToPoint:CGPointMake(160, 140)];
//    [aPath addLineToPoint:CGPointMake(40.0, 140)];
//    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
//    aPath.lineWidth = 5.0;
//    [[UIColor redColor] set];
//    [aPath stroke];
//    [aPath closePath];
    
    
    if(self.pickedImage != nil) {
//        int width = self.pickedImage.size.width;
//        int height = self.pickedImage.size.height;
        float viewWidth = self.frame.size.width;
        float viewHeight = self.frame.size.height;
        CGRect rectForImage = CGRectMake(0, 0, viewWidth, viewHeight);
        [self.pickedImage drawInRect:rectForImage];
    }
    

	
	if (self.arrayStrokes)
	{
		int arraynum = 0;
		// each iteration draw a stroke
		// line segments within a single stroke (path) has the same color and line width
		for (NSDictionary *dictStroke in self.arrayStrokes)
		{
			NSArray *arrayPointsInstroke = [dictStroke objectForKey:@"points"];
			UIColor *color = [dictStroke objectForKey:@"color"];
			float size = [[dictStroke objectForKey:@"size"] floatValue];
			[color set];		// equivalent to both setFill and setStroke
			
//			// won't draw a line which is too short
//			if (arrayPointsInstroke.count < 3)	{
//				arraynum++; 
//				continue;		// if continue is executed, the program jumps to the next dictStroke
//			}
			
			// draw the stroke, line by line, with rounded joints
			UIBezierPath* pathLines = [UIBezierPath bezierPath];
			CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]);
			[pathLines moveToPoint:pointStart];
			for (int i = 0; i < (arrayPointsInstroke.count - 1); i++)
			{
				CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]);
				[pathLines addLineToPoint:pointNext];
			}
			pathLines.lineWidth = size;
			pathLines.lineJoinStyle = kCGLineJoinRound;
			pathLines.lineCapStyle = kCGLineCapRound;
			[pathLines stroke];
			
			arraynum++;
		}
	}
}

-(IBAction) didClickChoosePhoto {
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[imagePopoverController presentPopoverFromRect:CGRectMake(200, 200, 30, 30)\
											inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction) didClickTakePhoto {
    imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
	[imagePopoverController presentPopoverFromRect:CGRectMake(200, 200, 30, 30)\
											inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


-(void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    UIImage* imgOriginal = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.pickedImage = [Utils imageWithImage:imgOriginal scaledToSize:CGSizeMake(768.0f, 768.0f)];
    [imagePopoverController dismissPopoverAnimated:YES];
    
    [self setNeedsDisplay];
}

-(IBAction) undo:(id)sender {
    if(nil !=  sender) _isAutoPlay = NO;
	if ([self.arrayStrokes count]>0) {
		NSMutableDictionary* dictAbandonedStroke = [self.arrayStrokes lastObject];
		[self.arrayAbandonedStrokes addObject:dictAbandonedStroke];
		[self.arrayStrokes removeLastObject];
		[self setNeedsDisplay];
	}
}

-(IBAction) redo:(id)sender {
    if(nil !=  sender) _isAutoPlay = NO;
	if ([self.arrayAbandonedStrokes count]>0) {
		NSMutableDictionary* dictReusedStroke = [self.arrayAbandonedStrokes lastObject];
		[self.arrayStrokes addObject:dictReusedStroke];
		[self.arrayAbandonedStrokes removeLastObject];
		[self setNeedsDisplay];
	}
}

-(IBAction) clearCanvas {
	self.pickedImage = nil;
	[self.arrayStrokes removeAllObjects];
	[self.arrayAbandonedStrokes removeAllObjects];
	[self setNeedsDisplay];
}

-(IBAction) savePic {

	// hide toolbar temporarily
	self.toolBar.hidden = YES;
    self.labelSize.hidden = YES;
	
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];

	self.screenImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// show toolbar back
    self.toolBar.hidden = NO;
    self.labelSize.hidden = NO;
	
	// add activityIndicator
	[self addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
	[self performSelector:@selector(saveToPhoto) withObject:nil afterDelay:0.0];
}

-(void) saveToPhoto {
    
	// save to photo album
	UIImageWriteToSavedPhotosAlbum(self.screenImage, nil, nil, nil);
	
	// stop activityIndicator
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	
	// show alert
	UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:nil message:@"Image Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertSheet show];
}



@end
