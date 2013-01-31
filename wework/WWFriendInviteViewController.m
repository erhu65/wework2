//
//  WWFriendInviteViewController.m
//  wework
//
//  Created by Peter2 on 1/29/13.
//  Copyright (c) 2013 Peter2. All rights reserved.
//

#import "WWFriendInviteViewController.h"
#import "BRDModel.h"
#import "WWAppDelegate.h"
#import "DetailViewController_iPad.h"
#import "WWRecordMyRoom.h"
#import "WWCellMyRoom.h"

@interface WWFriendInviteViewController ()
<UITableViewDataSource,UITableViewDelegate,
UIScrollViewDelegate, 
UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray* docs;
@property (weak, nonatomic) IBOutlet UITableView *tb;

@property(nonatomic, strong)NSNumber* page;
@property(nonatomic)BOOL isLastPage;

@end

@implementation WWFriendInviteViewController
{
    BOOL addItemsTrigger;
}


-(NSMutableArray*)docs{
    
    if(nil == _docs){
        _docs = [[NSMutableArray alloc] init];
    }
    return _docs;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil){
        //self.imvThumb = nil;
    }
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self){
        addItemsTrigger = NO;
        self.isDisableInAppNotification = NO;
        self.title = kSharedModel.lang[@"titleFriendInvite"];
        self.page = @0;
        self.isLastPage = YES;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self tb] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tb.backgroundColor = [UIColor clearColor];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:kSharedModel.theme[@"bg_sand"]]];
    self.view.backgroundColor  = background;
    
    [self _fetchFriendInviteRooms:self.page fbId:kSharedModel.fbId];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRNotificationFacebookMeDidUpdate object:kSharedModel];
}

-(void)_handleFacebookMeDidUpdate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString* error = userInfo[@"error"];
    if(nil != error){
        [self hideHud:YES];
        [self showMsg:error type:msgLevelWarn]; 
        return;
    }
    [self _fetchFriendInviteRooms:self.page fbId:kSharedModel.fbId];
    //NSDictionary *userInfo = [notification userInfo];
    PRPLog(@"kSharedModel.fbId: %@-[%@ , %@]",
           kSharedModel.fbId,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
}


-(void)_fetchFriendInviteRooms:(NSNumber*)page 
                fbId:(NSString*)fbId{
    
    if(nil == fbId){
        [kSharedModel fetchFacebookMe];
        return;
    }
    
    [self showHud:YES];
    __weak __block WWFriendInviteViewController* weakSelf = self;
    [kSharedModel fetchFriendInviteRooms:fbId 
                            withPage:page 
                           withBlock:^(NSDictionary* res) {
                               
                               [weakSelf hideHud:YES];
                               
                               if(nil != res 
                                  && nil != res[@"error"]){
                                   
                                   [self showMsg:res[@"error"] type:msgLevelError];
                                   return;
                               }
                               
                               NSMutableArray* mTempArr =(NSMutableArray*)res[@"mTempArr"];
                               NSRange range = NSMakeRange(0, mTempArr.count); 
                               NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:range];
                               [weakSelf.docs insertObjects:mTempArr atIndexes:indexes];
                               
                               weakSelf.isLastPage = [((NSNumber*)res[@"isLastPage"]) boolValue];
                               weakSelf.page = res[@"page"];
                               
                               if(self.docs.count > 0){
                                   
                                   PRPLog(@"self.docs.count: %d-[%@ , %@]",
                                          weakSelf.docs.count,
                                          NSStringFromClass([self class]),
                                          NSStringFromSelector(_cmd));
                                   [weakSelf.tb reloadData];
                               } 
                               
                           }];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWCellMyRoom *WWCellMyRoom = [self.tb dequeueReusableCellWithIdentifier:@"WWCellMyRoom"];
    
    WWRecordMyRoom* record = [self.docs objectAtIndex:[indexPath row]];
    WWCellMyRoom.record = record;
    WWCellMyRoom.indexPath = indexPath;
    WWCellMyRoom.btnInvite.hidden = YES;
    WWCellMyRoom.btnEdit.hidden = YES;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"table-row-background.png"];
    WWCellMyRoom.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    return WWCellMyRoom;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.docs count];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    WWRecordMyRoom* record = [self.docs objectAtIndex:[indexPath row]];
    kAppDelegate.detail.room = record._id;

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
            [self _fetchFriendInviteRooms:self.page fbId:kSharedModel.fbId];
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
