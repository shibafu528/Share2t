//
// Copyright (c) 2020 shibafu
//

#import "S2TMastodonAccessToken.h"

@implementation S2TMastodonAccessToken

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"accessToken": @"access_token",
        @"tokenType": @"token_type",
        @"scope": @"scope",
        @"createdAt": @"created_at",
    };
}

@end
