//
//  WWSample1ViewController.m
//  wework
//
//  Created by Peter2 on 1/25/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "WWSample1ViewController.h"

@interface WWSample1ViewController ()

@end

@implementation WWSample1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//WWSample1ViewController *sample1VC = [[WWSample1ViewController alloc] init];
//- (void)loadView {
//    
//    self.view = [[UIView alloc] init];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(225, 50, 90, 30)];
//    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchDown];
//    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    
//    [self.view addSubview:button];
//}

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
- (IBAction)dismiss:(id)sender {
    
    if(nil != self.delegate){
        
        [self.delegate didSelectSomeThing:@"some string"];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    }
}

@end
