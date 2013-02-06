//
//  SurfsUpViewController_iPad.m
//  Surf's Up
//
//  Created by Steven Baranski on 9/16/11.
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

#import "SurfsUpViewController_iPad.h"

#import "DetailViewController_iPad.h"

@interface SurfsUpViewController_iPad ()
<UIAlertViewDelegate>

@property(nonatomic, strong)UIAlertView* avChkisAddPoints;
@end

@implementation SurfsUpViewController_iPad


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self setContentSizeForViewInPopover:CGSizeMake(320.0f, 480.0f)];
    NSIndexPath *initialPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self tableView] selectRowAtIndexPath:initialPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    self.detailVC = (DetailViewController_iPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [[self detailVC] setTitle:[self tripNameForRowAtIndexPath:initialPath]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.title = [NSString stringWithFormat:@"%d %@",
                  [kSharedModel.points intValue], kSharedModel.lang[@"units"]];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.detailVC.isJoinFbChatRoom){
        
        [self showMsg:kSharedModel.lang[@"warnPleaseJoinSubjectFirst"] type:msgLevelWarn];
        return ;
    }
    [self showHud:YES];
    PRPLog(@"indexPath.row: %d-[%@ , %@]",
           indexPath.row,
           NSStringFromClass([self class]),
           NSStringFromSelector(_cmd));
    
    [[self detailVC] setTitle:[self tripNameForRowAtIndexPath:indexPath]];
    self.detailVC.detailItem = [self tripNameForRowAtIndexPath:indexPath];

    if([kSharedModel.points intValue] <= 0){
    
        PRPLog(@"please add points first: %d-[%@ , %@]",
               [kSharedModel.points intValue],
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
        self.avChkisAddPoints = [[UIAlertView alloc] initWithTitle:kSharedModel.lang[@"info"] message:kSharedModel.lang[@"intoBuyPoints"] delegate:self cancelButtonTitle:kSharedModel.lang[@"actionOK"] otherButtonTitles:kSharedModel.lang[@"actionCancel"], nil];
        [self.avChkisAddPoints show];
        [self hideHud:YES];
        return;
    }
    
    __block __weak SurfsUpViewController_iPad* weakSelf = (SurfsUpViewController_iPad*) self;
    [kSharedModel postPointsConsumtion:@"com.erhu65.wework.amount.animation" points:@"-1" fbId:kSharedModel.fbId withBlock:^(NSDictionary* res) {
        NSString* error = res[@"error"];
        
        if(nil !=  error){
        
            [self showMsg:error type:msgLevelInfo];
            return;
        }
        NSDictionary* docPoints = res[@"doc"];
        PRPLog(@"docPoints: %@-[%@ , %@]",
               docPoints,
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
        kSharedModel.points = (NSNumber*)docPoints[@"points"];
        
        if([kSharedModel.points integerValue] > 0){
            
            [weakSelf.detailVC playAnimation:indexPath.row];
        } 
        weakSelf.title = [NSString stringWithFormat:@"%d %@",
                          [kSharedModel.points intValue], kSharedModel.lang[@"units"]];
        
        [weakSelf hideHud:YES];

    }];
    
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView == self.avChkisAddPoints) {
        if([title isEqualToString:kSharedModel.lang[@"actionOK"]]){
            
            [self performSegueWithIdentifier:@"segueStoreList" sender:nil];
        }
    } 

}

@end
