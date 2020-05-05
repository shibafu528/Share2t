//
// Copyright (c) 2020 shibafu
//

#import "S2TPicture.h"

@interface S2TPicture ()

@end

@implementation S2TPicture

- (instancetype)initWithData:(nonnull NSData *)data format:(S2PictureFormat)format {
    if (self = [super init]) {
        _data = data;
        _format = format;
    }
    return self;
}

- (NSString*)extension {
    switch (self.format) {
        case S2PicturePNG:
            return @".png";
        case S2PictureJPEG:
            return @".jpg";
    }
    return @"";
}

- (NSString*)mimeType {
    switch (self.format) {
        case S2PicturePNG:
            return @"image/png";
        case S2PictureJPEG:
            return @"image/jpeg";
    }
    return @"application/octet-stream";
}

@end
