/*

 AMLog.h

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

typedef enum {
  AMLogLevelNone  = 0,
  AMLogLevelCrit  = 10,
  AMLogLevelError = 20,
  AMLogLevelWarn  = 30,
  AMLogLevelInfo  = 40,
  AMLogLevelDebug = 50
} AMLogLevel;

void AMLogSetLogLevel(AMLogLevel level);

// The actual function name has an underscore prefix, just so we can
// hijack AMLog* with other functions for testing, by defining
// preprocessor macros
void _AMLogCrit(NSString *format, ...);
void _AMLogError(NSString *format, ...);
void _AMLogWarn(NSString *format, ...);
void _AMLogInfo(NSString *format, ...);
void _AMLogDebug(NSString *format, ...);

#ifndef AMLogCrit
#define AMLogCrit(...) _AMLogCrit(__VA_ARGS__)
#endif

#ifndef AMLogError
#define AMLogError(...) _AMLogError(__VA_ARGS__)
#endif

#ifndef AMLogWarn
#define AMLogWarn(...) _AMLogWarn(__VA_ARGS__)
#endif

#ifndef AMLogInfo
#define AMLogInfo(...) _AMLogInfo(__VA_ARGS__)
#endif

#ifndef AMLogDebug
#define AMLogDebug(...) _AMLogDebug(__VA_ARGS__)
#endif
