//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient.h"
#import "S2TMastodonApp.h"
#import "S2TMastodonAccessToken.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString* const S2TDefaultRedirectTo;

typedef void (^S2TApiCreateAppSuccessCallback)(NSURLSessionDataTask *__nonnull task, S2TMastodonApp *__nonnull app);
typedef void (^S2TApiObtainAccessTokenSuccessCallback)(NSURLSessionDataTask *__nonnull task, S2TMastodonAccessToken *__nonnull accessToken);

@interface S2TApiClient (Apps)

- (NSURLSessionDataTask*) createApp:(NSString*)clientName
                         redirectTo:(NSString*)redirectTo
                             scopes:(nullable NSString*)scopes
                            website:(nullable NSString*)website
                            success:(nullable S2TApiCreateAppSuccessCallback)success
                            failure:(nullable S2TApiFailureCallback)failure;

- (NSURL*) authorizeURL:(NSString*)clientId
             redirectTo:(NSString*)redirectTo
                 scopes:(nullable NSString*)scopes;

- (NSURLSessionDataTask*) obtainAccessToken:(NSString*)clientId
                               clientSecret:(NSString*)clientSecret
                                 redirectTo:(NSString*)redirectTo
                                     scopes:(nullable NSString*)scopes
                                       code:(NSString*)code
                                  grantType:(nullable NSString*)grantType
                                    success:(nullable S2TApiObtainAccessTokenSuccessCallback)success
                                    failure:(nullable S2TApiFailureCallback)failure;

@end

NS_ASSUME_NONNULL_END
