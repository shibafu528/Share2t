//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient.h"
#import "../S2TStatusVisibility.h"

NS_ASSUME_NONNULL_BEGIN

@interface S2TApiClient (Statuses)

- (NSURLSessionDataTask*) postStatus:(NSString*)status
                            mediaIds:(nullable NSArray<NSNumber*>*)mediaIds
                           sensitive:(BOOL)sensitive
                         spoilerText:(nullable NSString*)spoilerText
                          visibility:(S2TStatusVisibility)visibility
                             success:(nullable S2TApiSuccessCallback)success
                             failure:(nullable S2TApiFailureCallback)failure;

@end

NS_ASSUME_NONNULL_END
