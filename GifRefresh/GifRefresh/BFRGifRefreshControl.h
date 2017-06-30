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
 *  Whether the control is currently animating.
 */
@property (nonatomic, getter=isAnimating) BOOL animating;

/**
 *  If set to YES, the control will not trigger any refresh actions contained in the refreshAction block. The U.I. will be hidden
 *  as well. Default value is NO.
 */
@property (assign, nonatomic, getter=hasDisabledRefresh) BOOL disabledRefresh;


/**
 *  The Y content inset of where the gif will be while the refresh handler is processing or fetching data.
 */
@property (assign, nonatomic) CGFloat dataRefreshingGifYInset;

/**
 *  How far the gif needs to travel past the bottom of the trigger view to kick off a refresh.
 */
@property (assign, nonatomic) CGFloat loadingOffset;

/**
 *  Initializes an instance of this class and sets the .gif from the file name provided residing in the app's bundle.
 *
 *  @param refreshingGifName The file name of the gif to load.
 *  @param scrollView The scrollview that contains the refresh control.
 *  @param triggerView The view that the gif control should scroll past to calculate a refresh.
 *  @param refreshAction     The action to perform to refresh data.
 *
 *  @return An instance of @c BFRGifRefreshControl
 */
- (instancetype)initWithGifFileName:(NSString *)refreshingGifName scrollView:(UIScrollView *)scrollView triggerView:(__kindof UIView *)triggerView refreshAction:(void (^)())refreshAction;

/**
 *  Checks the @UIScrollView instance offset values to see if they at or past this instance's  @p dataRefreshOffsetThreshold. If so, the refresh handler will be invoked.
 *
 *  @param scrollView The @c UIScrollView instance to check offsets against.
 */
- (void)containingScrollViewDidEndDragging;


/**
 *Checks the @UIScrollView instance offset values to see if they at or past this instance's  @p dataRefreshOffsetThreshold. If so, the refresh control will play haptic feedback.
 *
 @param scrollView The @c UIScrollView instance to check offsets against.
 */
- (void)containingScrollViewDidScroll;

/**
 *  Stops the .gif animation and returns the @c UIScrollView offset and inset Y axis values back to the values set by @p dataLoadedYInset and @p dataLoadedYOffset.
 *
 *  @param scrollView The @c UIScrollView instance to reset offset and inset Y axis values for.
 */
- (void)stopAnimating;

/**
 *  Changes the .gif image to the specified image fetched via its file name.
 *
 *  @param refreshingGifName The string name of the gif's file name.
 */
- (void)setGifFilename:(NSString *)refreshingGifName;

@end

