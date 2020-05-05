//
// Copyright (c) 2020 shibafu
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, S2PictureFormat) {
    S2PicturePNG,
    S2PictureJPEG
};

@interface S2TPicture : NSObject

@property (nonatomic, copy, readonly) NSData *data;
@property (nonatomic, readonly) S2PictureFormat format;

- (instancetype) init __attribute__((unavailable("init is not available")));

- (instancetype) initWithData:(NSData*)data format:(S2PictureFormat)format;

- (NSString*) extension;

- (NSString*) mimeType;

@end

NS_ASSUME_NONNULL_END
