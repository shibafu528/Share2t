//
// Copyright (c) 2020 shibafu
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface S2TMastodonAccount : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *identity;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *acct;

@end

NS_ASSUME_NONNULL_END
