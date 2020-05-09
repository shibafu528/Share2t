//
// Copyright (c) 2020 shibafu
//

#import "ViewController.h"
#import "S2TUtils.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic) NSArray<NSDictionary*> *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = S2TDefaults();
    self.data = [defaults arrayForKey:@"Accounts"] ?: @[];
    // TODO: なんか動かん、しかしNotificationだと頻度高すぎるのでobserver使いたい…
    // [defaults addObserver:self forKeyPath:@"Accounts" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.data.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    view.textField.stringValue = [NSString stringWithFormat:@"%@@%@",
                                  self.data[row][@"acct"], self.data[row][@"domain"]];
    return view;
}

- (IBAction)segmentedControlSelected:(NSSegmentedControl*)sender {
    if (sender.selectedSegment == 0) {
        // Add account
        [self performSegueWithIdentifier:@"AddAccount" sender:sender];
    } else {
        // Delete account
        NSInteger selectedRow = self.tableView.selectedRow;
        if (selectedRow == -1) {
            return;
        }

        NSDictionary *account = self.data[selectedRow];
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        alert.messageText = [NSString stringWithFormat:@"アカウント %@@%@ を削除してもよろしいですか？",
                             account[@"acct"], account[@"domain"]];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"キャンセル"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                return;
            }
            
            NSMutableArray *newAccounts = [self.data mutableCopy];
            [newAccounts removeObjectAtIndex:selectedRow];
            
            NSUserDefaults *defaults = S2TDefaults();
            [defaults setValue:newAccounts forKey:@"Accounts"];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"Accounts"]) {
        self.data = [object arrayForKey:@"Accounts"] ?: @[];
        [self.tableView reloadData];
    }
}

- (void)defaultsDidChange:(NSNotification*)notification {
    self.data = [S2TDefaults() arrayForKey:@"Accounts"] ?: @[];
    [self.tableView reloadData];
}

@end
