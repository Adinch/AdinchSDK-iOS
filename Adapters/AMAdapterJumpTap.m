/*
 
 AMAdapterJumpTap.m
 
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

#import "AMAdapterJumpTap.h"
#import "AMView.h"
#import "AMConfig.h"
#import "AMAdNetworkConfig.h"
#import "AMAdNetworkAdapter+Helpers.h"
#import "AMAdNetworkRegistry.h"


@implementation AMAdapterJumpTap

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeJumpTap;
}

+ (void)load {
    [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    JTAdWidget *widget = [[JTAdWidget alloc] initWithDelegate:self
                                           shouldStartLoading:YES];
    widget.frame = kAMViewDefaultFrame;
    widget.refreshInterval = 0; // do not self-refresh
    self.adNetworkView = widget;
    
    if ([amDelegate respondsToSelector:@selector(jumptapTransitionType)]) {
        widget.transition = [amDelegate jumptapTransitionType];
    }
    [widget release];
}

- (void)stopBeingDelegate {
    // no way to set JTAdWidget's delegate to nil
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark JTAdWidgetDelegate methods

- (NSString *)publisherId:(id)theWidget {
    NSString *pubId = networkConfig.pubId;
    if (pubId == nil) {
        NSDictionary *cred = networkConfig.credentials;
        if (cred != nil) {
            pubId = [cred objectForKey:@"publisherID"];
        }
    }
    return pubId;
}

- (NSString *)site:(id)theWidget {
    NSString *siteId = nil;
    if ([amDelegate respondsToSelector:@selector(jumptapSiteId)]) {
        siteId = [amDelegate jumptapSiteId];
    }
    if (siteId == nil) {
        NSDictionary *cred = networkConfig.credentials;
        if (cred != nil) {
            siteId = [cred objectForKey:@"siteID"];
        }
    }
    return siteId;
}

- (NSString *)adSpot:(id)theWidget {
    NSString *spotId = nil;
    if ([amDelegate respondsToSelector:@selector(jumptapSpotId)]) {
        spotId = [amDelegate jumptapSpotId];
    }
    if (spotId == nil) {
        NSDictionary *cred = networkConfig.credentials;
        if (cred != nil) {
            spotId = [cred objectForKey:@"spotID"];
        }
    }
    return spotId;
}

- (BOOL)shouldRenderAd:(id)theWidget {
    [amView adapter:self didReceiveAdView:theWidget];
    [amView adapterDidFinishAdRequest:self];
    return YES;
}

- (void)beginAdInteraction:(id)theWidget {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)endAdInteraction:(id)theWidget {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)adWidget:(id)theWidget didFailToShowAd:(NSError *)error {
    [amView adapter:self didFailAd:error];
}

- (void)adWidget:(id)theWidget didFailToRequestAd:(NSError *)error {
    [amView adapter:self didFailAd:error];
}

- (BOOL)respondsToSelector:(SEL)selector {
    if (selector == @selector(location:)
        && ![amDelegate respondsToSelector:@selector(locationInfo)]) {
        return NO;
    }
    else if (selector == @selector(query:)
             && ![amDelegate respondsToSelector:@selector(keywords)]) {
        return NO;
    }
    else if (selector == @selector(category:)
             && ![amDelegate respondsToSelector:@selector(jumptapCategory)]) {
        return NO;
    }
    else if (selector == @selector(adultContent:)
             && ![amDelegate respondsToSelector:@selector(jumptapAdultContent)]) {
        return NO;
    }
    return [super respondsToSelector:selector];
}

#pragma mark JTAdWidgetDelegate methods -Targeting

- (NSString *)query:(id)theWidget {
    return [amDelegate keywords];
}

- (NSString *)category:(id)theWidget {
    return [amDelegate jumptapCategory];
}

- (AdultContent)adultContent:(id)theWidget {
    return [amDelegate jumptapAdultContent];
}

#pragma mark JTAdWidgetDelegate methods -General Configuration

- (NSDictionary*)extraParameters:(id)theWidget {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    if ([amDelegate respondsToSelector:@selector(dateOfBirth)]) {
        NSInteger age = [self helperCalculateAge];
        if (age >= 0)
            [dict setObject:[NSString stringWithFormat:@"%d",age] forKey:@"mt-age"];
    }
    if ([amDelegate respondsToSelector:@selector(gender)]) {
        NSString *gender = [amDelegate gender];
        if (gender != nil)
            [dict setObject:gender forKey:@"mt-gender"];
    }
    if ([amDelegate respondsToSelector:@selector(incomeLevel)]) {
        NSUInteger income = [amDelegate incomeLevel];
        NSString *level = nil;
        if (income < 15000) {
            level = @"000_015";
        }
        else if (income < 20000) {
            level = @"015_020";
        }
        else if (income < 30000) {
            level = @"020_030";
        }
        else if (income < 40000) {
            level = @"030_040";
        }
        else if (income < 50000) {
            level = @"040_050";
        }
        else if (income < 75000) {
            level = @"050_075";
        }
        else if (income < 100000) {
            level = @"075_100";
        }
        else if (income < 125000) {
            level = @"100_125";
        }
        else if (income < 150000) {
            level = @"125_150";
        }
        else {
            level = @"150_OVER";
        }
        [dict setObject:level forKey:@"mt-hhi"];
    }
    return dict;
}

- (UIColor *)adBackgroundColor:(id)theWidget {
    return [self helperBackgroundColorToUse];
}

- (UIColor *)adForegroundColor:(id)theWidget {
    return [self helperTextColorToUse];
}

#pragma mark JTAdWidgetDelegate methods -Location Configuration

- (BOOL)allowLocationUse:(id)theWidget {
    return amConfig.locationOn;
}

- (CLLocation*)location:(id)theWidget {
    if (![amDelegate respondsToSelector:@selector(locationInfo)]) {
        return nil;
    }
    return [amDelegate locationInfo];
}

#pragma mark JTAdWidgetDelegate methods -Ad Display and User Interaction
// The ad orientation changed
//- (void)adWidget:(id)theWidget orientationHasChangedTo:(UIInterfaceOrientation)interfaceOrientation;

// Language methods
//- (NSString*)getPlayVideoPrompt:(id)theWidget;
//- (NSString*)getBackButtonPrompt:(id)theWidget isInterstitial:(BOOL)isInterstitial;
//- (NSString*)getSafariButtonPrompt:(id)theWidget;

@end
