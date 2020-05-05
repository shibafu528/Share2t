//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient.h"
#import "../S2TStatusVisibility.h"
#import "S2TPicture.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^S2TApiPostMediaSuccessCallback)(NSURLSessionDataTask *__nonnull task, NSNumber *__nonnull mediaId);

@interface S2TApiClient (Statuses)

- (NSURLSessionDataTask*) postStatus:(NSString*)status
                            mediaIds:(nullable NSArray<NSNumber*>*)mediaIds
                           sensitive:(BOOL)sensitive
                         spoilerText:(nullable NSString*)spoilerText
                          visibility:(S2TStatusVisibility)visibility
                             success:(nullable S2TApiSuccessCallback)success
                             failure:(nullable S2TApiFailureCallback)failure;

- (NSURLSessionDataTask*) postMedia:(S2TPicture*)file
                        description:(nullable NSString*)description
                            success:(nullable S2TApiPostMediaSuccessCallback)success
                            failure:(nullable S2TApiFailureCallback)failure;

@end

NS_ASSUME_NONNULL_END
