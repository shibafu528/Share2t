//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient+Accounts.h"

@implementation S2TApiClient (Accounts)

- (nonnull NSURLSessionDataTask *)verifyCredentials:(nullable S2TApiVerifyCredentialsSuccessCallback)success
                                            failure:(nullable S2TApiFailureCallback)failure {
    return [self.manager GET:@"/api/v1/accounts/verify_credentials"
                  parameters:nil
                     headers:self.defaultHeaders
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (success) {
            success(task, [MTLJSONAdapter modelOfClass:S2TMastodonAccount.class fromJSONDictionary:responseObject error:nil]);
        }
    }
                     failure:failure];
}

@end
