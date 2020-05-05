//
// Copyright (c) 2020 shibafu
//

#import "ShareViewController.h"
#import "S2TPicture.h"
#import "NSString+S2TExtension.h"

@interface ShareViewController () <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *bodyInput;
@property (nonatomic, weak) IBOutlet NSTextField *counter;
@property (nonatomic, weak) IBOutlet NSTextField *picturesCounter;

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
                    [itemProvider loadItemForTypeIdentifier:(NSString*)kUTTypeImage
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
    NSExtensionItem *outputItem = [[NSExtensionItem alloc] init];
    // Complete implementation by setting the appropriate value on the output item
    
    NSArray *outputItems = @[outputItem];
    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
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
}

@end

