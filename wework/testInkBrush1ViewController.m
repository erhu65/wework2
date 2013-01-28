//
//  testInkBrush1ViewController.m
//  testInkBrush1
//
//  Created by Chen Li on 9/2/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import "testInkBrush1ViewController.h"
#import "Canvas.h"
#import "WWPhotoMenuViewController.h"


@interface testInkBrush1ViewController ()
<WWPhotoMenuViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popOverPhotoMenu;

@end

@implementation testInkBrush1ViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	Canvas* canvasView = (Canvas*)self.view;
	[canvasView viewJustLoaded];
	canvasView.owner = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if([self.popOverPhotoMenu isPopoverVisible]){
        [self.popOverPhotoMenu dismissPopoverAnimated:YES];
        self.popOverPhotoMenu = nil;
    }
}

// Override to allow orientations other than the default portrait orientation.
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}
- (IBAction)cancel:(id)sender {
    
    if(nil != self.delegate){
        
        [self.delegate testInkBrush1ViewControllerDelegateDidCancel];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
}

- (IBAction)send:(id)sender {
        
    Canvas* canvasView = (Canvas*)self.view;
    if(nil == canvasView.arrayStrokes 
       ||canvasView.arrayStrokes.count == 0){
       
        [self cancel:nil];
        return;
    }
    [self.delegate testInkBrush1ViewControllerDelegateDidFinish: canvasView.pickedImage arrayStrokes:canvasView.arrayStrokes];

}


#pragma mark - WWPhotoMenuViewControllerDelegate
- (void) WWPhotoMenuViewControllerDelegateDidChooseType:(menuSelectedType)type{
    
     Canvas* canvasView = (Canvas*)self.view;
    [self.popOverPhotoMenu dismissPopoverAnimated:YES];
    self.popOverPhotoMenu = nil;
    
    if(type == menuSelectedTypeCamera){
       
        [canvasView didClickTakePhoto];
    } else if(type == menuSelectedTypePhotoLibrary) {
        [canvasView didClickChoosePhoto];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if([identifier isEqualToString:@"seguePhotoMenu"]){
        self.popOverPhotoMenu = [(UIStoryboardPopoverSegue *)segue popoverController];
        WWPhotoMenuViewController* phtotoMenuVC = (WWPhotoMenuViewController*)self.popOverPhotoMenu.contentViewController;
        phtotoMenuVC.delegate = self;
        //self.popOverPhotoMenu.delegate = self;
        
    }
}

@end