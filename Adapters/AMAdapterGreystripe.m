/*

 AMAdapterGreystripe.m

 Copyright 2010 Greystripe, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

#import "AMAdapterGreystripe.h"

#import "AMAdNetworkAdapter+Helpers.h"
#import "AMAdNetworkConfig.h"
#import "AMAdNetworkRegistry.h"
#import "AMLog.h"
#import "AMView.h"
#import "GSAdView.h"
#import "GSAdEngine.h"

// constants
NSString * const kGSBannerSlotName = @"gsBanner";
NSString * const kGSFullScreenSlotName = @"gsFullScreen";

// static globals
static BOOL g_didStartUpGreystripe;
static NSTimeInterval g_lastAdReadyTime;

@interface AMAdapterGreystripe ()
- (void)bannerAdReady;
@end

@implementation AMAdapterGreystripe

+ (AMAdNetworkType)networkType {
  return AMAdNetworkTypeGreyStripe;
}

+ (void)load {
  [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

/**
 * Initialize the Greystripe adapter. The GSAdEngine will be started up the
 * first time this method is called, using the ID provided by the AM
 * server. Two slots will be registered with the GSAdEngine: one banner and one
 * full-screen. See the note in AMAdapterGreystripe.h on how to make use
 * of the full-screen slot.
 */
- (id)initWithAMDelegate:(id<AMDelegate>)delegate
                         view:(AMView *)view
                       config:(AMConfig *)config
                networkConfig:(AMAdNetworkConfig *)netConf {
  if(self = [super initWithAMDelegate:delegate view:view config:config networkConfig:netConf]) {
    if(!g_didStartUpGreystripe) {
      @try {
        GSAdSlotDescription * bannerSlot = [GSAdSlotDescription descriptionWithSize:kGSAdSizeBanner name:kGSBannerSlotName];
        GSAdSlotDescription * fullScreenSlot = [GSAdSlotDescription descriptionWithSize:kGSAdSizeIPhoneFullScreen name:kGSFullScreenSlotName];
        [GSAdEngine startupWithAppID:netConf.pubId adSlotDescriptions:[NSArray arrayWithObjects:bannerSlot,fullScreenSlot, nil]];
        g_didStartUpGreystripe = YES;
      }
      @catch (NSException *e) {
        // This exception is thrown when Greystripe is initialized twice. We
        // ignore it because if the host app is using Greystripe directly for
        // full-screen ads, it may have already initialized Greystripe before
        // AM tried to do the same.
        if([e.name isEqualToString:NSInternalInconsistencyException]){
          g_didStartUpGreystripe = YES;
        }
        else {
          @throw e;
        }
      }
    }
  }
  return self;
}


/**
 * Fetch a banner ad from Greystripe. This method only fetches banners as all
 * full-screen ad fetching is performed implicitly by the GSAdEngine.
 */
- (void)getAd {
  GSAdView *gsAdView = [GSAdView adViewForSlotNamed:kGSBannerSlotName delegate:self];

  // Use default frame, slightly bigger, to be the parent view of gsAdView, so
  // when the GSAdView finds its containing view it stops at the inner Container
  // and will set the alpha of innerContainer, not the AMView
  innerContainer = [[UIView alloc] initWithFrame:kAMViewDefaultFrame];
  innerContainer.backgroundColor = [UIColor clearColor];
  [innerContainer addSubview:gsAdView];

  // Set the outer container to be the size of the gsAdView so there are no unsightly
  // borders around the ad
  outerContainer = [[UIView alloc] initWithFrame:gsAdView.frame];
  outerContainer.backgroundColor = [UIColor clearColor];
  [outerContainer addSubview:innerContainer];
  self.adNetworkView = outerContainer;

  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval delta = now - g_lastAdReadyTime;
  if(delta > kGSMinimumRefreshInterval) {
    // For the initial ad display we will get an ad ready notification
    // automatically because the ad is automatically rendered
    // regardless of its refresh interval (0 here). For all other
    // displays we must force it.
    if(g_lastAdReadyTime > 0) {
      if([GSAdEngine isNextAdDownloadedForSlotNamed:kGSBannerSlotName]) {
        [gsAdView refresh];
        [self bannerAdReady];
      }
      else {
        AMLogDebug(@"Failing Greystripe banner ad request because the next "\
                   "banner ad has not yet been downloaded.");
        [amView adapter:self didFailAd:nil];
      }
    }
  }
  else {
    AMLogDebug(@"Failing Greystripe ad request because Greystripe's "
               "minimum refresh interval of %f has not elapsed since the "\
               "previous banner display.", kGSMinimumRefreshInterval);
    [amView adapter:self didFailAd:nil];
  }
}

/**
 * Stop being the delegate for banner ads. In order to change the delegate for
 * full-screen Greystripe ads, see GSAdEngine's 
 * setFullScreenDelegate:forSlotNamed: method.
 */
- (void)stopBeingDelegate {
  [GSAdView adViewForSlotNamed:kGSBannerSlotName delegate:nil];
}

- (void)dealloc {
  [innerContainer release];
  [outerContainer release];
  [super dealloc];
}

#pragma mark -
#pragma mark GreystripeDelegate notification methods

/**
 * Delegate notification received when Greystripe has a banner ad ready.
 */
- (void)greystripeAdReadyForSlotNamed:(NSString *)a_name {
  if ([a_name isEqualToString:kGSBannerSlotName] && g_lastAdReadyTime == 0) {
    // Only forward on this notification for the initial notification as
    // all other notifications will be sent explicitly after checking
    // ad readiness (see getAd).
    [self bannerAdReady];
      [amView adapterDidFinishAdRequest:self];
  }
}

- (void)greystripeFullScreenDisplayWillOpen {
  [self helperNotifyDelegateOfFullScreenModal];
}

- (void)greystripeFullScreenDisplayWillClose {
  [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark -
#pragma mark Internal methods

/**
 * Notify the host app that Greystripe has received an ad. This only applies
 * banner ads that the Greystripe SDK has fetched, as readiness of full-screen
 * ads can be always be checked directly via
 * [GSAdEngine isAdReadyForSlotNamed:kGSFullScreenSlotName].
 */
- (void)bannerAdReady {
  AMLogDebug(@"Greystripe received banner ad.");
  g_lastAdReadyTime = [[NSDate date] timeIntervalSince1970];
  [amView adapter:self didReceiveAdView:self.adNetworkView];
}

@end
