//
// Copyright (c) 2020 shibafu
//

#import "S2TMastodonAccount.h"

@implementation S2TMastodonAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identity": @"id",
        @"username": @"username",
        @"acct": @"acct",
    };
}

@end
