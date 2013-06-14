//
//  AMAdapterMobclix.m
//  DemoProject
//
//  Created by Gor Avakyan on 01.08.12.
//
//

#import "AMAdapterMobclix.h"
#import "AMAdNetworkRegistry.h"
#import "AMView.h"
#import "Mobclix.h"
#import "AMAdNetworkConfig.h"

@implementation AMAdapterMobclix

#pragma mark - Initialize

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeMobClix;
}

- (id)initWithAMDelegate:(id<AMDelegate>)delegate view:(AMView *)view config:(AMConfig *)config networkConfig:(AMAdNetworkConfig *)netConf
{
    self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf];
    if (self) {
        self.adNetworkView = [[[MobclixAdView alloc] initWithFrame:view.bounds] autorelease];
        [Mobclix startWithApplicationId:netConf.pubId];
    }
    
    return self;
}

#pragma mark - Adapter implementation

- (void)getAd {
    MobclixAdView *adView = (MobclixAdView *)self.adNetworkView;
    adView.delegate = self;
    [adView getAd];
}

- (void)stopBeingDelegate {
    MobclixAdView *adView = (MobclixAdView *)self.adNetworkView;
    adView.delegate = nil;
    [adView cancelAd];
}


#pragma mark - Banner view delegate

- (void)adViewDidFinishLoad:(MobclixAdView*)adView {
	[self.amView adapter:self didReceiveAdView:adView];
    [self.amView adapterDidFinishAdRequest:self];
}

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error {
	[self.amView adapter:self didFailAd:error];
}
@end
