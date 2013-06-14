/*
 
 AMAdNetworkAdapter.h
 
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

#import "AMDelegateProtocol.h"
#import "AMConfig.h"

typedef enum {
    AMAdNetworkTypeAdMob                = 1,
    AMAdNetworkTypeJumpTap              = 2,
    AMAdNetworkTypeVideoEgg             = 3,
    AMAdNetworkTypeMedialets            = 4,
    AMAdNetworkTypeLiveRail             = 5,
    AMAdNetworkTypeMillennial           = 6,
    AMAdNetworkTypeGreyStripe           = 7,
    AMAdNetworkTypeQuattro              = 8,
    AMAdNetworkTypeCustom               = 9,
    AMAdNetworkTypeAM10                 = 10,
    AMAdNetworkTypeMobClix              = 11,
    AMAdNetworkTypeMdotM                = 12,
    AMAdNetworkTypeAM13                 = 13,
    AMAdNetworkTypeGoogleAdSense        = 14,
    AMAdNetworkTypeGoogleDoubleClick    = 15,
    AMAdNetworkTypeGeneric              = 16,
    AMAdNetworkTypeEvent                = 17,
    AMAdNetworkTypeInMobi               = 18,
    AMAdNetworkTypeIAd                  = 19,
    AMAdNetworkTypeZestADZ              = 20,
    AMAdNetworkTypeBrightRoll           = 21,
    AMAdNetworkTypeTapAd                = 22,
    AMAdNetworkTypeOneRiot              = 23,
    AMAdNetworkTypeNexage               = 24,
    AMAdNetworkTypeAdinch               = 25,
    AMAdNetworkTypeTapjoy               = 26,
    AMAdNetworkTypeMobFox               = 27,
    AMAdNetworkTypeKomliMobile          = 28,
    AMAdNetworkTypeSmaato               = 29,
    AMAdNetworkTypeAdFonic              = 30,
} AMAdNetworkType;

@class AMView;
@class AMConfig;
@class AMAdNetworkConfig;

@interface AMAdNetworkAdapter : NSObject {
    id<AMDelegate> amDelegate;
    AMView *amView;
    AMConfig *amConfig;
    AMAdNetworkConfig *networkConfig;
    UIView *adNetworkView;
}

/**
 * Subclasses must implement +networkType to return an AMAdNetworkType enum.
 */
+ (AMAdNetworkType)networkType;

/**
 * Subclasses must add itself to the AMAdNetworkRegistry. One way
 * to do so is to implement the +load function and register there.
 */
//+ (void)load;

/**
 * Default initializer. Subclasses do not need to override this method unless
 * they need to perform additional initialization. In which case, this
 * method must be called via the super keyword.
 */
- (id)initWithAMDelegate:(id<AMDelegate>)delegate
                    view:(AMView *)view
                  config:(AMConfig *)config
           networkConfig:(AMAdNetworkConfig *)netConf;

/**
 * Ask the adapter to get an ad. This must be implemented by subclasses.
 */
- (void)getAd;

/**
 * When called, the adapter must remove itself as a delegate or notification
 * observer from the underlying ad network SDK. Subclasses must implement this
 * method, even if the underlying SDK doesn't have a way of removing delegate
 * (in which case, you should contact the ad network). Note that this method
 * will be called in dealloc at AMAdNetworkAdapter, before adNetworkView
 * is released. Care must be taken if you also keep a reference of your ad view
 * in a separate instance variable, as you may have released that variable
 * before this gets called in AMAdNetworkAdapter's dealloc. Use
 * adNetworkView, defined in this class, instead of your own instance variable.
 * This function should also be idempotent, i.e. get called multiple times and
 * not crash.
 */
- (void)stopBeingDelegate;


/**
 * Tell the adapter that the interface orientation changed or is about to change
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

/**
 * Some ad transition types may cause issues with particular ad networks. The
 * adapter should know whether the given animation type is OK. Defaults to
 * YES.
 */
- (BOOL)isBannerAnimationOK:(AMBannerAnimationType)animType;

@property (nonatomic,assign) id<AMDelegate> amDelegate;
@property (nonatomic,assign) AMView *amView;
@property (nonatomic,retain) AMConfig *amConfig;
@property (nonatomic,retain) AMAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIView *adNetworkView;

@end
