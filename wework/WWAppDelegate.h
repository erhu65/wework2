//
//  WWAppDelegate.h
//  wework
//
//  Created by Peter2 on 1/23/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "SurfsUpAppDelegate.h"
#import "WebViewJavascriptBridge.h"

@class DetailViewController_iPad;

@interface WWAppDelegate : SurfsUpAppDelegate <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)NSString* token;

@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

@property (nonatomic, weak)DetailViewController_iPad* detail;

@end
