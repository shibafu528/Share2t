//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient+Apps.h"

NSString* const S2TDefaultRedirectTo = @"urn:ietf:wg:oauth:2.0:oob";

@implementation S2TApiClient (Apps)

- (nonnull NSURLSessionDataTask *)createApp:(nonnull NSString *)clientName
                                 redirectTo:(nonnull NSString *)redirectTo
                                     scopes:(nullable NSString *)scopes
                                    website:(nullable NSString *)website
                                    success:(nullable S2TApiCreateAppSuccessCallback)success
                                    failure:(nullable S2TApiFailureCallback)failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_name"] = clientName;
    params[@"redirect_to"] = redirectTo;
    if (scopes) {
        params[@"scopes"] = scopes;
    }
    if (website) {
        params[@"website"] = website;
    }
    
    AFHTTPSessionManager *manager = self.manager;
    return [manager POST:@"/api/v1/apps" parameters:params headers:nil progress:nil
                 success:^(NSURLSessionDataTask *task, id response) {
        if (success) {
            success(task, [MTLJSONAdapter modelOfClass:S2TMastodonApp.class fromJSONDictionary:response error:nil]);
        }
    }
                 failure:failure];
}

- (nonnull NSString *)authorizeURL:(nonnull NSString *)clientId
                        redirectTo:(nonnull NSString *)redirectTo
                            scopes:(nullable NSString *)scopes {
    NSArray *params = @[
        [@"client_id=" stringByAppendingString:clientId],
        [@"redirect_uri=" stringByAppendingString:redirectTo],
        @"response_type=code",
    ];
    if (scopes) {
        params = [params arrayByAddingObject:[@"scope=" stringByAppendingString:scopes]];
    }
    return [NSString stringWithFormat:@"https://%@/oauth/authorize?%@", self.host, [params componentsJoinedByString:@"&"]];
}

- (nonnull NSURLSessionDataTask *)obtainAccessToken:(nonnull NSString *)clientId
                                       clientSecret:(nonnull NSString *)clientSecret
                                         redirectTo:(nonnull NSString *)redirectTo
                                             scopes:(nullable NSString *)scopes
                                               code:(nonnull NSString *)code
                                          grantType:(nullable NSString *)grantType
                                            success:(nullable S2TApiObtainAccessTokenSuccessCallback)success
                                            failure:(nullable S2TApiFailureCallback)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = clientId;
    params[@"client_secret"] = clientSecret;
    params[@"redirect_uri"] = redirectTo;
    if (scopes) {
        params[@"scope"] = scopes;
    }
    params[@"code"] = code;
    params[@"grant_type"] = grantType ?: @"authorization_code";
    
    AFHTTPSessionManager *manager = self.manager;
    return [manager GET:@"/oauth/token" parameters:params headers:nil progress:nil
                success:^(NSURLSessionDataTask *task, id response) {
        if (success) {
            success(task, [MTLJSONAdapter modelOfClass:S2TMastodonAccessToken.class fromJSONDictionary:response error:nil]);
        }
    }
                failure:failure];
}

@end
