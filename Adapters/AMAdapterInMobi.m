/*
 
 AMAdapterInMobi.m
 
 Copyright 2010 AdMob, Inc.
 
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

#import "AMAdapterInMobi.h"
#import "AMAdNetworkConfig.h"
#import "AMView.h"
#import "IMAdView.h"
#import "IMAdRequest.h"
#import "AMLog.h"
#import "AMAdNetworkAdapter+Helpers.h"
#import "AMAdNetworkRegistry.h"

@implementation AMAdapterInMobi

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeInMobi;
}

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    IMAdView *inMobiView = [[IMAdView alloc]
                            initWithFrame:kAMViewDefaultFrame
                            imAppId:[self siteId]
                            imAdUnit:IM_UNIT_320x50
                            rootViewController:[self rootViewControllerForAd]];
    [inMobiView autorelease];
    inMobiView.refreshInterval = REFRESH_INTERVAL_OFF;
    inMobiView.delegate = self;
    self.adNetworkView = inMobiView;
    
    IMAdRequest *request = [IMAdRequest request];
    
    if ([self testMode]) {
        request.testMode = true;
    }
    if ([amDelegate respondsToSelector:@selector(postalCode)]) {
        request.postalCode = [amDelegate postalCode];
    }
    if ([amDelegate respondsToSelector:@selector(areaCode)]) {
        request.areaCode = [amDelegate areaCode];
    }
    if ([amDelegate respondsToSelector:@selector(dateOfBirth)]) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        request.dateOfBirth = [formatter
                               stringFromDate:[amDelegate dateOfBirth]];
    }
    if ([amDelegate respondsToSelector:@selector(gender)]) {
        if ([amDelegate gender] == @"m") {
            request.gender = G_M;
        } else if ([amDelegate gender] == @"f") {
            request.gender = G_F;
        } else {
            request.gender = G_None;
        }
    }
    if ([amDelegate respondsToSelector:@selector(keywords)]) {
        request.keywords = [amDelegate keywords];
    }
    if ([amDelegate respondsToSelector:@selector(searchString)]) {
        request.searchString = [amDelegate searchString];
    }
    if ([amDelegate respondsToSelector:@selector(incomeLevel)]) {
        request.income = [amDelegate incomeLevel];
    }
    if ([amDelegate respondsToSelector:@selector(inMobiEducation)]) {
        request.education = [amDelegate inMobiEducation];
    }
    if ([amDelegate respondsToSelector:@selector(inMobiEthnicity)]) {
        request.ethnicity = [amDelegate inMobiEthnicity];
    }
    if ([amDelegate respondsToSelector:@selector(dateOfBirth)]) {
        request.age = [self helperCalculateAge];
    }
    if ([amDelegate respondsToSelector:@selector(inMobiInterests)]) {
        request.interests = [amDelegate inMobiInterests];
    }
    if ([amDelegate respondsToSelector:@selector(inMobiParamsDictionary)]) {
        request.paramsDictionary = [amDelegate inMobiParamsDictionary];
    }
    if (amConfig.locationOn) {
        CLLocation *location =
        (CLLocation *)[self
                       helperDelegateValueForSelector:@selector(locationInfo)];
        if (location) {
            [request setLocation:location];
        }
    }
    
    [inMobiView loadIMAdRequest:request];
}

- (void)stopBeingDelegate {
    InMobiAdView *inMobiView = (InMobiAdView *)self.adNetworkView;
    if (inMobiView != nil) {
        [inMobiView setDelegate:nil];
    }
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark IMAdView helper methods

- (NSString *)siteId {
    if ([amDelegate respondsToSelector:@selector(inMobiAppId)]) {
        return [amDelegate inMobiAppID];
    }
    return networkConfig.pubId;
}

- (UIViewController *)rootViewControllerForAd {
    return [amDelegate viewControllerForPresentingModalView];
}

- (BOOL)testMode {
    if ([amDelegate respondsToSelector:@selector(AMTestMode)])
        return [amDelegate AMTestMode];
    return NO;
}

- (GenderType)gender {
    if ([amDelegate respondsToSelector:@selector(gender)]) {
        NSString *genderStr = [amDelegate gender];
        if ([genderStr isEqualToString:@"f"]) {
            return G_F;
        } else if ([genderStr isEqualToString:@"m"]) {
            return G_M;
        }
    }
    return G_None;
}

#pragma mark IMAdDelegate methods

- (void)adViewDidFinishRequest:(IMAdView *)adView {
    [amView adapter:self didReceiveAdView:adView];
}

- (void)adView:(IMAdView *)view didFailRequestWithError:(IMAdError *)error {
    AMLogDebug(@"Error %@", error);
    [amView adapter:self didFailAd:nil];
    [amView adapterDidFinishAdRequest:self];
}

- (void)adViewWillPresentScreen:(IMAdView *)adView {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adViewWillDismissScreen:(IMAdView *)adView {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)adViewWillLeaveApplication:(IMAdView *)adView {
    [self helperNotifyDelegateOfFullScreenModal];
}

@end
