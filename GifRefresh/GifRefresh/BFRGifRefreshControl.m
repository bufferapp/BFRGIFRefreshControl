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
@property (copy) void (^refreshAction)(void);
@property (nonatomic) UIEdgeInsets initialInsets;
@property (nonatomic) CGPoint initialOffset;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) __kindof UIView *triggerView;

@end

@implementation BFRGifRefreshControl

#pragma mark - Setters

- (void)setDisabledRefresh:(BOOL)disabledRefresh {
    _disabledRefresh = disabledRefresh;
    self.initialImage.hidden = disabledRefresh;
    self.refreshingDataGif.hidden = disabledRefresh;
}

#pragma mark - Initializers

- (instancetype)initWithGifFileName:(NSString *)refreshingGifName scrollView:(UIScrollView *)scrollView triggerView:(__kindof UIView *)triggerView refreshAction:(void (^)())refreshAction {
    self = [super init];
    
    if (self) {
        self.playHapticFeedback = YES;
        self.impactGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:refreshingGifName ofType:@".gif"];
        NSURL *gifURL = [NSURL fileURLWithPath:filePath];
        NSData *gifData = [NSData dataWithContentsOfURL:gifURL];
        
        FLAnimatedImage *firstGif = [FLAnimatedImage animatedImageWithGIFData:gifData];
        self.refreshingDataGif = [FLAnimatedImageView new];
        self.refreshingDataGif.animatedImage = firstGif;
        self.refreshingDataGif.contentMode = UIViewContentModeScaleAspectFit;
        
        self.initialImage = [[UIImageView alloc] initWithImage:firstGif.posterImage];
        self.initialImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.initialImage];
        [self addSubview:self.refreshingDataGif];
        
        self.refreshingDataGif.hidden = YES;
        self.refreshAction = refreshAction;
        
        [self.initialImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(10);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        
        [self.refreshingDataGif mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.initialImage);
        }];
        
        self.scrollView = scrollView;
        self.initialImage.alpha = 0.0f;
        self.initialInsets = scrollView.contentInset;
        self.initialOffset = scrollView.contentOffset;
        self.triggerView = triggerView;
        self.loadingOffset = 36.0f; //Default
    }
    
    return self;
}

- (void)containingScrollViewDidScroll {
    
    [self.impactGenerator prepare];
    
    self.initialImage.alpha = [self detereminePercentComplete:self.scrollView];
    
    if ([self triggerRefresh] && self.shouldPlayHapticFeedback) {
        [self.impactGenerator impactOccurred];
        [self.impactGenerator prepare];
        self.playHapticFeedback = NO;
    }
}

- (void)containingScrollViewDidEndDragging {
    if (self.hasDisabledRefresh) {
        return;
    }
    
    [self.refreshingDataGif stopAnimating];
    
    if ([self triggerRefresh]) {
        [self.refreshingDataGif startAnimating];
        self.animating = YES;
        self.refreshingDataGif.hidden = NO;
        self.initialImage.hidden = YES;
        
        UIEdgeInsets loadingInsets = self.scrollView.contentInset;
        loadingInsets.top = self.dataRefreshingGifYInset;
        
        //Avoid iOS 8 "jump" when setting insets
        CGPoint contentOffset = self.scrollView.contentOffset;
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.scrollView.contentInset = loadingInsets;
            self.scrollView.contentOffset = contentOffset;
        } completion:^(BOOL done){
            if (self.refreshAction && done) {
                self.refreshAction();
                self.playHapticFeedback = YES;
            }
        }];
    }
}

- (void)stopAnimating {
    if (self.isAnimating) {
        self.refreshingDataGif.hidden = YES;
        self.initialImage.hidden = NO;
        self.animating = NO;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.scrollView.contentInset = self.initialInsets;
            self.scrollView.contentOffset = self.initialOffset;
        } completion:nil];
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

#pragma mark - Private Methods

- (CGFloat)detereminePercentComplete:(UIScrollView *)scrollView {
    CGPoint gifTranslatedOrigin = [self translatedImagePoint];
    CGPoint targetTranslatedOrigin = [self translatedTriggerViewPoint];
    
    CGFloat bottomGif = gifTranslatedOrigin.y + self.initialImage.frame.size.height;
    CGFloat bottomTriggerView = targetTranslatedOrigin.y + self.triggerView.frame.size.height;
    
    if (bottomGif >= bottomTriggerView) {
        CGFloat startPoint = bottomTriggerView - self.initialImage.bounds.size.height;
        CGFloat totalPointsNeededToTravel = bottomTriggerView + self.loadingOffset - startPoint;
        CGFloat pointsTraveled = gifTranslatedOrigin.y - startPoint;
        CGFloat percentComplete = (pointsTraveled/totalPointsNeededToTravel) * 1;
        
        return percentComplete;
    } else {
        return 0.0f;
    }
}

- (BOOL)triggerRefresh {
    CGPoint gifTranslatedOrigin = [self translatedImagePoint];
    CGPoint targetTranslatedOrigin = [self translatedTriggerViewPoint];
    CGFloat bottomTriggerView = targetTranslatedOrigin.y + self.triggerView.frame.size.height;
    
    return (gifTranslatedOrigin.y - bottomTriggerView) >= self.loadingOffset;
}

- (CGPoint)translatedImagePoint {
    return [self.initialImage convertPoint:self.initialImage.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (CGPoint)translatedTriggerViewPoint {
    return [self.triggerView convertPoint:self.triggerView.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

@end

