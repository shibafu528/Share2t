//
// Copyright (c) 2020 shibafu
//

#import "S2TStatusVisibility.h"

NSString* __nonnull NSStringFromStatusVisibility(S2TStatusVisibility visibility) {
    switch (visibility) {
        case S2TStatusPublic:
            return @"public";
            break;
        case S2TStatusUnlisted:
            return @"unlisted";
            break;
        case S2TStatusPrivate:
            return @"private";
            break;
        case S2TStatusDirect:
            return @"direct";
            break;
    }
    return @"";
}
