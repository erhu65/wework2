//
//  BRCustomServiceViewController.m
//  BirthdayReminder
//
//  Created by Peter2 on 1/15/13.
//  Copyright (c) 2013 Nick Kuh. All rights reserved.
//

#import "BRCustomServiceViewController.h"
#import "FbMsgBaordViewController.h"
#import "BRRecordFriend.h"

#import "LangManager.h"

@interface UIWindow (AutoLayoutDebug) 
+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;
@end

@interface BRCustomServiceViewController ()
<UIScrollViewDelegate,
UIAlertViewDelegate,
FbMsgBaordViewControllerDelegate,
V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>

@property(nonatomic, strong) FbMsgBaordViewController* fbMsgBoardviewController;


@property (nonatomic, strong) V8HorizontalPickerView *pickerView;
@property (nonatomic, strong)  NSMutableArray *titleArray;
@property int indexCount;
@end

@implementation BRCustomServiceViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self){
        self.titleArray = [NSMutableArray arrayWithObjects:@"English", @"中文", nil];
		self.indexCount = 0;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil){
        //self.imvThumb = nil;
        self.view = nil;
        [self.fbMsgBoardviewController willMoveToParentViewController:nil];
        [self.fbMsgBoardviewController removeFromParentViewController];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    CGRect tmpFrame = CGRectMake(0, 50, 320, 50);
 	self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
	self.pickerView.backgroundColor   = [UIColor darkGrayColor];
	self.pickerView.selectedTextColor = [UIColor whiteColor];
	self.pickerView.textColor   = [UIColor grayColor];
	self.pickerView.delegate    = self;
	self.pickerView.dataSource  = self;
	self.pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	self.pickerView.selectionPoint = CGPointMake(60, 0);
	// add carat or other view to indicate selected element
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
	self.pickerView.selectionIndicatorView = indicator;
    [self.view insertSubview:self.pickerView belowSubview:self.noticeChildViewController.view];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString* selectedLangStr = [settings objectForKey:KUserDefaultLang];
    int whichLang_ = [selectedLangStr intValue];
    [self.pickerView scrollToElement:whichLang_ animated:YES];
    self.title = kSharedModel.lang[@"titleService"];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* noticeRecently = [defaults objectForKey:KUserDefaultNotice];
    if(nil != noticeRecently){
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.noticeChildViewController 
             toggleSlide:nil msg: noticeRecently
             stayTime:5.0f];
            
        });
        
    }
} 
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    PRPLog(@"%@-[%@ , %@]",
           [[UIWindow keyWindow] _autolayoutTrace],
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));

}

- (void)didRotateFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:
     fromInterfaceOrientation];
    
    PRPLog(@"%@-[%@ , %@]",
           [[UIWindow keyWindow] _autolayoutTrace],
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [self.titleArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [self.titleArray objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [self.titleArray objectAtIndex:index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:NSLineBreakByCharWrapping];
	return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    
    PRPLog(@"selected lang index %d-[%@ , %@]",
          index,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setInteger:index forKey:KUserDefaultLang];
    [settings synchronize];
    [LangManager switchLang];
}



#pragma mark FbMsgBaordViewDelegate method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //segueFbChatRoom
    if ([segue.identifier isEqualToString:@"segueFbMsgBoard"]) {
      
		self.fbMsgBoardviewController = segue.destinationViewController;
        self.fbMsgBoardviewController.videoId = @"50f130212e5f798d0d00001d";
        //the videoId doesn't exist actually, we use it just for dummy data
        //because the msg board is for customer service, a kind of uniqued id of all video rooms
        
        //self.fbMsgBoardviewController.delegate = self;
    }
    
    //	else if ([segue.identifier isEqualToString:@"EmbedGraph"])
    //	{
    //		self.graphViewController = segue.destinationViewController;
    //	}
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //	if ([identifier isEqualToString:@"DoneEdit"])
    //	{
    //		if ([self.textField.text length] > 0)
    //		{
    //			int value = [self.textField.text intValue];
    //			if (value >= 0 && value <= 100)
    //				return YES;
    //		}
    //        
    //		[[[UIAlertView alloc]
    //          initWithTitle:nil
    //          message:@"Value must be between 0 and 100."
    //          delegate:nil
    //          cancelButtonTitle:@"OK"
    //          otherButtonTitles:nil]
    //         show];
    //		return NO;
    //	}
	return YES;
}


@end
