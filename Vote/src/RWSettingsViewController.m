//
//  RWSettingsViewController.m
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWSettingsViewController.h"

@interface RWSettingsViewController () <NITableViewModelDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;

@property (nonatomic, readwrite, retain) NSArray *data;

@end

@implementation RWSettingsViewController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


        RWNITextInputFormElement *nickElement = [RWNITextInputFormElement textInputElementWithID:0 placeholderText:@"Placeholder" value:@"Initial value"];
        nickElement.title = @"修改游戏昵称";
        
        NSArray* tableContents =
        [NSArray arrayWithObjects:

         @"NITextInputFormElement",
         nickElement,
         @"NISliderFormElement",
         [NISliderFormElement sliderElementWithID:0
                                        labelText:@"Slider"
                                            value:45
                                     minimumValue:0
                                     maximumValue:100],
         
         @"NIDatePickerFormElement",
         [NIDatePickerFormElement datePickerElementWithID:0
                                                labelText:@"Countdown"
                                                     date:[NSDate date]
                                           datePickerMode:UIDatePickerModeCountDownTimer],
         nil];
        
        // We let the Nimbus cell factory create the cells.
//        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
//                                                         delegate:(id)[NICellFactory class]];
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                         delegate:self];
        

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Once the tableView has loaded we attach the model to the data source. As mentioned above,
    // NITableViewModel implements UITableViewDataSource so that you don't have to implement any
    // of the data source methods directly in your controller.
    self.tableView.dataSource = self.model;
    
    // What we're doing here is known as "delegate chaining". It uses the message forwarding
    // functionality of Objective-C to insert the actions object between the table view
    // and this controller. The actions object forwards UITableViewDelegate methods along and
    // selectively intercepts methods required to make user interactions work.
    //
    // Experiment: try commenting out this line. You'll notice that you can no longer tap any of
    // the cells in the table view and that they no longer show the disclosure accessory types.
    // Cool, eh? That this functionality is all provided to you in one line should make you
    // heel-click.
//    self.tableView.delegate = [self.actions forwardingTo:self];

//    self.data = [NSArray arrayWithObjects:[[Tweet alloc] init],[[Tweet alloc] init] ,nil];
//
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.data count];
//}

//- (UITableViewCell *)tableView: (UITableView *)tableView
//         cellForRowAtIndexPath: (NSIndexPath *)indexPath {
//    // Note: You must fetch the object at this index path somehow. The objectAtIndexPath:
//    // is simply an example; replace it with your own implementation.
//    id object = [self.data objectAtIndex:indexPath.row];
//    
//    UITableViewCell* cell = [NICellFactory tableViewModel:nil cellForTableView:tableView atIndexPath:indexPath withObject:object];
//    if (nil == cell) {
//        // Here would be whatever code you were originally using to create cells. nil is only returned
//        // when the factory wasn't able to create a cell, likely due to the NICellObject protocol
//        // not being implemented for the given object. As you implement these protocols on
//        // more objects the factory will automatically start returning the correct cells
//        // and you can start removing this special-case logic.
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//    
//    return cell;
//}

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object {
    
    NSLog(@"%@",object);
    // The model gives us the object, making this much simpler and likely more efficient than the vanilla UIKit implementation.
    return [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}


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
