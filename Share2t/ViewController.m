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

@end
