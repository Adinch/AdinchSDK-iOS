//
//  AMAdapterSmaato.m
//  DemoProject
//
//  Created by Gor Avakyan on 02.08.12.
//
//

#import "AMAdapterSmaato.h"
#import "AMAdNetworkRegistry.h"
#import "AMView.h"
#import "AMAdNetworkConfig.h"

@implementation AMAdapterSmaato

#pragma mark - Initialize

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeSmaato;
}

- (id)initWithAMDelegate:(id<AMDelegate>)delegate view:(AMView *)view config:(AMConfig *)config networkConfig:(AMAdNetworkConfig *)netConf
{
    self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf];
    if (self) {
        SOMABannerView *mBannerView = [[SOMABannerView alloc] initWithDimension:kSOMAAdDimensionDefault];
        [mBannerView adSettings].adspaceId = [[netConf.credentials objectForKey:@"adspaceIDforApp"] integerValue];
        [mBannerView adSettings].publisherId = [[netConf.credentials objectForKey:@"pubID"] integerValue];
        
        [mBannerView adSettings].adType = kSOMAAdTypeImage;
        
        self.adNetworkView = mBannerView;
        [mBannerView release];
    }
    
    return self;
}

#pragma mark - Adapter implementation

- (void)getAd
{
    SOMABannerView *mBannerView = (SOMABannerView *)self.adNetworkView;
    mBannerView.delegate = self;
    [mBannerView addAdListener:self];
    [mBannerView asyncLoadNewBanner];
}

- (void)stopBeingDelegate
{
    SOMABannerView *mBannerView = (SOMABannerView *)self.adNetworkView;
    mBannerView.delegate = nil;
    [mBannerView removeAdListener:self];
}


#pragma mark - Banner view delegate

-(void)onReceiveAd:(id<SOMAAdDownloaderProtocol>)sender withReceivedBanner:(id<SOMAReceivedBannerProtocol>)receivedBanner
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([receivedBanner status] == kSOMABannerStatusError) {
        NSError *error = [NSError errorWithDomain:@"com.smaato" code:[receivedBanner errorCode]
                                         userInfo:[NSDictionary dictionaryWithObject:[receivedBanner errorMessage] forKey:NSLocalizedDescriptionKey]];
        
        [self.amView adapter:self didFailAd:error];
    } else {
        [self.amView adapter:self didReceiveAdView:self.adNetworkView];
        [self.amView adapterDidFinishAdRequest:self];
    }
}

@end
