//
// Copyright (c) 2020 shibafu
//

#import "ViewController.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic) NSArray<NSString*> *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.data = @[@"Nono", @"Syoko", @"Mirei"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:@"Accounts" options:NSKeyValueObservingOptionNew context:nil];
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
    view.textField.stringValue = self.data[row];
    return view;
}

- (IBAction)segmentedControlSelected:(NSSegmentedControl*)sender {
    if (sender.selectedSegment == 0) {
        // Add account
        [self performSegueWithIdentifier:@"AddAccount" sender:sender];
    } else {
        // Delete account
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"Accounts"]) {
        NSLog(@"object = %@", object);
        NSLog(@"change = %@", change);
    }
}

@end
