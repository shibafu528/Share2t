//
// Copyright (c) 2020 shibafu
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

static inline NSUserDefaults* S2TDefaults() {
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.info.shibafu528.Share2t"];
}

static inline void WriteAFNetworkingErrorToLog(NSError *error) {
    NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", body);
}
