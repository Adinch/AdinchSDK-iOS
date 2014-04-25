#import <UIKit/UIKit.h>

typedef enum {
    AdinchBannerViewSizeType320x50,
    AdinchBannerViewSizeType300x250
}AdinchBannerViewSizeType;

typedef enum {
    AGT_Unknown = 0,
    AGT_Male,
    AGT_Female
} AdinchGenderType;

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
// user's gender
@property (readwrite, nonatomic, assign) AdinchGenderType userGender;
// user's age( any negative number if age is unknown )
@property (readwrite, nonatomic, assign) NSInteger userAge;

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

