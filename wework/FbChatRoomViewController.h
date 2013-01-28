//
//  FbChatRoomViewController.h
//  BirthdayReminder
//
//  Created by Peter2 on 12/28/12.
//  Copyright (c) 2012 Nick Kuh. All rights reserved.
//

#import "BRCoreViewController.h"

@protocol FbChatRoomViewControllerDelegate <NSObject>

@optional

-(BOOL)FbChatRoomViewControllerDelegateToggleOutterUI;
-(void)FbChatRoomViewControllerDelegateTriggerOuterGoBack;
-(void)FbChatRoomViewControllerDelegateTriggerOuterAction1:(id)record;
-(void)FbChatRoomViewControllerDelegateTriggerOuterAction2;
-(void)FbChatRoomViewControllerDelegateGetOutterInfo;

@end


@interface FbChatRoomViewController : BRCoreViewController
@property(nonatomic, strong)NSString* room;
@property(nonatomic) BOOL isLeaving;
@property(nonatomic, strong) NSString* uniquDataKey;

@property(nonatomic, weak) id<FbChatRoomViewControllerDelegate> delegate;
-(void) leaveRoom;

@end
