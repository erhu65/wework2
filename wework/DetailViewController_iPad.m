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
#import "FbChatRoomViewController.h"

#import "AboutBackgroundView.h"
#import "AboutViewController.h"
#import "CitiesViewController.h"
#import "WWSample1ViewController.h"

#import "testInkBrush1ViewController.h"
#import "WeaponSelector.h"
#import "ZipArchive.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "Utils.h"

@interface DetailViewController_iPad ()
<UISplitViewControllerDelegate,
 UIPopoverControllerDelegate,
FbChatRoomViewControllerDelegate,
testInkBrush1ViewControllerDelegate,
AmazonServiceRequestDelegate>
{

   
}
@property(nonatomic, strong) FbChatRoomViewController* fbChatRoomViewController;
@property (nonatomic, strong) AmazonS3Client *s3;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;


@end



@implementation DetailViewController_iPad

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil){
        //self.imvThumb = nil;
        self.view = nil;
		[self.fbChatRoomViewController willMoveToParentViewController:nil];
		[self.fbChatRoomViewController removeFromParentViewController];
                
    }
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}


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
    

    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Initial the S3 Client.
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:AWS_S3_ACCESS_KEY_ID withSecretKey:AWS_S3_SECRET_KEY];
    // Create the zip bucket.
    S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:AWS_S3_ZIP_BUCKET];
    S3CreateBucketResponse *createBucketResponse = [self.s3 createBucket:createBucketRequest];
    
    if(nil != createBucketResponse.error)
    {
        PRPLog(@"Error: %@ \n \
               -[%@ , %@]",
               createBucketResponse.error,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    }
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


#pragma mark - testInkBrush1ViewControllerDelegate
- (void) testInkBrush1ViewControllerDelegateDidCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}
- (void) testInkBrush1ViewControllerDelegateDidFinish:(UIImage*) pickedImage 
                                         arrayStrokes:(NSMutableArray*)arrayStrokes
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

    [self showHud:YES];
    
    NSString* uniquidFileName = [Utils createUUID:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *forderPath = [documentsDirectory stringByAppendingPathComponent:uniquidFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:forderPath]){
        NSError* error;
        if( [[NSFileManager defaultManager] createDirectoryAtPath:forderPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            PRPLog(@"ERROR: attempting to write create forder directory \
                   -[%@ , %@]",
                   NSStringFromClass([self class]),
                   NSStringFromSelector(_cmd));
            NSAssert(FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    
    
    UIImage* imageSaved;
    //NSDictionary* strokes = (NSDictionary* )canvasView.arrayStrokes;
    NSData * dataToWrite = [NSKeyedArchiver archivedDataWithRootObject:arrayStrokes];
    NSString* filePath_arrayStrokes = [Utils filePathInDocument:@"strokes" withSuffix:@".plist"];
    
    [dataToWrite writeToFile:filePath_arrayStrokes atomically:YES];
    NSString* filePath_arrayStrokes_new = [NSString stringWithFormat:@"%@/%@", forderPath, @"strokes.plist"];
    [[NSFileManager defaultManager] moveItemAtPath:filePath_arrayStrokes toPath:filePath_arrayStrokes_new error:nil];
    
    
    NSData * dataRestored = [NSData dataWithContentsOfFile:filePath_arrayStrokes_new];
    NSMutableArray* strokesSaved =   (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:dataRestored];
    
    if(nil != pickedImage){
        
        NSString* filePath_pickedImage = [Utils filePathInDocument:@"bg" withSuffix:@".png"];   
        //I do this in the didFinishPickingImage:(UIImage *)img method
        NSData* imageData = UIImageJPEGRepresentation(pickedImage, 1.0);
        //save to the default 100Apple(Camera Roll) folder.   
        [imageData writeToFile:filePath_pickedImage atomically:NO]; 
        NSString* filePath_pickedImage_new = [NSString stringWithFormat:@"%@/%@", forderPath, @"bg.png"];
        [[NSFileManager defaultManager] moveItemAtPath:filePath_pickedImage toPath:filePath_pickedImage_new error:nil];
        NSData * dataRestored = [NSData dataWithContentsOfFile:filePath_pickedImage_new];
        imageSaved = [UIImage imageWithData:dataRestored];
    }
    
    BOOL isDir = YES;
    NSArray *subpaths;
    
    //NSString *toCompress = @"dirToZip_OR_fileNameToZip";
    NSString *pathToCompress = forderPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathToCompress isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:pathToCompress];
    } else if ([fileManager fileExistsAtPath:pathToCompress]) {
        subpaths = [NSArray arrayWithObject:pathToCompress];
    }
    NSString* uniquidFileNameZip = [NSString stringWithFormat:@"%@.zip", uniquidFileName];
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:uniquidFileNameZip];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFilePath];
    
    if (isDir) {
        for(NSString *path in subpaths){ 
            NSString *fullPath = [pathToCompress stringByAppendingPathComponent:path];
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
                [za addFileToZip:fullPath newname:path]; 
            }
        }
        
    } else {
        [za addFileToZip:pathToCompress newname:@"fdfd"];
    }
    
    [za CloseZipFile2];    
    
    if(nil == strokesSaved ){
        PRPLog(@"failed to retrieve writed arrayStrokes dictionary from disk \
               -[%@ , %@]",
               pickedImage,
               strokesSaved,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    } else {
        
        NSData* zipFileData = [NSData dataWithContentsOfFile:zipFilePath];
        PRPLog(@"filePath_arrayStrokes: %@ \n \
               writed arrayStrokes: %@ \n \
               zipFileData: %@ \n \
               -[%@ , %@]",
               filePath_arrayStrokes,
               strokesSaved,
               zipFileData,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
        
        [self _processGrandCentralDispatchUpload:zipFileData uniquiName:uniquidFileName];
        
        if(nil != imageSaved){
            PRPLog(@"imageSaved: %@ \n \
                   -[%@ , %@]",
                   imageSaved,
                   NSStringFromClass([self class]),
                   NSStringFromSelector(_cmd));
        }
    }


}
- (void)_processGrandCentralDispatchUpload:(NSData *)zipData uniquiName:(NSString*)uniquiName
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:uniquiName
                                                                 inBucket:AWS_S3_ZIP_BUCKET];
        //por.contentType = @"image/jpeg";
        por.contentType = @"application/zip";
        //por.contentType = @"image/png";
        por.data        = zipData;
        // Put the image data into the specified s3 bucket and object.
        S3PutObjectResponse *putObjectResponse = [self.s3 putObject:por];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud:YES];
            // For error information
            NSError *error;
            // Create file manager
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString* uniquidFileNameZip = [NSString stringWithFormat:@"%@.zip", uniquiName];           
            NSString* zipFilePath = [Utils filePathInDocument:uniquidFileNameZip withSuffix:nil];
            // Attempt to delete the file at zipFilePath
            if ([fileMgr removeItemAtPath:zipFilePath error:&error] != YES){
                PRPLog(@"Unable to delete file: %@ \n \
                       -[%@ , %@]",
                       [error localizedDescription],
                       NSStringFromClass([self class]),
                       NSStringFromSelector(_cmd));
            }
            
            if(putObjectResponse.error != nil)
            {
                [self showMsg:[putObjectResponse.error.userInfo objectForKey:@"message"]  type:msgLevelError];
            }
            else
            {
                //[self showMsg:@"The zip was successfully uploaded." type:msgLevelInfo];
                PRPLog(@"upload successfully uniquidFileName:%@ -[%@ , %@]",
                       uniquiName,
                       NSStringFromClass([self class]),
                       NSStringFromSelector(_cmd));  

                
                
            }
        });
    });
}

#pragma mark - AmazonServiceRequestDelegate
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [self showMsg:@"The zip was successfully uploaded." type:msgLevelInfo];
    [self hideHud:YES];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    PRPLog(@"Error: %@ -[%@ , %@]",
           error,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd)); 
    [self showMsg:error.description  type:msgLevelError];
    [self hideHud:YES];
}

#pragma mark FbChatRoomViewControllerDelegate method
-(void)FbChatRoomViewControllerDelegateGetOutterInfo
{
    self.fbChatRoomViewController.uniquDataKey = @"uniquDataKey";
}

-(void)FbChatRoomViewControllerDelegateTriggerOuterAction2{
    
    [self presentTapped:nil];
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
    if ([identifier isEqualToString:@"segueFbChatRoom"])
	{
		self.fbChatRoomViewController = segue.destinationViewController;
        self.fbChatRoomViewController.delegate = self;
        self.fbChatRoomViewController.room = @"globalRoom";
	} 
}

@end
