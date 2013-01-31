//
//  FbChatRoomViewController.m
//  BirthdayReminder
//
//  Created by Peter2 on 12/28/12.
//  Copyright (c) 2012 Nick Kuh. All rights reserved.
//

#import "FbChatRoomViewController.h"
#import "WebViewJavascriptBridge.h"
#import "BRDModel.h"
#import "BRRecordFbChat.h"
#import "BRCellfBChat.h"
//#import "BRRecordSubCategory.h"
#import "QuartzCore/QuartzCore.h"
#import "UIView+position.h"

#import "HorizontalTableViewCell.h"
#import "Utils.h"

#define KTempTfInKeyboard 7789

#define KTbFriendsOnLine 1342


@interface FbChatRoomViewController ()
<UITableViewDataSource,UITableViewDelegate,
UIScrollViewDelegate,
BRCellfBChatDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (weak, nonatomic) IBOutlet UITableView *tbFriendsOnLine;

@property (weak, nonatomic) IBOutlet UITextView* tvOutPut;
@property (weak, nonatomic) IBOutlet UITextField *tfMsg;



@property (weak, nonatomic) IBOutlet UIButton* joinRoomButton;
@property (weak, nonatomic) IBOutlet UIButton* chatButton;
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;
@property (weak, nonatomic) IBOutlet UITextField *tfChat;


@property (strong, nonatomic) IBOutlet UIToolbar *tb;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBarRoom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnTalk;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnJoin;

@property (weak, nonatomic) IBOutlet UILabel *lbRoomCount;
@property (weak, nonatomic) IBOutlet UITableView *tbFbChat;
@property(nonatomic, strong)NSNumber* page;
@property(nonatomic)BOOL isLastPage;
@property(strong, nonatomic) NSMutableArray* mArrFbChat;
@property(strong, nonatomic) NSMutableDictionary* mDicFriendOnLine;
@property(strong, nonatomic) NSMutableArray* mArrFriendOnLine;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityChatRoom;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnZoom;
@property(nonatomic) BOOL isZoomed;
@property (weak, nonatomic) IBOutlet UIView *vContainer;

@property (nonatomic, strong) NSArray *hConstraintVContainer;
@property (nonatomic, strong) NSArray *vConstraintVContainer;

@end


@implementation FbChatRoomViewController
{
    BOOL addItemsTrigger;
}
@synthesize javascriptBridge = _bridge;


-(NSMutableDictionary*)mDicFriendOnLine
{
    if(nil == _mDicFriendOnLine){
        _mDicFriendOnLine = [[NSMutableDictionary alloc] init];
    }
    
    return _mDicFriendOnLine;
}
-(NSMutableArray*)mArrFriendOnLine
{
    if(nil == _mArrFriendOnLine){
        _mArrFriendOnLine = [[NSMutableArray alloc] init];
    }
    [_mArrFriendOnLine removeAllObjects];
    
    if(self.isJoinFbChatRoom){
        [self.mDicFriendOnLine enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            NSString* fbId = (NSString*)key;
            NSString* fbName = (NSString*)object;
            NSDictionary* friend = @{@"fbId": fbId,
                                     @"fbName": fbName};
            [_mArrFriendOnLine addObject:friend];
            
        }];

    }
    
    return _mArrFriendOnLine;
}


-(void)setIsLeaving:(BOOL)isLeaving{
    
    _isLeaving = isLeaving;
    if(isLeaving){
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BRNotificationFacebookMeDidUpdate object:[BRDModel sharedInstance]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        //Clear A UIWebView to trigger window.onunload
        [self.webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"http://google.com"]];    
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil){
        //self.imvThumb = nil;
        self.tb = nil;
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self){
        self.isDisableInAppNotification = NO;
        
        addItemsTrigger = NO;
        self.page = @0;
        self.isLastPage = YES;
        
        self.isJoinFbChatRoom = NO;
        self.isLeaving = NO;
        self.isZoomed = YES;
        self.mArrFbChat = [[NSMutableArray alloc] init];
        self.isDisableInAppNotification = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //node.js socket.io webview bridge start...
    [self.view  insertSubview:self.webview atIndex:0];
    
    //add custom key input to the dummy textfield
    self.tfChat.inputAccessoryView = [self accessoryView];
    self.tfChat.backgroundColor = [UIColor whiteColor];
    [self.tfChat.layer setCornerRadius:18];
    self.tfChat.borderStyle = UITextBorderStyleBezel;
    self.tfChat.frameWidth = 180.0f;
    self.tfChat.frameHeight = 30.0f;
    
    self.barBtnJoin.title = self.lang[@"actionJoin"];
    self.barBtnTalk.title = self.lang[@"actionTalk"];
    self.btnZoom.title = self.lang[@"actionFull"];
    //hide activityChatRoom first
    self.activityChatRoom.hidden = YES;
    
    self.tbFbChat.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.tfMsg.clearButtonMode = UITextFieldViewModeWhileEditing;
    [BRStyleSheet styleLabel:self.lbRoomCount withType:BRLabelTypeLarge];
    
	CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
	self.tbFriendsOnLine.transform = rotateTable;
	self.tbFriendsOnLine.frame = CGRectMake(0, 500, self.tbFriendsOnLine.frame.size.width, self.tbFriendsOnLine.frame.size.height);
    UIImage* backgroundImage = [UIImage imageNamed:@"tool-bar-background.png"];
    self.tbFriendsOnLine.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleFacebookMeDidUpdate:) name:BRNotificationFacebookMeDidUpdate object:[BRDModel sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRNotificationFacebookMeDidUpdate object:[BRDModel sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    if(self.isLeaving){
        [self leaveRoom];
    }
}
-(void) toggleChatRoomEdit:(BOOL)isEditing
{
    self.tbFbChat.editing = isEditing;
}

-(void) leaveRoom{
    
    addItemsTrigger = NO;
    self.isJoinFbChatRoom = NO;
    self.page = @0;
    self.isLastPage = YES;  
    
    [self.mArrFbChat removeAllObjects];
    [self.mArrFriendOnLine removeAllObjects];
    [self.tbFbChat reloadData];
    [self.tbFriendsOnLine reloadData];
     
    
    self.barBtnJoin.title = self.lang[@"actionJoin"];
    self.barBtnJoin.enabled = YES;

    //Clear A UIWebView to trigger window.onunload
    //Clear A UIWebView to trigger window.onunload
    NSURL* url = [[NSURL alloc] initWithString:@"http://google.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webview loadRequest:request];  
    self.activityChatRoom.hidden = YES;
    [self.activityChatRoom stopAnimating];
}



-(void)_handleFacebookMeDidUpdate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString* error = userInfo[@"error"];
    if(nil != error){
        [self showMsg:error type:msgLevelWarn]; 
        self.barBtnJoin.title = kSharedModel.lang[@"actionJoin"];
        self.barBtnJoin.enabled = YES;
        return;
    }

    PRPLog(@"[BRDModel sharedInstance].fbName: %@-[%@ , %@]",
           [BRDModel sharedInstance].fbName,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
    
    
    NSString* name = [BRDModel sharedInstance].fbName;
    NSString* fbId = [BRDModel sharedInstance].fbId;
    [self callJsJoinRoomHandler:name withFbId:fbId];

}

#pragma mark node.js socekt helper methods
-(void)_callJsDelMsgHandler:(NSString*)_id{
    
    NSDictionary* data = @{@"type": @"chat",
                           @"action": @"del",
                           @"fbId": kSharedModel.fbId,
                           @"_id": _id
                           };
    
    [_bridge callHandler:@"JsSendMsgHandler" data:data responseCallback:^(id response) {
        NSLog(@"JsSendMsgHandler responded: %@", response);
        
    }];
}

- (void)callJsSendMsgHandler:(NSString*)newMsg  {
    
    
    NSString* uniquDataKey = @"uniquDataKey defaut";
    [self _postChat:@"chat" msg:newMsg uniquDataKey:uniquDataKey fbId:kSharedModel.fbId
             fbName:kSharedModel.fbName roomId:self.room];    
}



- (void)callJsJoinRoomHandler:(NSString*)fbName
                            withFbId:(NSString*)fbId{
    
    if(nil == self.room) return;
    
    if([self.delegate respondsToSelector:@selector(FbChatRoomViewControllerDelegateGetOutterInfo)]){
        [self.delegate FbChatRoomViewControllerDelegateGetOutterInfo];
        PRPLog(@"self.room:%@   -[%@ , %@] \n ",
               self.room,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    }
    
    self.uniquDataKey = @"uniquDataKey1";
    
    NSDictionary* data =  @{@"room": self.room,
                            @"fbId": fbId,
                            @"fbName": fbName,
                            @"uniquDataKey": self.uniquDataKey};
    
    [_bridge callHandler:@"JsJoinRoomHandler" 
                    data:data 
        responseCallback:^(id response) {
        PRPLog(@"callJsJoinRoomHandler responded: %@-[%@ , %@] \n ",
               response,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    }];
}
- (void) _cancelSendMsg
{
	//[self.tfChat setText:@""];
    self.barBtnTalk.enabled = YES;
    UITextField* tfTemp = (UITextField*)[self.tb viewWithTag:KTempTfInKeyboard];
    [tfTemp resignFirstResponder];
    //[tfTemp setText:@""];
}

-(IBAction)_presentBrush{
    
    [self.delegate FbChatRoomViewControllerDelegateTriggerOuterAction2];
     //self.barBtnTalk.enabled = YES;
}


-(IBAction)_sendMsgToRoom
{
    self.barBtnTalk.enabled = NO;
    
//    UITextField* tfTemp = (UITextField*)[self.tb viewWithTag:KTempTfInKeyboard];
//    if(tfTemp.text.length == 0){
//        [self showMsg:self.lang[@"warnEmptyText"] type:msgLevelWarn];
//        return;
//    }

    if(!self.isJoinFbChatRoom){
        [self showMsg:self.lang[@"infoJoinRoomFirst"] type:msgLevelInfo];
        [self.activityChatRoom stopAnimating];
        self.activityChatRoom.hidden = YES;
        self.barBtnTalk.enabled = YES;
        [self.tfMsg resignFirstResponder];
        return;
    }
    
    self.activityChatRoom.hidden = NO;
    [self.activityChatRoom startAnimating];
    
    [self callJsSendMsgHandler: self.tfMsg.text];
    //[tfTemp resignFirstResponder];
    
   
}

-(IBAction)_prepareTextForSendMsgToRoom:(id)sender
{
    self.barBtnTalk.enabled = NO;
    double delayInSeconds = 2.0;
    
    __block __weak FbChatRoomViewController* weakSelf = (FbChatRoomViewController*)self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.barBtnTalk.enabled = YES;
    });
    
    
    [self.tfChat becomeFirstResponder];
}

- (IBAction)joinRoomWithFBAccount:(UIBarButtonItem*)sender {
    
    NSString* btnTitle = sender.title;    
    if(!self.isJoinFbChatRoom){
        
        [WebViewJavascriptBridge enableLogging];
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];
        
        [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSLog(@"testObjcCallback called: %@", data);
            responseCallback(@"Response from testObjcCallback");
        }];
        
        [_bridge registerHandler:@"iosGetMsgCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
            NSDictionary* resDic = (NSDictionary*)data;
            PRPLog(@"iosGetMsgCallback called :%@  -[%@ , %@] \n ",
                   resDic,
                   NSStringFromClass([self class]),
                   NSStringFromSelector(_cmd));
            
            

            
            NSString* type = resDic[@"type"];
            if([type isEqualToString:@"chat"] 
            || [type isEqualToString:@"server"]){
            
                //NSString* type = resDic[@"type"];
                NSString* roomCount = (NSString*)resDic[@"roomCount"];
                NSString* fbName = (NSString*)resDic[@"fbName"];
                //NSString* senderFbId =  (NSString*)resDic[@"senderFbId"];
                NSString* msg = (NSString*)resDic[@"msg"];
                NSString* fbId = (NSString*)resDic[@"fbId"];
                
                if([type isEqualToString:@"chat"]){
                    
                    if([kSharedModel.fbId isEqualToString:fbId]){
                        
                    }

                }
                
                if([type isEqualToString:@"server"]){
                    
                    __weak  FbChatRoomViewController* weakSelf = (FbChatRoomViewController* ) self;
                    NSDictionary* friendsOnLine = resDic[@"friendsOnLine"];
                    
                    if(nil != friendsOnLine){
                       
                        [friendsOnLine enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
                            NSString* fbId = (NSString*)key;
                            NSString* fbName = (NSString*)object;
                            
                            [weakSelf.mDicFriendOnLine setObject:fbName forKey:fbId];
                            [weakSelf.tbFriendsOnLine reloadData];
                        }];
                    }
                    
                    NSString* friendFbName = [self.mDicFriendOnLine objectForKey:fbId];
                    NSString* subType = resDic[@"subType"];
                    if(nil != subType 
                       && [subType isEqualToString:@"userJoin"]
                       && nil == friendFbName){
                        NSString* userJoinFbName = resDic[@"userJoinFbName"];
                        
                        [self.mDicFriendOnLine setObject:userJoinFbName forKey:fbId];
                         [weakSelf.tbFriendsOnLine reloadData];
                    } else if(nil != subType 
                              && [subType isEqualToString:@"userLeave"]
                        && nil != friendFbName) {
                       
                        [self.mDicFriendOnLine removeObjectForKey:fbId];
                        [weakSelf.tbFriendsOnLine reloadData];
                    }
                    PRPLog(@"self.mDicFriendOnLine :%@ \n\
                           self.mArrFriendOnLine :%@\n\
                           -[%@ , %@] \n ",
                           self.mDicFriendOnLine ,
                           self.mArrFriendOnLine ,
                           NSStringFromClass([self class]),
                           NSStringFromSelector(_cmd));
                }
                
                if([fbName isEqualToString:@"me"]) fbId = kSharedModel.fbId;
                
                if([fbName isEqualToString:@"server"]
                   && [msg rangeOfString:@"Good to see your"].location != NSNotFound){
                    self.isJoinFbChatRoom = YES;
                    
                    [self _fetchChatByRoom:self.room withPage:self.page];
                    [self.tbFriendsOnLine reloadData];
                }
                if(nil != roomCount){
                    self.lbRoomCount.text = [NSString stringWithFormat:@"%@: %@",kSharedModel.lang[@"onLine"], roomCount];
                }
                 NSString* action = (NSString*)resDic[@"action"];
                
                if([type isEqualToString:@"chat"] 
                   && nil != action 
                   && [action isEqualToString:@"del"]
                   && ![fbId isEqualToString:kSharedModel.fbId]
                   ){
                    
                    NSString* _id = (NSString*)resDic[@"_id"];
                    PRPLog(@"the chat creator del chat by _id :%@  -[%@ , %@] \n ",
                           _id,
                           NSStringFromClass([self class]),
                           NSStringFromSelector(_cmd));  
                    BRRecordFbChat* recordFound = [self _findChatById:_id];
                    
                    if(nil != recordFound){
                        NSUInteger* indexFound = [self.mArrFbChat indexOfObject:recordFound];
                        [self.mArrFbChat removeObject:recordFound];
                        NSIndexPath * indexPathFound = [NSIndexPath indexPathForRow:indexFound inSection:0];
                        [self.tbFbChat deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathFound] withRowAnimation:UITableViewRowAnimationFade];
                    }
  

                    

                } else if (([type isEqualToString:@"chat"] 
                    && ![fbId isEqualToString:kSharedModel.fbId] ) 
                   || [type isEqualToString:@"server"]){
                    
                    BRRecordFbChat* recordNew = [[BRRecordFbChat alloc] initWithJsonDic:resDic];
                    [self.mArrFbChat insertObject:recordNew atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    NSArray* arrIndexPathNew = @[indexPath];
                    
                    [[self tbFbChat] beginUpdates];
                    [self.tbFbChat insertRowsAtIndexPaths:arrIndexPathNew withRowAnimation:UITableViewRowAnimationAutomatic];
                    [[self tbFbChat] endUpdates];
                    [[self tbFbChat] setContentOffset:CGPointZero animated:YES];
                    self.activityChatRoom.hidden = YES;
                    [self.activityChatRoom stopAnimating];
                    self.barBtnTalk.enabled = YES;
                    self.barBtnJoin.enabled = YES;

                }
                
            }

            responseCallback(@"Response from iosGetMsgCallback: ios got chatroom msg");
        }];
        [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
            NSLog(@"objc got response! %@", responseData);
        }];
        
        [_bridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
        //node.js socket.io webview bridge end... 
        
        NSURL* url = [[NSURL alloc] initWithString:[BRDModel sharedInstance].socketUrl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webview loadRequest:request];
        [_bridge send:@"A string sent from ObjC after Webview has loaded."];
        self.barBtnJoin.title = self.lang[@"actionLeave"];
        self.barBtnJoin.enabled = FALSE;
        self.activityChatRoom.hidden = NO;
        [self.activityChatRoom startAnimating];
        if(nil != [BRDModel sharedInstance].fbId){
            
            [self _handleFacebookMeDidUpdate:nil];
        } else {
            [[BRDModel sharedInstance] fetchFacebookMe];
        }
    
    } else if([btnTitle isEqualToString:self.lang[@"actionLeave"]]){
        [self leaveRoom];

    } 

}

#pragma mark chat textfield/keyboard 
- (void) keyboardWillHide: (NSNotification *) notification
{
    UITextField* tfTemp = (UITextField*)[self.tb viewWithTag:KTempTfInKeyboard];
    tfTemp.text = @"";
}
- (void) keyboardWillShow: (NSNotification *) notification
{
    UITextField* tfTemp = (UITextField*)[self.tb viewWithTag:KTempTfInKeyboard];
    tfTemp.text = self.tfChat.text;
    [tfTemp becomeFirstResponder];
}
- (UIToolbar *) accessoryView
{
	self.tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	self.tb .tintColor = [UIColor darkGrayColor];
	NSMutableArray *items = [NSMutableArray array];
	[items addObject:BARBUTTON(@"Cancel", @selector(_cancelSendMsg))];
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];

//    [items addObject:BARBUTTON(@"add graffiti", @selector(_presentBrush))];
//    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];  
//    fixedSpace.width = 100;  
//    [items addObject:fixedSpace];
//	[items addObject:BARBUTTON(@"Send", @selector(_sendMsgToRoom))];
    

	self.tb.items = items;	
    
    int tfWidth = 0;
    if(IS_IPHONE){
        tfWidth = 165;
    } else {
        tfWidth = 500;
    }

    UITextField *tfTemp = [[UITextField alloc] initWithFrame:CGRectMake(85.0, 8.0, tfWidth, 30)];
    tfTemp.backgroundColor = [UIColor whiteColor];
    [tfTemp.layer setCornerRadius:18];
    tfTemp.borderStyle = UITextBorderStyleBezel;
    tfTemp.tag = KTempTfInKeyboard;
    [self.tb addSubview:tfTemp];
	return self.tb ;
}

- (IBAction)toggleOutterUI:(UIBarButtonItem*)sender {
    BOOL isZoomed = [self.delegate FbChatRoomViewControllerDelegateToggleOutterUI];
    if(isZoomed){
        sender.title = self.lang[@"actionSplit"];
    } else {
        sender.title = self.lang[@"actionFull"];
    }
}

- (IBAction)_back:(id)sender {
    
    UIBarButtonItem* barBtnBack = (UIBarButtonItem* )sender;
    barBtnBack.enabled = NO;    
    [self.delegate FbChatRoomViewControllerDelegateTriggerOuterGoBack];
//    [self dismissViewControllerAnimated:YES completion:^{
//    
//    }];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == KTbFriendsOnLine){
        
        HorizontalTableViewCell *cellFriend = (HorizontalTableViewCell *)[self.tbFriendsOnLine dequeueReusableCellWithIdentifier:@"HorizontalTableViewCell"];
        NSDictionary* record = [self.mArrFriendOnLine objectAtIndex:[indexPath row]];
        cellFriend.lbFbName.text = record[@"fbName"];
        
        NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",record[@"fbId"]];
        [Utils showImageAsync:cellFriend.imvFb  fromUrl:url cacheName:record[@"fbId"]];

        return cellFriend;    
        
    } else {
        BRCellfBChat *cellfBChat = (BRCellfBChat *)[self.tbFbChat dequeueReusableCellWithIdentifier:@"BRCellfBChat"];
        
        cellfBChat.tb = tableView;
        BRRecordFbChat* record = [self.mArrFbChat objectAtIndex:[indexPath row]];
        cellfBChat.record = record;
        cellfBChat.indexPath = indexPath;
        
        cellfBChat.deletate = self;
        UIImage *backgroundImage = [UIImage imageNamed:@"table-row-background.png"];
        cellfBChat.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        return cellfBChat;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == KTbFriendsOnLine){
        PRPLog(@"[self.mArrFriendOnLine count]: %d-[%@ , %@] \n ",
                [self.mArrFriendOnLine count],
                   NSStringFromClass([self class]),
                   NSStringFromSelector(_cmd));

        return [self.mArrFriendOnLine count];
    } else {
         return [self.mArrFbChat count];
    }
   
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    BRRecordFbChat* record = [self.mArrFbChat objectAtIndex:[indexPath row]];
    NSString* type = record.type;
    
    if([type isEqualToString:@"chat"] 
       && [record.fbId isEqualToString:kSharedModel.fbId])return YES;
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    } else if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BRRecordFbChat* record = [self.mArrFbChat objectAtIndex:[indexPath row]];
        [self _delChat:record._id atRow:[indexPath row]];
        
        
    }    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
//    BRRecordFbChat* record = [self.mArrFbChat objectAtIndex:[indexPath row]];
//    PRPLog(@"record.currentYoutubeKey: %@-[%@ , %@] \n ",
//           record.currentYoutubeKey,
//           
//           NSStringFromClass([self class]),
//           NSStringFromSelector(_cmd));
//    
//    
//    BRRecordFbChat* record = self.tappedRecord;
//    [self.delegate triggerOuterAction1:record];

}
#pragma mark BRCellfBChatDelegate method
-(void)BRCellfBChatDelegateCellTapped:(BRRecordFbChat *)record
{
    [self.delegate FbChatRoomViewControllerDelegateTriggerOuterAction1:record];
    
}


-(void)_postChat:(NSString*)type
             msg:(NSString*)msg
    uniquDataKey:(NSString*)uniquDataKey
            fbId:(NSString*)fbId 
          fbName:(NSString*)fbNmae
          roomId:(NSString*)roomId  
{    
    [self showHud:YES];
    __weak __block FbChatRoomViewController* weakSelf = self;
    
    [kSharedModel postChat:type 
                       msg:msg 
              uniquDataKey:uniquDataKey 
                      fbId:fbId 
                    fbName:fbNmae 
                    roomId:roomId 
                 withBlock:^(NSDictionary* res){
                     
                     [weakSelf hideHud:YES];
                     if(nil != res 
                        && nil != res[@"error"]){
                         [weakSelf showMsg:res[@"error"] type:msgLevelError];
                         return;
                     }
                     BRRecordFbChat* recordAdded = (BRRecordFbChat*)res[@"doc"];                                          
                     [weakSelf.mArrFbChat insertObject:recordAdded atIndex:0];
                     //[weakSelf.tbFbChat reloadData];
                     NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                     [weakSelf.tbFbChat insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                     
                     
                     if([self.delegate respondsToSelector:@selector(getOutterInfo)]){
                         [self.delegate FbChatRoomViewControllerDelegateGetOutterInfo];
                         PRPLog(@"uniquDataKey:%@  -[%@ , %@] \n ",
                                self.uniquDataKey,
                                NSStringFromClass([self class]),
                                NSStringFromSelector(_cmd));
                     }
                     
                     NSDictionary* data = @{@"type": @"chat",
                                            @"msg": recordAdded.msg,
                                            @"fbId":  kSharedModel.fbId,
                                            @"fbName": kSharedModel.fbName,
                                            @"uniquDataKey": self.uniquDataKey,
                                            @"_id": recordAdded._id
                                            };
                     
                     [_bridge callHandler:@"JsSendMsgHandler" data:data responseCallback:^(id response) {
                         NSLog(@"JsSendMsgHandler responded: %@", response);
                         weakSelf.tfMsg.text = @"";
                         [weakSelf.tfMsg resignFirstResponder];
                     }];
           
                     
                     
                 }];
}


- (void)_fetchChatByRoom:(NSString*)roomId 
               withPage:(NSNumber*)page{
    
    [self showHud:YES];
    __weak __block FbChatRoomViewController* weakSelf = (FbChatRoomViewController*)self;
    [kSharedModel fetchChatByRoom:roomId
                            withPage:page 
                           withBlock:^(NSDictionary* res) {
                                
                               [weakSelf hideHud:YES];
                               
                               if(nil != res 
                                  && nil != res[@"error"]){
                                   
                                   [weakSelf showMsg:res[@"error"] type:msgLevelError];
                                   return;
                               }
                               
                               NSMutableArray* mTempArr =(NSMutableArray*)res[@"mTempArr"];
                               NSRange range = NSMakeRange(0, mTempArr.count); 
                               NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:range];
                               [weakSelf.mArrFbChat insertObjects:mTempArr atIndexes:indexes];
                               
                               weakSelf.isLastPage = [((NSNumber*)res[@"isLastPage"]) boolValue];
                               weakSelf.page = res[@"page"];
                               
                               if(self.mArrFbChat.count > 0){
                                   
                                   PRPLog(@"self.mArrFbChat.count: %d-[%@ , %@]",
                                          weakSelf.mArrFbChat.count,
                                          NSStringFromClass([self class]),
                                          NSStringFromSelector(_cmd));
                                   [weakSelf.tbFbChat reloadData];
                                   
                               } 
                               
                               
                           }];
}

-(void)_delChat:(NSString*)_id
            atRow:(int) row
{
    
    [self showHud:YES];
    __weak __block FbChatRoomViewController* weakSelf = (FbChatRoomViewController*)self;
    [kSharedModel delChat:_id 
                      withBlock:^(NSDictionary* res){
                          
                          [weakSelf hideHud:YES];
                          if(nil != res 
                             && nil != res[@"error"]){
                              
                              [weakSelf showMsg:res[@"error"] type:msgLevelError];
                              return;
                          }
                          
                          BRRecordFbChat* record = [weakSelf.mArrFbChat objectAtIndex:row];
                          [weakSelf.mArrFbChat removeObject:record];
                          NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                          [weakSelf.tbFbChat deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                          [weakSelf _callJsDelMsgHandler:record._id];
                          
                      }];
    
}

-(void)_delByChatId:(NSString*)_id{
    
    
//    BRRecordFbChat* record = [self.mArrFbChat objectAtIndex:row];
//    [self.mArrFbChat removeObject:record];
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row
//                                                 inSection:0];
//    
//    [self.tbFbChat deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self _callJsDelMsgHandler:record._id];


}

-(BRRecordFbChat*)_findChatById:(NSString*)_id
{
    __block BRRecordFbChat* recordFound;
    [self.mArrFbChat enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        BRRecordFbChat* record = (BRRecordFbChat*) obj;
        NSString* __id = record._id;
        
        if([__id isEqualToString:_id]) {
            stop = YES;
            recordFound = record;
        }
    }];
    
    return recordFound;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// Detect if the trigger has been set, if so add new items
	if (addItemsTrigger)
	{
        if(!self.isLastPage){
            int page_ = [self.page intValue];
            page_++;
            self.page = [[NSNumber alloc] initWithInt:page_];
            [self _fetchChatByRoom:self.room withPage:self.page];
        }
        
	}
	// Reset the trigger
	addItemsTrigger = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Trigger the offset if the user has pulled back more than 50 pixels
    PRPLog(@"scrollView.contentOffset.y: %f \
           scrollView.frame.size.height + 80.0f %f \
           -[%@ , %@]",
           scrollView.contentOffset.y,
           (scrollView.frame.size.height + 80.0f),
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
    
	if (scrollView.contentOffset.y < -125.0f )
		addItemsTrigger = YES;
}


@end
