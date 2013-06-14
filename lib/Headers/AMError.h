/*

 AMError.h

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

#define AMErrorDomain @"com.AM.sdk.ErrorDomain"

enum {
  AMConfigConnectionError = 10, /* Cannot connect to config server */
  AMConfigStatusError = 11, /* config server did not return 200 */
  AMConfigParseError = 20, /* Error parsing config from server */
  AMConfigDataError = 30,  /* Invalid config format from server */
  AMCustomAdConnectionError = 40, /* Cannot connect to custom ad server */
  AMCustomAdParseError = 50, /* Error parsing custom ad from server */
  AMCustomAdDataError = 60, /* Invalid custom ad data from server */
  AMCustomAdImageError = 70, /* Cannot create image from data */
  AMAdRequestIgnoredError = 80, /* ignoreNewAdRequests flag is set */
  AMAdRequestInProgressError = 90, /* ad request in progress */
  AMAdRequestNoConfigError = 100, /* no configurations for ad request */
  AMAdRequestTooSoonError = 110, /* requesting ad too soon */
  AMAdRequestNoMoreAdNetworks = 120, /* no more ad networks for rollover */
  AMAdRequestNoNetworkError = 130, /* no network connection */
  AMAdRequestModalActiveError = 140 /* modal view active */
};

@interface AMError : NSError {

}

+ (AMError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;
+ (AMError *)errorWithCode:(NSInteger)code description:(NSString *)desc;
+ (AMError *)errorWithCode:(NSInteger)code description:(NSString *)desc underlyingError:(NSError *)uError;

- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;
- (id)initWithCode:(NSInteger)code description:(NSString *)desc;
- (id)initWithCode:(NSInteger)code description:(NSString *)desc underlyingError:(NSError *)uError;

@end
