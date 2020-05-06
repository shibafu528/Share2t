//
// Copyright (c) 2020 shibafu
//

#import <Cocoa/Cocoa.h>
#import "S2TMastodonApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddAccountTabViewController : NSTabViewController

@property (nonatomic, readonly) S2TMastodonApp *app;
@property (nonatomic, copy, readonly) NSString *host;

- (void)onRegisteredApp:(S2TMastodonApp*)app host:(NSString*)host;

@end

NS_ASSUME_NONNULL_END
