//
//  AMAdapterTapjoy.m
//  DemoProject
//
//  Created by Gor Avakyan on 01.08.12.
//
//

#import "AMAdapterTapjoy.h"
#import "AMAdNetworkRegistry.h"
#import "AMView.h"
#import "AMAdNetworkConfig.h"
#import "TJCAdRequestHandler.h"

static NSString * const appIdKey = @"pubID";
static NSString * const appSecretKey = @"appSecretKey";


@implementation AMAdapterTapjoy

#pragma mark - Initialize

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeTapjoy;
}

- (id)initWithAMDelegate:(id<AMDelegate>)delegate view:(AMView *)view config:(AMConfig *)config networkConfig:(AMAdNetworkConfig *)netConf
{
    self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf];
    if (self) {
//        [TapjoyConnect sharedTapjoyConnect].appID = [networkConfig.credentials objectForKey:appIdKey];
//        [TapjoyConnect sharedTapjoyConnect].secretKey = [networkConfig.credentials objectForKey:appSecretKey];
        
        [TapjoyConnect sharedTapjoyConnect].appID = @"93e78102-cbd7-4ebf-85cc-315ba83ef2d5";
        [TapjoyConnect sharedTapjoyConnect].secretKey = @"JWxgS26URM0XotaghqGn";
        
        
        
//        [TapjoyConnect requestTapjoyConnect:[networkConfig.credentials objectForKey:appIdKey]
//                                  secretKey:appSecretKey];
//        [TapjoyConnect requestTapjoyConnect:@"93e78102-cbd7-4ebf-85cc-315ba83ef2d5" secretKey:@"JWxgS26URM0XotaghqGn"];
        self.adNetworkView = [TapjoyConnect getDisplayAdView];
        self.adNetworkView.frame = view.bounds;
    }
    
    return self;
}

#pragma mark - Adapter implementation

- (void)getAd {
    [TapjoyConnect getDisplayAdView].adHandlerObj = [[[TJCAdRequestHandler alloc] initRequestWithDelegate:[TapjoyConnect getDisplayAdView] andRequestTag:0] autorelease];
    [TapjoyConnect getDisplayAdView].adDelegate = self;;
    [TapjoyConnect refreshDisplayAd];
}

- (void)stopBeingDelegate {
    [TJCAdView sharedTJCAdView].adDelegate = nil;
//    [TJCAdView sharedTJCAdView];
}


#pragma mark - Banner view delegate

- (void)didReceiveAd:(TJCAdView*)adView
{
	[self.amView adapter:self didReceiveAdView:adView];
    [self.amView adapterDidFinishAdRequest:self];
}


- (void)didFailWithMessage:(NSString*)msg
{
	[self.amView adapter:self didFailAd:[NSError errorWithDomain:@"com.tapjoy"
                                                            code:-1
                                                        userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]]];
}


- (NSString*)adContentSize
{
	return TJC_AD_BANNERSIZE_320X50;
}


- (BOOL)shouldRefreshAd
{
	return NO;
}

@end
