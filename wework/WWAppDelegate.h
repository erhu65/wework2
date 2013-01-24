//
//  WWAppDelegate.h
//  wework
//
//  Created by Peter2 on 1/23/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "SurfsUpAppDelegate.h"
#import "WebViewJavascriptBridge.h"
#import "Utils.h"

@interface WWAppDelegate : SurfsUpAppDelegate <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)NSString* token;

@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

@end
