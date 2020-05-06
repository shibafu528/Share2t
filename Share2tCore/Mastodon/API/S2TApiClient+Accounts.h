//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient.h"
#import "S2TMastodonAccount.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^S2TApiVerifyCredentialsSuccessCallback)(NSURLSessionDataTask *__nonnull task, S2TMastodonAccount *__nonnull account);

@interface S2TApiClient (Accounts)

- (NSURLSessionDataTask*)verifyCredentials:(nullable S2TApiVerifyCredentialsSuccessCallback)success
                                   failure:(nullable S2TApiFailureCallback)failure;

@end

NS_ASSUME_NONNULL_END
