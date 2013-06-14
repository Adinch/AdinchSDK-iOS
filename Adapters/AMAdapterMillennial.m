/*
 
 AMAdapterMillennial.m
 
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

#import "AMAdapterMillennial.h"
#import "AMView.h"
#import "AMConfig.h"
#import "AMAdNetworkConfig.h"
#import "AMDelegateProtocol.h"
#import "AMLog.h"
#import "AMAdNetworkAdapter+Helpers.h"
#import "AMAdNetworkRegistry.h"

#define kMillennialAdFrame (CGRectMake(0, 0, 320, 53))

@interface AMAdapterMillennial ()

- (CLLocationDegrees)latitude;

- (CLLocationDegrees)longitude;

- (NSInteger)age;

- (NSString *)zipCode;

- (NSString *)sex;

@end


@implementation AMAdapterMillennial

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeMillennial;
}

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    NSString *apID;
    if ([amDelegate respondsToSelector:@selector(millennialMediaApIDString)]) {
        apID = [amDelegate millennialMediaApIDString];
    }
    else {
        apID = networkConfig.pubId;
    }
    
    requestData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                   @"AM", @"vendor",
                   nil];
    if ([self respondsToSelector:@selector(zipCode)]) {
        [requestData setValue:[self zipCode] forKey:@"zip"];
    }
    if ([self respondsToSelector:@selector(age)]) {
        [requestData setValue:[NSString stringWithFormat:@"%d",[self age]] forKey:@"age"];
    }
    if ([self respondsToSelector:@selector(sex)]) {
        [requestData setValue:[self sex] forKey:@"sex"];
    }
    if ([self respondsToSelector:@selector(latitude)]) {
        [requestData setValue:[NSString stringWithFormat:@"%lf",[self latitude]] forKey:@"lat"];
    }
    if ([self respondsToSelector:@selector(longitude)]) {
        [requestData setValue:[NSString stringWithFormat:@"%lf",[self longitude]] forKey:@"long"];
    }
    MMAdType adType = MMBannerAdTop;
    if ([amDelegate respondsToSelector:@selector(millennialMediaAdType)]) {
        adType = [amDelegate millennialMediaAdType];
    }
    MMAdView *adView = [MMAdView adWithFrame:kMillennialAdFrame
                                        type:adType
                                        apid:apID
                                    delegate:self
                                      loadAd:YES
                                  startTimer:NO];
    adView.rootViewController =
    [amDelegate viewControllerForPresentingModalView];
    self.adNetworkView = adView;
}

- (void)stopBeingDelegate {
    MMAdView *adView = (MMAdView *)adNetworkView;
    if (adView != nil) {
        [adView setRefreshTimerEnabled:false];
        adView.delegate = nil;
    }
}

- (void)dealloc {
    [requestData release];
    [super dealloc];
}

#pragma mark MMAdDelegate methods

- (NSDictionary *)requestData {
    AMLogDebug(@"Sending requestData to MM: %@", requestData);
    return requestData;
}

- (void)adRequestSucceeded:(MMAdView *)adView {
    // millennial ads are slightly taller than default frame, at 53 pixels.
    [amView adapter:self didReceiveAdView:adNetworkView];
    [amView adapterDidFinishAdRequest:self];
}

- (void)adRequestFailed:(MMAdView *)adView {
    [amView adapter:self didFailAd:nil];
}

- (void)adModalWillAppear {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adModalWasDismissed {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark requestData optional methods

// The follow is kept for gathering requestData

- (BOOL)respondsToSelector:(SEL)selector {
    if (selector == @selector(latitude)
        && ![amDelegate respondsToSelector:@selector(locationInfo)]) {
        return NO;
    }
    else if (selector == @selector(longitude)
             && ![amDelegate respondsToSelector:@selector(locationInfo)]) {
        return NO;
    }
    else if (selector == @selector(age)
             && (!([amDelegate respondsToSelector:@selector(millennialMediaAge)]
                   || [amDelegate respondsToSelector:@selector(dateOfBirth)])
                 || [self age] < 0)) {
                 return NO;
             }
    else if (selector == @selector(zipCode)
             && ![amDelegate respondsToSelector:@selector(postalCode)]) {
        return NO;
    }
    else if (selector == @selector(sex)
             && ![amDelegate respondsToSelector:@selector(gender)]) {
        return NO;
    }
    else if (selector == @selector(householdIncome)
             && ![amDelegate respondsToSelector:@selector(incomeLevel)]) {
        return NO;
    }
    else if (selector == @selector(educationLevel)
             && ![amDelegate respondsToSelector:@selector(millennialMediaEducationLevel)]) {
        return NO;
    }
    else if (selector == @selector(ethnicity)
             && ![amDelegate respondsToSelector:@selector(millennialMediaEthnicity)]) {
        return NO;
    }
    return [super respondsToSelector:selector];
}

- (CLLocationDegrees)latitude {
    CLLocation *loc = [amDelegate locationInfo];
    if (loc == nil) return 0.0;
    return loc.coordinate.latitude;
}

- (CLLocationDegrees)longitude {
    CLLocation *loc = [amDelegate locationInfo];
    if (loc == nil) return 0.0;
    return loc.coordinate.longitude;
}

- (NSInteger)age {
    if ([amDelegate respondsToSelector:@selector(millennialMediaAge)]) {
        return [amDelegate millennialMediaAge];
    }
    return [self helperCalculateAge];
}

- (NSString *)zipCode {
    return [amDelegate postalCode];
}

- (NSString *)sex {
    NSString *gender = [amDelegate gender];
    NSString *sex = @"";
    if (gender == nil)
        return sex;
    if ([gender compare:@"m"] == NSOrderedSame) {
        sex = @"M";
    }
    else if ([gender compare:@"f"] == NSOrderedSame) {
        sex = @"F";
    }
    return sex;
}

/*
 - (NSInteger)householdIncome {
 return (NSInteger)[AMDelegate incomeLevel];
 }
 
 - (MMEducation)educationLevel {
 return [AMDelegate millennialMediaEducationLevel];
 }
 
 - (MMEthnicity)ethnicity {
 return [AMDelegate millennialMediaEthnicity];
 }
 */

@end
