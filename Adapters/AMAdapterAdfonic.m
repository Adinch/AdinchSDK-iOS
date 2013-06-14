//
//  AMAdapterAdfonic.m
//  DemoProject
//
//  Created by Gor Avakyan on 01.08.12.
//
//

#import "AMAdapterAdfonic.h"
#import "AMAdNetworkRegistry.h"
#import "AMView.h"
#import "AMAdNetworkConfig.h"

@implementation AMAdapterAdfonic

#pragma mark - Initialize

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeAdFonic;
}

- (id)initWithAMDelegate:(id<AMDelegate>)delegate view:(AMView *)view config:(AMConfig *)config networkConfig:(AMAdNetworkConfig *)netConf
{
    self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf];
    if (self) {
        ADFBannerView *adView = [ADFBannerView bannerViewWithType:@"banner"];
        adView.delegate = self;
        adView.frame = view.bounds;
        self.adNetworkView = adView;
    }
    
    return self;
}

#pragma mark - Adapter implementation

- (void)getAd
{
    ADFRequest *request = [ADFRequest requestForSlotID:networkConfig.pubId];
    request.type = @"banner";
    request.contentSizeIdentifier = @"iphonePortrait";
    [(ADFBannerView *)self.adNetworkView loadRequest:request];
}

- (void)stopBeingDelegate
{
    ADFBannerView *view = (ADFBannerView *)self.adNetworkView;
    view.delegate = nil;
}


#pragma mark - Banner view delegate

- (void)bannerViewDidLoadAd:(ADFBannerView *)banner
{
    [self.amView adapter:self didReceiveAdView:banner];
    [self.amView adapterDidFinishAdRequest:self];
}

- (void)bannerView:(ADFBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self.amView adapter:self didFailAd:error];
}


@end
