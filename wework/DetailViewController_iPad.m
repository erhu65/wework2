//
//  DetailViewController_iPad.m
//  Surf's Up
//
//  Created by Steven Baranski on 9/17/11.
//  Copyright 2011 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DetailViewController_iPad.h"
#import "AboutBackgroundView.h"
#import "AboutViewController.h"
#import "CitiesViewController.h"
#import "WWSample1ViewController.h"
#import "testInkBrush1ViewController.h"
#import "WeaponSelector.h"
#import "ZipArchive.h"

@interface DetailViewController_iPad ()
<UISplitViewControllerDelegate,
 UIPopoverControllerDelegate,
CitiesViewControllerDelegate,
WWSample1ViewControllerDelegate,
testInkBrush1ViewControllerDelegate,
WeaponSelectorDelegate>
{

}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, assign) UIPopoverController *popOverSample1;

@property (nonatomic, strong) UIPopoverController              *citiesPopoverController;
@property (nonatomic, strong) CitiesViewController             *citiesViewController;


@property (nonatomic, weak) IBOutlet UIToolbar   *toolbar;

@property (nonatomic, weak) IBOutlet UIImageView  *imageView;

@property(nonatomic, weak) IBOutlet UIImageView *imageViewZip;
@property(nonatomic, weak) IBOutlet UILabel *labelZip;


@end



@implementation DetailViewController_iPad



#pragma mark - Private behavior
- (void)showAboutPopover
{
	if ([[self aboutPopover] isPopoverVisible] == NO) 
    {
		[[self aboutPopover] presentPopoverFromBarButtonItem:self.lastTappedButton 
                               permittedArrowDirections:UIPopoverArrowDirectionAny 
                                               animated:YES];
	}
	else 
    {
		[[self aboutPopover] dismissPopoverAnimated:YES];
	}    
}

#pragma mark - IBActions
- (IBAction)aboutTapped:(id)sender
{
    [self setLastTappedButton:sender];
    [self showAboutPopover];
}

- (IBAction)presentTapped:(id)sender
{
    
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                  bundle:nil];
    testInkBrush1ViewController* brushVC =(testInkBrush1ViewController*) [sb instantiateViewControllerWithIdentifier:@"testInkBrush1ViewController"];
    brushVC.delegate = self;
    brushVC.modalPresentationStyle = UIModalPresentationPageSheet;
   
    [self presentViewController:brushVC animated:YES completion:^{
        
    }];
    
    
    //init with - (void)loadView
    //WWSample1ViewController *sample1VC = [[WWSample1ViewController alloc] init];
//    
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
//                                                  bundle:nil];
//    WWSample1ViewController* sample1VC =(WWSample1ViewController*) [sb instantiateViewControllerWithIdentifier:@"WWSample1ViewController"];
//    sample1VC.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:sample1VC animated:YES completion:^{
//    
//    }];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    [rentSwitch setOnTintColor:[UIColor colorWithRed:0 green:175.0/255.0 blue:176.0/255.0 alpha:1.0]];
    // About button
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self 
                                                                   action:@selector(aboutTapped:)];    
    [self.navigationItem setRightBarButtonItem:aboutButton animated:YES]; 
    
    UIBarButtonItem *presentButton = [[UIBarButtonItem alloc] initWithTitle:@"Present"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self 
                                                                   action:@selector(presentTapped:)];    
    [self.navigationItem setLeftBarButtonItem:presentButton animated:YES]; 


    
    // Initialize popover
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
    [self setAboutPopover:[[UIPopoverController alloc] initWithContentViewController:aboutVC]];
    [[self aboutPopover] setPopoverBackgroundViewClass:[AboutBackgroundView class]];
    [[self aboutPopover] setDelegate:self];
    
    
    self.citiesViewController = [[CitiesViewController alloc] initWithStyle:UITableViewStylePlain];
    self.citiesViewController.caller = self;
    self.citiesPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.citiesViewController];
    
}

#pragma mark - Managing the detail item
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}
- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}


#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc 
{    
    barButtonItem.title = @"Surf Trips";
    [[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
    [self setDetailPopover:pc];
}

- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{    
    //[[self navigationItem] setLeftBarButtonItem:nil animated:YES];
    UIBarButtonItem *presentButton = [[UIBarButtonItem alloc] initWithTitle:@"Present"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self 
                                                                     action:@selector(presentTapped:)];    
    [self.navigationItem setLeftBarButtonItem:presentButton animated:YES];     
    self.detailPopover = nil;
}

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController 
{
	if ([[self aboutPopover] isPopoverVisible]) 
    {
        [[self aboutPopover] dismissPopoverAnimated:YES];
    } 
}
#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController 
{
	self.lastTappedButton = nil;
    self.popOverSample1 = nil;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	if ([self aboutPopover] != nil) 
    {
		[[self aboutPopover] dismissPopoverAnimated:YES];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    if (self.lastTappedButton != nil) 
    {
		[self showAboutPopover];
	}
}

- (IBAction)_notice:(id)sender {
    
    [self.noticeChildViewController 
     toggleSlide:nil msg:@"ljlkjl"
     stayTime:5.0f];
}


#pragma mark popOver other viewController and inactive with main viewController
- (IBAction) texas:(UIBarButtonItem*)sender{
    self.citiesViewController.data = [NSArray arrayWithObjects:@"Plano", @"Austin", @"Dallas", nil];
    [self.citiesPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
//    [self.citiesPopoverController presentPopoverFromRect:[self.toolbar bounds] inView:self.toolbar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction) california:(UIBarButtonItem*)sender{
    self.citiesViewController.data = [NSArray arrayWithObjects:@"San Jose", @"San Diego", @"Sacramento", nil];
    [self.citiesPopoverController presentPopoverFromRect:[self.toolbar bounds] inView:self.toolbar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark CitiesViewControllerDelegate
- (void) didSelectCity:(NSString*) city{
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", city]];
    [self.citiesPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - WWSample1ViewControllerDelegate
- (void) didSelectSomeThing:(NSString*) str{
    
    PRPLog(@"someString:%@ -[%@ , %@]",
           str,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));   
    [self.popOverSample1 dismissPopoverAnimated:YES];
    self.popOverSample1 = nil;
}

#pragma mark - testInkBrush1ViewControllerDelegate
- (void) testInkBrush1ViewControllerDelegateDidCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}
- (void) testInkBrush1ViewControllerDelegateDidFinish:(NSString*) str
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark WeaponSelectorDelegate
- (void)weaponChanged:(Weapon)weapon {
    
    if (self.popOverSample1 != nil) {
        [self.popOverSample1 dismissPopoverAnimated:YES];
    }  
    if (self.citiesPopoverController != nil) {
        [self.citiesPopoverController dismissPopoverAnimated:YES];
    }
    PRPLog(@"selected weapon type:%d -[%@ , %@]",
           weapon,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
}

- (IBAction)settingsButtonTapped:(id)sender {
    if (nil == self.popOverSample1) {
        [self performSegueWithIdentifier:@"ShowPopover" sender:sender];
    }
}

- (IBAction)downLoadUnzip:(id)sender {

    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://www.icodeblog.com/wp-content/uploads/2012/08/zipfile.zip"];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {        
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
            
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {            
                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
                    if (NO == ret){} [za UnzipCloseFile];
                    
                    NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
                    NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
                    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
                    UIImage *img = [UIImage imageWithData:imageData];
                    NSString *textString = [NSString stringWithContentsOfFile:textFilePath encoding:NSASCIIStringEncoding error:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageViewZip.image = img;
                        self.labelZip.text = textString;
                    });
                }
            }
            else
            {
                NSLog(@"Error saving file %@",error);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
        
    });

}


- (IBAction)zip:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"photo.png"];
    NSString *textPath = [cachePath stringByAppendingPathComponent:@"text.txt"];
    
    [za addFileToZip:imagePath newname:@"NewPhotoName.png"];
    [za addFileToZip:textPath newname:@"NewTextName.txt"];
    
    BOOL success = [za CloseZipFile2];
    
    NSLog(@"Zipped file with result %d",success);   
}



#pragma mark Segues
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    
//    if ([identifier isEqualToString:@"ShowPopover"]) {
//        if(nil != self.popOverSample1){
//            return  NO;
//        }
//    }
//    // by default perform the segue transition
//    return YES;
//}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"ShowPopover"]) {

        self.popOverSample1 = [(UIStoryboardPopoverSegue *)segue popoverController];
        WWSample1ViewController* sample1VC = (WWSample1ViewController*)self.popOverSample1.contentViewController;
        sample1VC.delegate = self;
//        self.citiesViewController.data = [NSArray arrayWithObjects:@"San Jose", @"San Diego", @"Sacramento","Plano", @"Austin", @"Dallas", nil];
//        self.citiesViewController.caller = self;
        self.popOverSample1.delegate = self;
    }
}

@end
