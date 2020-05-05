//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient+Statuses.h"

@implementation S2TApiClient (Statuses)

- (NSURLSessionDataTask*)postStatus:(nonnull NSString *)status
                           mediaIds:(nullable NSArray<NSNumber *> *)mediaIds
                          sensitive:(BOOL)sensitive
                        spoilerText:(nullable NSString *)spoilerText
                         visibility:(S2TStatusVisibility)visibility
                            success:(nullable S2TApiSuccessCallback)success
                            failure:(nullable S2TApiFailureCallback)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = status;
    if (mediaIds) {
        params[@"media_ids"] = mediaIds;
    }
    params[@"sensitive"] = @(sensitive);
    if (spoilerText && spoilerText.length != 0) {
        params[@"spoiler_text"] = spoilerText;
    }
    params[@"visibility"] = NSStringFromStatusVisibility(visibility);
    
    AFHTTPSessionManager *manager = self.manager;
    return [manager POST:@"/api/v1/statuses"
              parameters:params
                 headers:self.defaultHeaders
                progress:nil
                 success:success
                 failure:failure];
}

@end
