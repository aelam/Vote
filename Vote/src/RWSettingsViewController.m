//
//  RWSettingsViewController.m
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "NIFormCellCatalog2.h"

@interface RWSettingsViewController () <NITableViewModelDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;

@end

@implementation RWSettingsViewController

@synthesize model = _model;
@synthesize actions = _actions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"游戏设置";
        
        NITextInputFormElement2 *nickElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"昵称" placeholderText:@"Required" value:nil];

        NITextInputFormElement2 *signElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"个性签名" placeholderText:@"Required" value:nil];

        NINumberPickerFormElement *redNumberElement = [NINumberPickerFormElement numberPickerElementWithID:0 labelText:@"红方人数" min:0 max:5 defaultValue:4 didChangeTarget:nil didChangeSelector:nil];

        NINumberPickerFormElement *blueNumberElement = [NINumberPickerFormElement numberPickerElementWithID:0 labelText:@"蓝方人数" min:0 max:5 defaultValue:4 didChangeTarget:nil didChangeSelector:nil];

//        NISwitchFormElement *autoCardElement = [NISwitchFormElement switchElementWithID:0 labelText:@"自动发牌" value:YES];
        
        NSArray* tableContents = [NSArray arrayWithObjects:
                                  nickElement,
                                  signElement,
                                  redNumberElement,
                                  blueNumberElement,
                                  nil];

        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                         delegate:(id)[NICellFactory class]];
        

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Once the tableView has loaded we attach the model to the data source. As mentioned above,
    // NITableViewModel implements UITableViewDataSource so that you don't have to implement any
    // of the data source methods directly in your controller.
    self.tableView.dataSource = self.model;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submitChanges:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    
}

- (void)submitChanges:(id)sender {
    
}

//
//- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
//                   cellForTableView: (UITableView *)tableView
//                        atIndexPath: (NSIndexPath *)indexPath
//                         withObject: (id)object {
//    
//    NSLog(@"%@",object);
//    // The model gives us the object, making this much simpler and likely more efficient than the vanilla UIKit implementation.
//    return [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
//}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // This is a core Nimbus method that simplifies the logic required to display a controller on
    // both the iPad (where all orientations are supported) and the iPhone (where anything but
    // upside-down is supported). This method will be deprecated in iOS 6.0.
    return NIIsSupportedOrientation(toInterfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
