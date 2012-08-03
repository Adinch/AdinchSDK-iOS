#import <UIKit/UIKit.h>

// iPhone/iPod Touch ad size
#define AD_SIZE_320x50		CGSizeMake(320, 50)

@protocol AMBannerViewDelegate;
@interface AMBannerView : UIView
// Delegate object that receives notifications when banner view ready to appear an ad or when banner view needs to disappear
@property (nonatomic, assign) id<AMBannerViewDelegate> delegate;

// Ad unique key created with generated app
@property (nonatomic, copy) NSString * adsKey;

- (id)initWithKey:(NSString *)adsKey;
+ (id)requestBannerViewWithKey:(NSString *)adsKey delegate:(id<AMBannerViewDelegate>)delegate;

- (void)requestNewBanner;

+ (NSString *)sdkVersion;
- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end

@protocol AMBannerViewDelegate <NSObject>
@optional

// Sent when an ad request loaded 
- (void)bannerViewDidLoad:(AMBannerView *)view;

// Sent when an ad request failed
- (void)bannerView:(AMBannerView *)view didFailLoadAdWithError:(NSError *)error;
@end