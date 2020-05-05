//
// Copyright (c) 2020 shibafu
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, S2TStatusVisibility) {
    S2TStatusPublic,
    S2TStatusUnlisted,
    S2TStatusPrivate,
    S2TStatusDirect,
};

NSString* __nonnull NSStringFromStatusVisibility(S2TStatusVisibility visibility);

NS_ASSUME_NONNULL_END
