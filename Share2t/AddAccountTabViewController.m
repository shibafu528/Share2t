//
// Copyright (c) 2020 shibafu
//

#import "AddAccountTabViewController.h"

@interface AddAccountTabViewController ()

@property (nonatomic, readwrite) S2TMastodonApp *app;
@property (nonatomic, copy, readwrite) NSString *host;

@end

@implementation AddAccountTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)onRegisteredApp:(S2TMastodonApp*)app host:(NSString*)host {
    self.app = app;
    self.host = host;
    self.selectedTabViewItemIndex = 1;
}

@end
