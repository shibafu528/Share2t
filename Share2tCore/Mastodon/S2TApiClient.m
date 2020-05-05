//
// Copyright (c) 2020 shibafu
//

#import "S2TApiClient.h"

@interface S2TApiClient ()

@property (nonatomic, copy, readonly) NSString *accessToken;

@end

@implementation S2TApiClient

- (nonnull instancetype)initWithHost:(nonnull NSString *)host {
    return [self initWithHost:host accessToken:nil];
}

- (nonnull instancetype)initWithHost:(nonnull NSString *)host
                         accessToken:(nullable NSString *)accessToken {
    if (self = [super init]) {
        _host = host;
        _accessToken = accessToken;
        
        NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/", host]];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    }
    return self;
}

- (nonnull NSDictionary *)defaultHeaders { 
    return @{
        @"Authorization": [NSString stringWithFormat:@"Bearer %@", self.accessToken]
    };
}

@end
