#import <UIKit/UIKit.h>

// iPhone/iPod Touch ad size
#define AD_SIZE_320x50		CGSizeMake(320, 50)

typedef enum {
    AMBannerViewSizeType320x50,
    AMBannerViewSizeType300x250
}AMBannerViewSizeType;

@protocol AMBannerViewDelegate;
@interface AMBannerView : UIView
// Delegate object that receives notifications when banner view ready to appear an ad or when banner view needs to disappear
@property (nonatomic, assign) id<AMBannerViewDelegate> delegate;

// Ad unique key created with generated app
@property (nonatomic, copy) NSString * adsKey;

// Default type is AMBannerViewSizeType320x50
@property (readonly, nonatomic) AMBannerViewSizeType sizeType;

- (id)initWithSizeType:(AMBannerViewSizeType)type;

- (void)requestNewBanner;

+ (NSString *)sdkVersion;
- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

// Use initWithSizeType:
- (id)initWithKey:(NSString *)adsKey __attribute__((deprecated));
+ (id)requestBannerViewWithKey:(NSString *)adsKey delegate:(id<AMBannerViewDelegate>)delegate __attribute__((deprecated));

@end

@protocol AMBannerViewDelegate <NSObject>
@optional

// Sent when an ad request loaded 
- (void)bannerViewDidLoad:(AMBannerView *)view;

// Sent when an ad request failed
- (void)bannerView:(AMBannerView *)view didFailLoadAdWithError:(NSError *)error;
@end