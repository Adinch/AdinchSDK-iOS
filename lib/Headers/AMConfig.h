/*

 AMConfig.h

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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class AMConfig;
@protocol AMConfigDelegate<NSObject>

@optional
- (void)AMConfigDidReceiveConfig:(AMConfig *)config;
- (void)AMConfigDidFail:(AMConfig *)config error:(NSError *)error;
- (NSURL *)AMConfigURL;

@end

typedef enum {
  AMBannerAnimationTypeNone           = 0,
  AMBannerAnimationTypeFlipFromLeft   = 1,
  AMBannerAnimationTypeFlipFromRight  = 2,
  AMBannerAnimationTypeCurlUp         = 3,
  AMBannerAnimationTypeCurlDown       = 4,
  AMBannerAnimationTypeSlideFromLeft  = 5,
  AMBannerAnimationTypeSlideFromRight = 6,
  AMBannerAnimationTypeFadeIn         = 7,
  AMBannerAnimationTypeRandom         = 8,
} AMBannerAnimationType;

@class AMAdNetworkConfig;
@class AMAdNetworkRegistry;

@interface AMConfig : NSObject {
  NSString *appKey;
  NSURL *configURL;
  BOOL legacy;

  BOOL adsAreOff;
  NSMutableArray *adNetworkConfigs;

  UIColor *backgroundColor;
  UIColor *textColor;
  NSTimeInterval refreshInterval;
  BOOL locationOn;
  AMBannerAnimationType bannerAnimationType;
  NSInteger fullscreenWaitInterval;
  NSInteger fullscreenMaxAds;

  NSMutableArray *delegates;
  BOOL hasConfig;

  AMAdNetworkRegistry *adNetworkRegistry;
}

- (id)initWithAppKey:(NSString *)ak delegate:(id<AMConfigDelegate>)delegate;
- (BOOL)parseConfig:(NSData *)data error:(NSError **)error;
- (BOOL)addDelegate:(id<AMConfigDelegate>)delegate;
- (BOOL)removeDelegate:(id<AMConfigDelegate>)delegate;
- (void)notifyDelegatesOfFailure:(NSError *)error;

@property (nonatomic,readonly) NSString *appKey;
@property (nonatomic,readonly) NSURL *configURL;

@property (nonatomic,readonly) BOOL hasConfig;

@property (nonatomic,readonly) BOOL adsAreOff;
@property (nonatomic,readonly) NSArray *adNetworkConfigs;
@property (nonatomic,readonly) UIColor *backgroundColor;
@property (nonatomic,readonly) UIColor *textColor;
@property (nonatomic,readonly) NSTimeInterval refreshInterval;
@property (nonatomic,readonly) BOOL locationOn;
@property (nonatomic,readonly) AMBannerAnimationType bannerAnimationType;
@property (nonatomic,readonly) NSInteger fullscreenWaitInterval;
@property (nonatomic,readonly) NSInteger fullscreenMaxAds;

@property (nonatomic,assign) AMAdNetworkRegistry *adNetworkRegistry;

@end


// Convenience conversion functions, converts val into native types var.
// val can be NSNumber or NSString, all else will cause function to fail
// On failure, return NO.
BOOL awIntVal(NSInteger *var, id val);
BOOL awFloatVal(CGFloat *var, id val);
BOOL awDoubleVal(double *var, id val);
