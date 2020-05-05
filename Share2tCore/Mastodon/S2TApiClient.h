//
// Copyright (c) 2020 shibafu
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^S2TApiSuccessCallback)(NSURLSessionDataTask *__nonnull task, id __nullable responseObject);
typedef void (^S2TApiFailureCallback)(NSURLSessionDataTask *__nullable task, NSError *__nullable error);

@interface S2TApiClient : NSObject

@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, readonly) AFHTTPSessionManager *manager;

- (instancetype) init __attribute__((unavailable("init is not available")));

- (instancetype) initWithHost:(NSString*)host;

- (instancetype) initWithHost:(NSString*)host
                  accessToken:(nullable NSString*)accessToken NS_DESIGNATED_INITIALIZER;

- (NSDictionary*) defaultHeaders;

@end

NS_ASSUME_NONNULL_END

#import "API/S2TApiClient+Apps.h"
#import "API/S2TApiClient+Statuses.h"
