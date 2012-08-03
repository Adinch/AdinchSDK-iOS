/*

 AMCustomAdView.h

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

typedef enum {
  AMCustomAdTypeMIN = 0,
  AMCustomAdTypeBanner    = 1,
  AMCustomAdTypeText      = 2,
  AMCustomAdTypeAutoLaunchFallBackBanner = 3,
  AMCustomAdTypeAutoLaunchFallBackText   = 4,
  AMCustomAdTypeSearchBar = 5,
  AMCustomAdTypeMAX = 6
} AMCustomAdType;

typedef enum {
  AMCustomAdLaunchTypeMIN = 0,
  AMCustomAdLaunchTypeSafari   = 1,
  AMCustomAdLaunchTypeCanvas   = 2,
  AMCustomAdLaunchTypeSafariRedirectFollowThrough = 3,
  AMCustomAdLaunchTypeMAX = 4
} AMCustomAdLaunchType;

typedef enum {
  AMCustomAdWebViewAnimTypeMIN = -1,
  AMCustomAdWebViewAnimTypeNone           = 0,
  AMCustomAdWebViewAnimTypeFlipFromLeft   = 1,
  AMCustomAdWebViewAnimTypeFlipFromRight  = 2,
  AMCustomAdWebViewAnimTypeCurlUp         = 3,
  AMCustomAdWebViewAnimTypeCurlDown       = 4,
  AMCustomAdWebViewAnimTypeSlideFromLeft  = 5,
  AMCustomAdWebViewAnimTypeSlideFromRight = 6,
  AMCustomAdWebViewAnimTypeFadeIn         = 7,
  AMCustomAdWebViewAnimTypeModal          = 8,
  AMCustomAdWebViewAnimTypeRandom         = 9,
  AMCustomAdWebViewAnimTypeMAX = 10
} AMCustomAdWebViewAnimType;

@class AMCustomAdView;

@protocol AMCustomAdViewDelegate<NSObject>

- (void)adTapped:(AMCustomAdView *)adView;

@end


@interface AMCustomAdView : UIButton
{
  id<AMCustomAdViewDelegate> delegate;
  UIImage *image;
  UILabel *textLabel;
  NSURL *redirectURL;
  NSURL *clickMetricsURL;
  AMCustomAdType adType;
  AMCustomAdLaunchType launchType;
  AMCustomAdWebViewAnimType animType;
  UIColor *backgroundColor;
  UIColor *textColor;
}

- (id)initWithDelegate:(id<AMCustomAdViewDelegate>)delegate
                  text:(NSString *)text
           redirectURL:(NSURL *)redirectURL
       clickMetricsURL:(NSURL *)clickMetricsURL
                adType:(AMCustomAdType)adType
            launchType:(AMCustomAdLaunchType)launchType
              animType:(AMCustomAdWebViewAnimType)animType
       backgroundColor:(UIColor *)bgColor
             textColor:(UIColor *)fgColor;

@property (nonatomic,assign) id<AMCustomAdViewDelegate> delegate;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,readonly) UILabel *textLabel;
@property (nonatomic,readonly) NSURL *redirectURL;
@property (nonatomic,readonly) NSURL *clickMetricsURL;
@property (nonatomic,readonly) AMCustomAdType adType;
@property (nonatomic,readonly) AMCustomAdLaunchType launchType;
@property (nonatomic,readonly) AMCustomAdWebViewAnimType animType;
@property (nonatomic,readonly) UIColor *backgroundColor;
@property (nonatomic,readonly) UIColor *textColor;

@end
