//
//  BFRGifRefreshControl.h
//  Buffer
//
//  Created by Jordan Morgan on 4/27/16.
//
//

#import <UIKit/UIKit.h>

@interface BFRGifRefreshControl : UIControl

@property (assign, nonatomic) CGFloat dataRefreshOffsetThreshold; //Triggers the handler
@property (assign, nonatomic) CGFloat dataRefreshingGifYInset; //Offset for the gif while data loads
@property (assign, nonatomic) CGFloat dataLoadedYInset; //Inset to set the gif back to when data loads
@property (assign, nonatomic) CGFloat dataLoadedYOffset; //Offset of the sv to be at when data loads

- (instancetype)initWithGifFileName:(NSString *)refreshingGifName refreshAction:(void (^)())refreshAction;
- (instancetype)initWithGifData:(NSData *)refreshingGifData refreshAction:(void (^)())refreshAction;
- (void)containingScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)stopAnimating:(UIScrollView *)scrollView;
@end
