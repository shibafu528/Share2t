//
// Copyright (c) 2020 shibafu
//

#import "S2TPicture.h"

@interface S2TPicture ()

@property (nonatomic, copy) NSData *data;
@property (nonatomic) S2PictureFormat format;

@end

@implementation S2TPicture

- (instancetype)initWithData:(nonnull NSData *)data format:(S2PictureFormat)format {
    if (self = [super init]) {
        self.data = data;
        self.format = format;
    }
    return self;
}

@end
