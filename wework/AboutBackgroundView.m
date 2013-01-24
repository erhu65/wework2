//
//  AboutBackgroundView.m
//  Surf's Up
//
//  Created by Steven Baranski on 9/17/11.
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

#import "AboutBackgroundView.h"

@implementation AboutBackgroundView

#pragma mark - UIPopoverBackgroundView

+ (CGFloat)arrowBase
{
    return 26.0f;
}

+ (CGFloat)arrowHeight
{
    return 16.0f;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(40.0f, 6.0f, 8.0f, 7.0f);
}

- (void)setArrowDirection:(UIPopoverArrowDirection)direction
{
    // no-op
}

- (UIPopoverArrowDirection)arrowDirection
{
    return UIPopoverArrowDirectionUp;
}

- (void)setArrowOffset:(CGFloat)offset
{
    // no-op
}

- (CGFloat)arrowOffset
{
    return 0.0f;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect
{
    UIEdgeInsets popoverInsets = UIEdgeInsetsMake(68.0f, 16.0f, 16.0f, 34.0f);
    UIImage *popover = [[UIImage imageNamed:@"popover_stretchable.png"] resizableImageWithCapInsets:popoverInsets];
    [popover drawInRect:rect];
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
