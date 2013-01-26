//
//  testInkBrush1ViewController.m
//  testInkBrush1
//
//  Created by Chen Li on 9/2/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import "testInkBrush1ViewController.h"
#import "Canvas.h"
#import "Utils.h"
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


// Override to allow orientations other than the default portrait orientation.
- (void)didReceiveMemoryWarning {
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
    NSData * dataToWrite = [NSKeyedArchiver archivedDataWithRootObject:canvasView.arrayStrokes];
    NSString* filePath_arrayStrokes = [Utils filePathInDocument:@"strokes" withSuffix:@".plist"];
    
    [dataToWrite writeToFile:filePath_arrayStrokes atomically:YES];
    NSString* filePath_arrayStrokes_new = [NSString stringWithFormat:@"%@/%@", forderPath, @"strokes.plist"];
    [[NSFileManager defaultManager] moveItemAtPath:filePath_arrayStrokes toPath:filePath_arrayStrokes_new error:nil];
    
    
    NSData * dataRestored = [NSData dataWithContentsOfFile:filePath_arrayStrokes_new];
    NSMutableArray* strokesSaved =   (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:dataRestored];
    
    if(nil != canvasView.pickedImage){
        
        NSString* filePath_pickedImage = [Utils filePathInDocument:@"bg" withSuffix:@".png"];   
        //I do this in the didFinishPickingImage:(UIImage *)img method
        NSData* imageData = UIImageJPEGRepresentation(canvasView.pickedImage, 1.0);
        //save to the default 100Apple(Camera Roll) folder.   
        [imageData writeToFile:filePath_pickedImage atomically:NO]; 
        NSString* filePath_pickedImage_new = [NSString stringWithFormat:@"%@/%@", forderPath, @"bg.png"];
        [[NSFileManager defaultManager] moveItemAtPath:filePath_pickedImage toPath:filePath_pickedImage_new error:nil];
        NSData * dataRestored = [NSData dataWithContentsOfFile:filePath_pickedImage_new];
        imageSaved = [UIImage imageWithData:dataRestored];
    }
    
//    
    

//    BOOL isDir=NO;
//    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSArray *subpaths;
//    
//    NSString *toCompress = @"dirToZip_OR_fileNameToZip";
//    NSString *pathToCompress = [documentsDirectory stringByAppendingPathComponent:toCompress];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:pathToCompress isDirectory:&isDir] && isDir){
//        subpaths = [fileManager subpathsAtPath:pathToCompress];
//    } else if ([fileManager fileExistsAtPath:pathToCompress]) {
//        subpaths = [NSArray arrayWithObject:pathToCompress];
//    }
//    
//    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:@"myZipFileName.zip"];
//    
//    ZipArchive *za = [[ZipArchive alloc] init];
//    [za CreateZipFile2:zipFilePath];
//    if (isDir) {
//        for(NSString *path in subpaths){ 
//            NSString *fullPath = [pathToCompress stringByAppendingPathComponent:path];
//            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
//                [za addFileToZip:fullPath newname:path]; 
//            }
//        }
//    } else {
//        [za addFileToZip:pathToCompress newname:toCompress];
//    }
//    
//    BOOL successCompressing = [za CloseZipFile2];
    

    if(nil == strokesSaved ){
        PRPLog(@"failed to retrieve writed arrayStrokes dictionary from disk \
               -[%@ , %@]",
               canvasView.pickedImage,
               strokesSaved,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    } else {
        PRPLog(@"filePath_arrayStrokes: %@ \n \
               writed arrayStrokes: %@ \n \
               -[%@ , %@]",
               filePath_arrayStrokes,
               strokesSaved,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
        
        if(nil != imageSaved){
            PRPLog(@"imageSaved: %@ \n \
                   -[%@ , %@]",
                   imageSaved,
                   NSStringFromClass([self class]),
                   NSStringFromSelector(_cmd));
        }
    }
    
    
    if(nil != self.delegate){
        
    [self.delegate testInkBrush1ViewControllerDelegateDidFinish:@"some string"];    
        
    
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }

    


    
}




@end
