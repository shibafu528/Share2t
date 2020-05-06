//
// Copyright (c) 2020 shibafu
//

#import "AddAccountLoginViewController.h"
#import "AddAccountTabViewController.h"
#import "S2TApiClient.h"

@interface AddAccountLoginViewController () <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *input;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressBar;
@property (nonatomic, weak) IBOutlet NSTextField *progressText;
@property (nonatomic, weak) IBOutlet NSButton *confirmButton;
@property (nonatomic, weak) IBOutlet NSButton *cancelButton;

@end

@implementation AddAccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.input.delegate = self;
}

- (IBAction)confirm:(id)sender {
    self.input.enabled = false;
    self.progressBar.hidden = false;
    self.progressText.hidden = false;
    self.confirmButton.enabled = false;
    [self.progressBar startAnimation:nil];
    
    AddAccountTabViewController *parent = (AddAccountTabViewController*) self.parentViewController;
    S2TApiClient *client = [[S2TApiClient alloc] initWithHost:parent.host];
    [client obtainAccessToken:parent.app.clientId
                 clientSecret:parent.app.clientSecret
                   redirectTo:S2TDefaultRedirectTo
                       scopes:@"read write"
                         code:self.input.stringValue
                    grantType:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, S2TMastodonAccessToken * _Nonnull accessToken) {
        NSLog(@"%@", accessToken);
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = @"認証に成功しました!";
        [alert runModal];
        
        [self.view.window close];
    }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", body);
        
        [[NSAlert alertWithError:error] runModal];
        
        self.input.enabled = true;
        self.progressBar.hidden = true;
        self.progressText.hidden = true;
        self.confirmButton.enabled = true;
    }];
}

- (IBAction)cancel:(id)sender {
    [self.view.window close];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    self.confirmButton.enabled = self.input.stringValue.length != 0;
}

@end
