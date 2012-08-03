/*

 AMView.h

 Copyright 2009 AdMob, Inc.

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

#import <UIKit/UIKit.h>
#import "AMDelegateProtocol.h"
#import "AMConfig.h"

#define kAMAppVer 320

#define kAMViewWidth 320
#define kAMViewHeight 50
#define kAMViewDefaultSize \
                        (CGSizeMake(kAMViewWidth, kAMViewHeight))
#define kAMViewDefaultFrame \
                        (CGRectMake(0,0,kAMViewWidth, kAMViewHeight))

#define kAMMinimumTimeBetweenFreshAdRequests 4.9f
#define kAMAdRequestTimeout 10


@class AMAdNetworkConfig;
@class AMAdNetworkAdapter;


@interface AMView : UIView 


/**
 * Call this method to get a view object that you can add to your own view. You
 * must also provide a delegate.  The delegate provides AM's application
 * key and can listen for important messages.  You can configure the view's
 * settings and specific ad network information on AM.com or your own
 * AM server instance.
 */
+ (AMView *)requestAMViewWithDelegate:(id<AMDelegate>)delegate;

/**
 * Starts pre-fetching ad network configurations from an AM server. If the
 * configuration has been fetched when you are ready to request an ad, you save
 * a round-trip to the network and hence your ad may show up faster. You
 * typically call this in the applicationDidFinishLaunching: method of your
 * app delegate. The request is non-blocking. You only need to call this
 * at most once per run of your application. Subsequent calls to this function
 * will be ignored.
 */
+ (void)startPreFetchingConfigurationDataWithDelegate:(id<AMDelegate>)d;

/**
 * Call this method to request a new configuration from the AM servers.
 * This can be useful to support iOS 4.0 backgrounding.
 */
+ (void)updateAMConfigWithDelegate:(id<AMDelegate>)delegate;

/**
 * Call this method to request a new configuration from the AM servers.
 */
- (void)updateAMConfig;

/**
 * Call this method to get another ad to display. You can also specify under
 * "app settings" on AM.com to automatically get new ads periodically.
 */
- (void)requestFreshAd;

/**
 * Call this method if you prefer a rollover instead of a getNextAd call.  This
 * is offered primarily for developers who want to use generic notifications and
 * then execute a rollover when an ad network fails to serve an ad.
 */
- (void)rollOver;

/**
 * The delegate is informed asynchronously whether an ad succeeds or fails to
 * load. If you prefer to poll for this information, you can do so using this
 * method.
 *
 */
- (BOOL)adExists;

/**
 * Different ad networks may return different ad sizes. You may adjust the size
 * of the AMView and your UI to avoid unsightly borders or chopping off
 * pixels from ads. Call this method when you receive the AMDidReceiveAd
 * delegate method to get the size of the underlying ad network ad.
 */
- (CGSize)actualAdSize;

/**
 * Some ad networks may offer different banner sizes for different orientations.
 * Call this function when the orientation of your UI changes so the underlying
 * ad may handle the orientation change properly. You may also want to
 * call the actualAdSize method right after calling this to get the size of
 * the ad after the orientation change.
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

/**
 * Call this method to get the name of the most recent ad network that an ad
 * request was made to.
 */
- (NSString *)mostRecentNetworkName;

/**
 * Call this method to ignore the automatic refresh timer.
 *
 * Note that the refresh timer is NOT invalidated when you call
 * ignoreAutoRefreshTimer.
 * This will simply ignore the refresh events that are called by the automatic
 * refresh timer (if the refresh timer is enabled via AM.com).  So, for
 * example, let's say you have a refresh cycle of 60 seconds.  If you call
 * ignoreAutoRefreshTimer at 30 seconds, and call resumeRefreshTimer at 90 sec,
 * then the first refresh event is ignored, but the second refresh event at 120
 * sec will run.
 */
- (void)ignoreAutoRefreshTimer;
- (void)doNotIgnoreAutoRefreshTimer;
- (BOOL)isIgnoringAutoRefreshTimer;

/**
 * Call this method to ignore automatic refreshes AND manual refreshes entirely.
 *
 * This is provided for developers who asked to disable refreshing entirely,
 * whether automatic or manual.
 * If you call ignoreNewAdRequests, the AM will:
 * 1) Ignore any Automatic refresh events (via the refresh timer) AND
 * 2) Ignore any manual refresh calls (via requestFreshAd and rollOver)
 */
- (void)ignoreNewAdRequests;
- (void)doNotIgnoreNewAdRequests;
- (BOOL)isIgnoringNewAdRequests;

/**
 * Call this to replace the content of this AMView with the view.
 */
- (void)replaceBannerViewWith:(UIView*)bannerView;

/**
 * You can set the delegate to nil or another object.
 * Make sure you set the delegate to nil when you release an AMView
 * instance to avoid the AMView from calling to a non-existent delegate.
 * If you set the delegate to another object, note that if the new delegate
 * returns a different value for AMApplicationKey, it will not overwrite
 * the application key provided by the delegate you supplied for
 * +requestAMViewWithDelegate .
 */
@property (nonatomic, assign) IBOutlet id<AMDelegate> delegate;

/**
 * Use this to retrieve more information after your delegate received a
 * AMDidFailToReceiveAd message.
 */
@property (nonatomic, readonly) NSError *lastError;


#pragma mark For ad network adapters use only

/**
 * Called by Adapters when there's a new ad view.
 */
- (void)adapter:(AMAdNetworkAdapter *)adapter
                                              didReceiveAdView:(UIView *)view;

/**
 * Called by Adapters when ad view failed.
 */
- (void)adapter:(AMAdNetworkAdapter *)adapter didFailAd:(NSError *)error;

/**
 * Called by Adapters when the ad request is finished, but the ad view is
 * furnished elsewhere. e.g. Generic Notification
 */
- (void)adapterDidFinishAdRequest:(AMAdNetworkAdapter *)adapter;

@end
