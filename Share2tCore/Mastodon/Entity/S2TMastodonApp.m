//
// Copyright (c) 2020 shibafu
//

#import "S2TMastodonApp.h"

@implementation S2TMastodonApp

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"clientId": @"client_id",
        @"clientSecret": @"client_secret",
        @"vapidKey": @"vapid_key",
    };
}

@end
