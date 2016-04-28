//
//  BFRGifRefreshControl.m
//  Buffer
//
//  Created by Jordan Morgan on 4/27/16.
//
//

#import "BFRGifRefreshControl.h"
#import "Masonry.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

//TODO: Different initializer if gif isn't in app bundle, us NSData or a URL
//TODO: Offset must be tweakable

@interface BFRGifRefreshControl()
@property (nonatomic, getter=isAnimating) BOOL animating;
@property (strong, nonatomic) UIImageView *initialImage;
@property (strong, nonatomic) FLAnimatedImageView *refreshingDataGif;
@property (copy) void (^refreshAction)(void);
@end

@implementation BFRGifRefreshControl

#pragma mark - Initializers
- (instancetype)initWithGifFileName:(NSString *)refreshingGifName refreshAction:(void (^)())refreshAction {
    //Get the gif from the app bundle
    NSString *filePath = [[NSBundle mainBundle] pathForResource:refreshingGifName ofType:@".gif"];
    NSURL *gifURL = [NSURL fileURLWithPath:filePath];
    NSData *gifData = [NSData dataWithContentsOfURL:gifURL];
    
    return [[BFRGifRefreshControl alloc] initWithGifData:gifData refreshAction:refreshAction];
}

- (instancetype)initWithGifData:(NSData *)refreshingGifData refreshAction:(void (^)())refreshAction {
    self = [super init];
    
    if (self) {
        FLAnimatedImage *firstGif = [FLAnimatedImage animatedImageWithGIFData:refreshingGifData];
        self.refreshingDataGif = [FLAnimatedImageView new];
        self.refreshingDataGif.animatedImage = firstGif;
        self.refreshingDataGif.contentMode = UIViewContentModeScaleAspectFit;
        
        //Set up our initial image from the first frame in the gif
        self.initialImage = [[UIImageView alloc] initWithImage:firstGif.posterImage];
        self.initialImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.initialImage];
        [self addSubview:self.refreshingDataGif];
        
        self.refreshingDataGif.hidden = YES;
        self.refreshAction = refreshAction;
        
        [self.initialImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(15);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
        [self.refreshingDataGif mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.initialImage);
        }];
    }
    
    return self;
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)scrollView {
    [self.refreshingDataGif stopAnimating];
    
    if (scrollView.contentOffset.y <= -self.dataRefreshOffsetThreshold) {
        [self.refreshingDataGif startAnimating];
        self.animating = YES;
        self.refreshingDataGif.hidden = NO;
        self.initialImage.hidden = YES;
        
        UIEdgeInsets loadingInsets = scrollView.contentInset;
        loadingInsets.top = self.dataRefreshingGifOffset;
        
        //Avoid iOS 8 "jump" when setting insets
        CGPoint contentOffset = scrollView.contentOffset;
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            scrollView.contentInset = loadingInsets;
            scrollView.contentOffset = contentOffset;
        }completion:^(BOOL done){
            if (self.refreshAction && done) {
                self.refreshAction();
            }
        }];
    }
}

- (void)stopAnimating:(UIScrollView *)scrollView {
    if (self.isAnimating) {
        self.refreshingDataGif.hidden = YES;
        self.initialImage.hidden = NO;
        self.animating = NO;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(self.dataLoadedYInset, 0, 0, 0);
            scrollView.contentOffset = CGPointMake(0, self.dataLoadedYOffset);
        }completion:nil];
    }
}
@end
