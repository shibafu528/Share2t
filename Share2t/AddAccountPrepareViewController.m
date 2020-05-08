//
// Copyright (c) 2020 shibafu
//

#import "AddAccountPrepareViewController.h"
#import "AddAccountTabViewController.h"
#import "S2TApiClient.h"

@interface AddAccountPrepareViewController () <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *input;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressBar;
@property (nonatomic, weak) IBOutlet NSTextField *progressText;
@property (nonatomic, weak) IBOutlet NSButton *confirmButton;
@property (nonatomic, weak) IBOutlet NSButton *cancelButton;

@end

@implementation AddAccountPrepareViewController

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
    
    S2TApiClient *client = [[S2TApiClient alloc] initWithHost:self.input.stringValue];
    [client createApp:@"Share2t" redirectTo:S2TDefaultRedirectTo scopes:@"read write" website:nil
              success:^(NSURLSessionDataTask * _Nonnull task, S2TMastodonApp * _Nonnull app) {
        NSURL *url = [client authorizeURL:app.clientId redirectTo:S2TDefaultRedirectTo scopes:@"read write"];
        NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
        [[NSWorkspace sharedWorkspace] openURL:url configuration:config completionHandler:^(NSRunningApplication * _Nullable _app, NSError * _Nullable error) {
            if (error) {
                [[NSAlert alertWithError:error] runModal];
                [self.view.window close];
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [(AddAccountTabViewController*) self.parentViewController onRegisteredApp:app
                                                                                     host:client.host];
            });
        }];
    }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", body);
        
        [[NSAlert alertWithError:error] beginSheetModalForWindow:self.view.window completionHandler:nil];
        
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
