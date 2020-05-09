//
// Copyright (c) 2020 shibafu
//

#import "ShareViewController.h"
#import "NSString+S2TExtension.h"
#import "S2TApiClient.h"
#import "S2TPicture.h"
#import "S2TUtils.h"

@interface ShareViewController () <NSTextFieldDelegate, NSMenuDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *bodyInput;
@property (nonatomic, weak) IBOutlet NSTextField *counter;
@property (nonatomic, weak) IBOutlet NSTextField *picturesCounter;
@property (nonatomic, weak) IBOutlet NSMenu *accountMenu;
@property (nonatomic, weak) IBOutlet NSPopUpButton *accountPopUp;
@property (nonatomic, weak) IBOutlet NSButton *sendButton;

@property (nonatomic) NSArray<NSDictionary*> *accounts;
@property (nonatomic) NSMutableArray<S2TPicture*> *pictures;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.pictures = [NSMutableArray array];
    }
    return self;
}

- (NSString *)nibName {
    return @"ShareViewController";
}

- (void)loadView {
    [super loadView];
    
    // Insert code here to customize the view
    NSUserDefaults *defaults = S2TDefaults();
    self.accounts = [defaults arrayForKey:@"Accounts"] ?: @[];
    [self.accountMenu removeAllItems];
    if (self.accounts.count == 0) {
        [self.accountMenu addItemWithTitle:@"アカウントが登録されていません" action:nil keyEquivalent:@""];
        self.sendButton.enabled = false;
        // TODO: エラー処理
//        NSAlert *alert = [[NSAlert alloc] init];
//        alert.alertStyle = NSAlertStyleWarning;
//        alert.messageText = @"Mastodonアカウントが登録されていません。共有で使う前に、Share2tアプリを起動して設定を行ってください。";
    } else {
        for (NSDictionary *account in self.accounts) {
            NSString *fullAcct = [NSString stringWithFormat:@"%@@%@", account[@"acct"], account[@"domain"]];
            [self.accountMenu addItemWithTitle:fullAcct action:nil keyEquivalent:@""];
        }
    }
    
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSLog(@"Attachments = %@", item.attachments);

    NSDictionary *handlers = @{
        (NSString*)kUTTypeImage: NSStringFromSelector(@selector(processImage:withError:)),
        (NSString*)kUTTypeURL: NSStringFromSelector(@selector(processURL:withError:)),
    };
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        if (item.attachments == nil) {
            continue;
        }
        for (NSItemProvider *itemProvider in item.attachments) {
            NSLog(@"Item = %@", itemProvider);

            for (NSString *type in [handlers keyEnumerator]) {
                if ([itemProvider hasItemConformingToTypeIdentifier:type]) {
                    [itemProvider loadItemForTypeIdentifier:type
                                                    options:nil
                                          completionHandler:^(id item, NSError *error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [self performSelector:NSSelectorFromString(handlers[type]) withObject:item withObject:error];
#pragma clang diagnostic pop
                    }];
                }
            }
        }
    }
    
    self.bodyInput.delegate = self;
}

- (void)processImage:(id)item withError:(NSError*)error {
    if (error != nil) {
        [self.extensionContext cancelRequestWithError:error];
        return;
    }
    NSLog(@"processImage:WithError: item = (%@) %@", [item className], item);
    if ([item isKindOfClass:NSData.class]) {
        NSData *data = (NSData*) item;
        S2TPicture *picture = [[S2TPicture alloc] initWithData:data format:S2PicturePNG];
        [self.pictures addObject:picture];
    } else if ([item isKindOfClass:NSURL.class]) {
        NSURL *url = (NSURL*) item;
        NSData *data;
        if ([url isFileURL]) {
            NSError *e2 = nil;
            data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&e2];
            if (e2) {
                NSLog(@"%@", [e2 localizedDescription]);
            } else {
                NSString *extension = (url.pathExtension ?: @"").lowercaseString;
                S2PictureFormat format = [extension isEqualToString:@"png"] ? S2PicturePNG : S2PictureJPEG;
                S2TPicture *picture = [[S2TPicture alloc] initWithData:data format:format];
                [self.pictures addObject:picture];
            }
        }
    }
    [self updatePicturesCounter];
}

- (void)processURL:(id)item withError:(NSError*)error {
    if (error != nil) {
        [self.extensionContext cancelRequestWithError:error];
        return;
    }
    NSLog(@"processURL:WithError: item = (%@) %@", [item className], item);
    if ([item isKindOfClass:NSURL.class]) {
        NSURL *url = (NSURL*) item;
        if ([url.scheme isEqualToString:@"file"]) {
            return;
        }

        if (url.absoluteString) {
            self.bodyInput.stringValue = [@" " stringByAppendingString:url.absoluteString];
            self.bodyInput.currentEditor.selectedRange = NSMakeRange(0, 0);
        }
    }
    [self updateContentCounter];
}

- (void)updateContentCounter {
    self.counter.stringValue = @(500 - self.bodyInput.stringValue.characterCount).stringValue;
}

- (void)updatePicturesCounter {
    if (self.pictures.count == 0) {
        self.picturesCounter.hidden = true;
    } else {
        self.picturesCounter.hidden = false;
        // TODO: use stringsdict
        // https://qiita.com/mono0926/items/647f6d741cd9965d9806
        if (self.pictures.count == 1) {
            self.picturesCounter.stringValue = [NSString stringWithFormat:@"With %lu picture", self.pictures.count];
        } else {
            self.picturesCounter.stringValue = [NSString stringWithFormat:@"With %lu pictures", self.pictures.count];
        }
    }
}

- (IBAction)send:(id)sender {
    NSInteger selectedAccountIndex = self.accountPopUp.indexOfSelectedItem;
    if (selectedAccountIndex == -1) {
        return;
    }
    NSDictionary *account = self.accounts[selectedAccountIndex];
    S2TApiClient *client = [[S2TApiClient alloc] initWithHost:account[@"domain"]
                                                  accessToken:account[@"accessToken"]];

    __block NSMutableArray<NSNumber*> *mediaIds = [NSMutableArray array];
    __block BOOL cancelPost = NO;
    __auto_type postBlock = ^{
        if (cancelPost) {
            return;
        }

        // TODO: visibility
        [client postStatus:self.bodyInput.stringValue
                  mediaIds:mediaIds
                 sensitive:NO
               spoilerText:nil
                visibility:S2TStatusPublic
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Success postStatus: %@", responseObject);
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            NSLog(@"Error postStatus: %@", error);
        }];
    };

    if (self.pictures.count != 0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_group_t uploadGroup = dispatch_group_create();

        for (S2TPicture *picture in self.pictures) {
            dispatch_group_async(uploadGroup, queue, ^{
                NSLog(@"Begin postMedia:(%@)", picture);
                dispatch_semaphore_t sp = dispatch_semaphore_create(0);
                [client postMedia:picture description:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, NSNumber * _Nonnull mediaId) {
                    NSLog(@"Success postMedia:(%@) %@", picture, mediaId);
                    [mediaIds addObject:mediaId];
                    dispatch_semaphore_signal(sp);
                }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    NSLog(@"Error postMedia:(%@) %@", picture, error);
                    cancelPost = YES;
                    dispatch_semaphore_signal(sp);
                }];
                dispatch_semaphore_wait(sp, DISPATCH_TIME_FOREVER);
            });
        }

        dispatch_group_notify(uploadGroup, queue, postBlock);
    } else {
        postBlock();
    }
}

- (IBAction)cancel:(id)sender {
    NSError *cancelError = [NSError errorWithDomain:NSCocoaErrorDomain
                                               code:NSUserCancelledError
                                           userInfo:nil];
    [self.extensionContext cancelRequestWithError:cancelError];
}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    if (commandSelector == @selector(insertNewline:))
    {
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    return result;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self updateContentCounter];
    self.sendButton.enabled = self.accounts.count != 0 && self.bodyInput.stringValue.characterCount != 0;
}

@end

