//
//  BFRGifRefreshControl.h
//  Buffer
//
//  Created by Jordan Morgan on 4/27/16.
//
//

#import <UIKit/UIKit.h>

@interface BFRGifRefreshControl : UIControl

- (instancetype)initWithRefreshingDataGif:(NSString *)refreshingGifName completion:(void (^)())completion;
- (void)containingScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)stopAnimating:(UIScrollView *)scrollView;
@end
