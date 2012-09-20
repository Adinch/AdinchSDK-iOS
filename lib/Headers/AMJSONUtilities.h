

#import <Foundation/Foundation.h>

extern NSData * JSONEncode(id object, NSError **error);
extern id JSONDecode(NSData *data, NSError **error);
