//
//  SurfsUpViewController.m
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

#import "SurfsUpViewController.h"

#import "CustomCell.h"
//#import "PlaceholderViewController.h"

NSString * const REUSE_ID_TOP = @"TopRow";
NSString * const REUSE_ID_MIDDLE = @"MiddleRow";
NSString * const REUSE_ID_BOTTOM = @"BottomRow";
NSString * const REUSE_ID_SINGLE = @"SingleRow";

@implementation SurfsUpViewController

#pragma mark - Private behavior and "Model" methods

- (NSString *)tripNameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return @"Kuta, Bali";
            break;
        case 1:
            return @"Lagos, Portugal";
            break;
        case 2:
            return @"Waikiki, Hawaii";
            break;
    }
    return @"-";
}

- (UIImage *)tripPhotoForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return [UIImage imageNamed:@"surf1.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"surf2.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"surf3.png"];
            break;
    }
    return nil;
}

- (NSString *)reuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    
    if (rowCount == 1)
    {
        return REUSE_ID_SINGLE;
    }
    
    if (rowIndex == 0)
    {
        return REUSE_ID_TOP;
    }
    
    if (rowIndex == (rowCount - 1))
    {
        return REUSE_ID_BOTTOM;
    }
    
    return REUSE_ID_MIDDLE;
}

- (UIImage *)backgroundImageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [self reuseIdentifierForRowAtIndexPath:indexPath];
    if ([REUSE_ID_SINGLE isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_single.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 43.0, 0.0, 64.0)];
    }
    else if ([REUSE_ID_TOP isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_top.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 43.0, 0.0, 64.0)];
    }
    else if ([REUSE_ID_BOTTOM isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_bottom.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 34.0, 0.0, 35.0)];
    }
    else    // REUSE_ID_MIDDLE
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_mid.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];
    }
}

- (UIImage *)selectedBackgroundImageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [self reuseIdentifierForRowAtIndexPath:indexPath];
    if ([REUSE_ID_SINGLE isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_single_sel.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 43.0, 0.0, 64.0)];
    }
    else if ([REUSE_ID_TOP isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_top_sel.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 43.0, 0.0, 64.0)];
    }
    else if ([REUSE_ID_BOTTOM isEqualToString:reuseID] == YES)
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_bottom_sel.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 34.0, 0.0, 35.0)];
    }
    else    // REUSE_ID_MIDDLE
    {
        UIImage *background = [UIImage imageNamed:@"table_cell_mid_sel.png"]; 
        return [background resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];
    }
}

- (void)registerNIBs
{
    NSBundle *classBundle = [NSBundle bundleForClass:[CustomCell class]];
    
    UINib *topNib = [UINib nibWithNibName:REUSE_ID_TOP bundle:classBundle];    
    [[self tableView] registerNib:topNib forCellReuseIdentifier:REUSE_ID_TOP];
    
    UINib *middleNib = [UINib nibWithNibName:REUSE_ID_MIDDLE bundle:classBundle];    
    [[self tableView] registerNib:middleNib forCellReuseIdentifier:REUSE_ID_MIDDLE];
    
    UINib *bottomNib = [UINib nibWithNibName:REUSE_ID_BOTTOM bundle:classBundle];    
    [[self tableView] registerNib:bottomNib forCellReuseIdentifier:REUSE_ID_BOTTOM];
    
    UINib *singleNib = [UINib nibWithNibName:REUSE_ID_SINGLE bundle:classBundle];    
    [[self tableView] registerNib:singleNib forCellReuseIdentifier:REUSE_ID_SINGLE];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNIBs];
    
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_sand.png"]]];
}

#pragma mark - UITableViewCell

- (void)configureCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[cell tripPhoto] setImage:[self tripPhotoForRowAtIndexPath:indexPath]];
    [[cell tripName] setText:[self tripNameForRowAtIndexPath:indexPath]];
    
    CGRect cellRect = [cell frame];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:cellRect];
    [backgroundView setImage:[self backgroundImageForRowAtIndexPath:indexPath]];
    [cell setBackgroundView:backgroundView];
    
    UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:cellRect];
    [selectedBackgroundView setImage:[self selectedBackgroundImageForRowAtIndexPath:indexPath]];     
    [cell setSelectedBackgroundView:selectedBackgroundView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [self reuseIdentifierForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:reuseID];
    [self configureCell:(CustomCell *)cell forRowAtIndexPath:indexPath];        
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:[self tableView] cellForRowAtIndexPath:indexPath];
    return [cell frame].size.height;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
