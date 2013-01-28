//
//  WWPhotoMenuViewController.m
//  wework
//
//  Created by Peter2 on 1/27/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "WWPhotoMenuViewController.h"

@interface WWPhotoMenuViewController ()

@end

@implementation WWPhotoMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoLibrary:(id)sender {
    
     [self.delegate WWPhotoMenuViewControllerDelegateDidChooseType:menuSelectedTypePhotoLibrary];
}

- (IBAction)camera:(id)sender {
    
    [self.delegate WWPhotoMenuViewControllerDelegateDidChooseType:menuSelectedTypeCamera];
}


@end
