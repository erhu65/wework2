//
//  WWAppDelegate.m
//  wework
//
//  Created by Peter2 on 1/23/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "WWAppDelegate.h"
#import "SurfsUpViewController_iPad.h"
#import "DetailViewController_iPad.h"

@implementation WWAppDelegate

- (void)customizeAppearance
{
    [super customizeAppearance];
    
    // UIToolbar
    
    UIImage *gradientTop = [[UIImage imageNamed:@"surf_gradient_textured_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UIToolbar appearance] setBackgroundImage:gradientTop 
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault]; 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationControllerMaster = [splitViewController.viewControllers objectAtIndex:0];
    SurfsUpViewController_iPad* master =  (SurfsUpViewController_iPad*) navigationControllerMaster.topViewController;
    
    master.title =  @"Surf's Up";
    master.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    navigationControllerMaster.title = @"Surf's Up";
  
    UINavigationController *navigationControllerDetail = [splitViewController.viewControllers lastObject];
   DetailViewController_iPad* detail = (DetailViewController_iPad*)navigationControllerDetail.topViewController;
    [master setDetailVC:detail];

    splitViewController.delegate = (id)navigationControllerDetail.topViewController;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
