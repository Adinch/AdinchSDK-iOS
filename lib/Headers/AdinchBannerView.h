#import <UIKit/UIKit.h>

typedef enum {
    AdinchBannerViewSizeType320x50,
    AdinchBannerViewSizeType300x250
}AdinchBannerViewSizeType;

@class AdinchBannerView;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol AdinchBannerViewDelegate <NSObject>
@optional

// Sent when an ad request loaded
- (void)bannerViewDidLoad:(AdinchBannerView *)view;

// Sent when an ad request failed
- (void)bannerView:(AdinchBannerView *)view didFailLoadAdWithError:(NSError *)error;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AdinchBannerView : UIView
// Delegate object that receives notifications when banner view ready to appear an ad or when banner view needs to disappear
@property (nonatomic, assign) id<AdinchBannerViewDelegate> delegate;

// Ad unique key created with generated app
@property (nonatomic, copy) NSString * adsKey;

// Default type is AMBannerViewSizeType320x50
@property (readonly, nonatomic) AdinchBannerViewSizeType sizeType;

- (id)initWithSizeType:(AdinchBannerViewSizeType)type;

- (void)requestNewBanner;
- (BOOL)canRequestBanner;

- (BOOL)isLoaded;

+ (NSString *)sdkVersion;
- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

// Use initWithSizeType:
- (id)initWithKey:(NSString *)adsKey __attribute__((deprecated));
+ (id)requestBannerViewWithKey:(NSString *)adsKey delegate:(id<AdinchBannerViewDelegate>)delegate __attribute__((deprecated));

@end

