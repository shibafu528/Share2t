//
// Copyright (c) 2020 shibafu
//

#import "ViewController.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic) NSArray<NSDictionary*> *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:@"Accounts" options:NSKeyValueObservingOptionNew context:nil];
    self.data = [defaults arrayForKey:@"Accounts"] ?: @[];
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
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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

@end
