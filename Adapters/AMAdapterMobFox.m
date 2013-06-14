//
//  AMAdapterMobFox.m
//  DemoProject
//
//  Created by Gor Avakyan on 01.08.12.
//
//

#import "AMAdapterMobFox.h"
#import "AMAdNetworkRegistry.h"
#import "AMView.h"
#import "AMAdNetworkConfig.h"

@implementation AMAdapterMobFox

#pragma mark - Initialize

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeMobFox;
}

- (id)initWithAMDelegate:(id<AMDelegate>)delegate view:(AMView *)view config:(AMConfig *)config networkConfig:(AMAdNetworkConfig *)netConf
{
    self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Adapter implementation

- (void)getAd {
    MobFoxBannerView *view = [[[MobFoxBannerView alloc] initWithFrame:self.amView.bounds] autorelease];
    view.delegate = self;
    self.adNetworkView = view;
}

- (void)stopBeingDelegate {
    MobFoxBannerView *view = (MobFoxBannerView *)self.adNetworkView;
    view.delegate = nil;
    self.adNetworkView = nil;
}


#pragma mark - Banner view delegate

- (NSString *)publisherIdForMobFoxBannerView:(MobFoxBannerView *)banner
{
    return self.networkConfig.pubId;
}

- (void)mobfoxBannerViewDidLoadMobFoxAd:(MobFoxBannerView *)banner
{
    [self.amView adapter:self didReceiveAdView:banner];
    [self.amView adapterDidFinishAdRequest:self];
}

- (void)mobfoxBannerView:(MobFoxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self.amView adapter:self didFailAd:error];
}


@end
