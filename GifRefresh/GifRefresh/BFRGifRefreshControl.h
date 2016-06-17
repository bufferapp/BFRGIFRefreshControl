//
//  BFRGifRefreshControl.h
//  Buffer
//
//  Created by Jordan Morgan on 4/27/16.
//
//

#import <UIKit/UIKit.h>

@interface BFRGifRefreshControl : UIControl

/**
 *  If set to YES, the control will not trigger any refresh actions contained in the refreshAction block. The U.I. will be hidden
 *  as well. Default value is NO.
 */
@property (assign, nonatomic, getter=hasDisabledRefresh) BOOL disabledRefresh;

/**
 *  The point at which the user must scroll to or past for the refresh handler to be called.
 */
@property (assign, nonatomic) CGFloat dataRefreshOffsetThreshold;

/**
 *  The Y content inset of where the gif will be while the refresh handler is processing or fetching data.
 */
@property (assign, nonatomic) CGFloat dataRefreshingGifYInset;

/**
 *  The Y content inset of where the gif should be after the refresh handler has been executed.
 */
@property (assign, nonatomic) CGFloat dataLoadedYInset;

/**
 *  The Y content offset of what the containing @c UIScrollView should be set to after the refresh handler has been executed.
 */
@property (assign, nonatomic) CGFloat dataLoadedYOffset;

/**
 *  Initializes an instance of this class and sets the .gif from the file name provided residing in the app's bundle.
 *
 *  @param refreshingGifName The file name of the gif to load.
 *  @param refreshAction     The action to perform to refresh data.
 *
 *  @return An instance of @c BFRGifRefreshControl
 */
- (instancetype)initWithGifFileName:(NSString *)refreshingGifName refreshAction:(void (^)())refreshAction;

/**
 *  Initializes an instance of this class and sets the .gif from the file name provided residing in the app's bundle.
 *
 *  @param refreshingGifData The @c NSData that the .gif will be created from.
 *  @param refreshAction     The action to perform to refresh data.
 *
 *  @return An instance of @c BFRGifRefreshControl
 */
- (instancetype)initWithGifData:(NSData *)refreshingGifData refreshAction:(void (^)())refreshAction;

/**
 *  Checks the @UIScrollView instance offset values to see if they at or past this instance's  @p dataRefreshOffsetThreshold. If so, the refresh handler will be invoked.
 *
 *  @param scrollView The @c UIScrollView instance to check offsets against.
 */
- (void)containingScrollViewDidEndDragging:(UIScrollView *)scrollView;

/**
 *  Stops the .gif animation and returns the @c UIScrollView offset and inset Y axis values back to the values set by @p dataLoadedYInset and @p dataLoadedYOffset.
 *
 *  @param scrollView The @c UIScrollView instance to reset offset and inset Y axis values for.
 */
- (void)stopAnimating:(UIScrollView *)scrollView;

@end
