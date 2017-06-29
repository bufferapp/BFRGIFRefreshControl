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

@interface BFRGifRefreshControl()

@property (strong, nonatomic) UIImageView *initialImage;
@property (strong, nonatomic) FLAnimatedImageView *refreshingDataGif;
@property (nonatomic, getter=shouldPlayHapticFeedback) BOOL playHapticFeedback;
@property (strong, nonatomic) UIImpactFeedbackGenerator *impactGenerator;
@property (nonatomic, getter=isiOS10OrAbove) BOOL iOS10OrAbove;
@property (copy) void (^refreshAction)(void);

@end

@implementation BFRGifRefreshControl

#pragma mark - Setters
- (void)setDisabledRefresh:(BOOL)disabledRefresh {
    _disabledRefresh = disabledRefresh;
    self.initialImage.hidden = disabledRefresh;
    self.refreshingDataGif.hidden = disabledRefresh;
}

#pragma mark - Initializers
- (instancetype)initWithGifFileName:(NSString *)refreshingGifName refreshAction:(void (^)())refreshAction {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:refreshingGifName ofType:@".gif"];
    NSURL *gifURL = [NSURL fileURLWithPath:filePath];
    NSData *gifData = [NSData dataWithContentsOfURL:gifURL];
    
    return [[BFRGifRefreshControl alloc] initWithGifData:gifData refreshAction:refreshAction];
}

- (instancetype)initWithGifData:(NSData *)refreshingGifData refreshAction:(void (^)())refreshAction {
    self = [super init];
    
    if (self) {
        self.iOS10OrAbove = ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion >= 10);
        
        if (self.isiOS10OrAbove) {
            self.playHapticFeedback = YES;
            self.impactGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        }
        
        FLAnimatedImage *firstGif = [FLAnimatedImage animatedImageWithGIFData:refreshingGifData];
        self.refreshingDataGif = [FLAnimatedImageView new];
        self.refreshingDataGif.animatedImage = firstGif;
        self.refreshingDataGif.contentMode = UIViewContentModeScaleAspectFit;
        
        self.initialImage = [[UIImageView alloc] initWithImage:firstGif.posterImage];
        self.initialImage.backgroundColor = [UIColor redColor];
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
        
        self.initialImage.alpha = 0.0f;
    }
    
    return self;
}

- (void)containingScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isiOS10OrAbove) {
        [self.impactGenerator prepare];
    }
    
    // If the refresh control has traveled past the bottom of the trigger view plsu the offset, trigger the action
    CGPoint gifTranslatedOrigin = [self.initialImage convertPoint:self.initialImage.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    CGPoint targetTranslatedOrigin = [self.triggerView convertPoint:self.triggerView.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    CGFloat bottomGif = gifTranslatedOrigin.y + self.initialImage.frame.size.height;
    CGFloat bottomTriggerView = targetTranslatedOrigin.y + self.triggerView.frame.size.height;
    
    
    NSLog(@"B7: Distance%f",gifTranslatedOrigin.y - bottomTriggerView);
    
    //TODO: Right now, this calculates the % complete only when the whole gif image is below the trigger view. Need to make the alpha start changing once the initial view is below the trigger view at all, then set the alpha == to the distance left to travel
    if (bottomGif >= bottomTriggerView) {
        CGFloat distanceFromTriggerViewBottom = gifTranslatedOrigin.y - bottomTriggerView;
        CGFloat percentComplete = (distanceFromTriggerViewBottom/self.loadingOffset) * 1;
        NSLog(@"B7: percent complete%f",percentComplete);
      //  BOOL triggerRefresh = percentComplete >= 1;
        self.initialImage.alpha = percentComplete;
    } else {
        self.initialImage.alpha = 0.0f;
    }
    
    if (scrollView.contentOffset.y <= -self.dataRefreshOffsetThreshold) {
        if (self.isiOS10OrAbove && self.shouldPlayHapticFeedback == YES) {
            [self.impactGenerator impactOccurred];
            [self.impactGenerator prepare];
            self.playHapticFeedback = NO;
        }
    } else {
        self.playHapticFeedback = YES;
    }
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (self.hasDisabledRefresh) {
        return;
    }
    
    [self.refreshingDataGif stopAnimating];
    
    if (scrollView.contentOffset.y <= -self.dataRefreshOffsetThreshold) {
        [self.refreshingDataGif startAnimating];
        self.animating = YES;
        self.refreshingDataGif.hidden = NO;
        self.initialImage.hidden = YES;
        
        UIEdgeInsets loadingInsets = scrollView.contentInset;
        loadingInsets.top = self.dataRefreshingGifYInset;
        
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

- (void)setGifFilename:(NSString *)refreshingGifName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:refreshingGifName ofType:@".gif"];
    NSURL *gifURL = [NSURL fileURLWithPath:filePath];
    NSData *gifData = [NSData dataWithContentsOfURL:gifURL];
    
    FLAnimatedImage *firstGif = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.refreshingDataGif.animatedImage = firstGif;
    self.initialImage.image = firstGif.posterImage;
}

@end
