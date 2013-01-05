//
//  RWMainViewController.m
//  Vote
//
//  Created by Ryan Wang on 12-12-29.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWMainViewController.h"

#import "NimbusModels.h"
#import "RWCreateGameViewController.h"

@interface RWMainViewController ()<NITableViewModelDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;

@end

@implementation RWMainViewController

@synthesize model = _model;
@synthesize actions = _actions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"游戏";
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        
        
        NSArray* sectionedObjects =
        [NSArray arrayWithObjects:
         // An NSString in a sectioned array denotes the start of a new section. It's also the label of
         // the section header.
//         @"Attributed Label",
         
         [_actions attachToObject:
          [NITitleCellObject objectWithTitle:@"创建游戏"]
                  navigationBlock:
          NIPushControllerAction([RWCreateGameViewController class])],

         [_actions attachToObject:
          [NITitleCellObject objectWithTitle:@"分享游戏"]
                  navigationBlock:
          NIPushControllerAction([RWCreateGameViewController class])],
         
         
         nil];

    
//        NSArray* tableContents = [NSArray arrayWithObjects:
//                                  [NSDictionary dictionaryWithObject:@"创建游戏" forKey:@"title"],
//                                  [NSDictionary dictionaryWithObject:@"分享游戏" forKey:@"title"],
//                                  [NSDictionary dictionaryWithObject:@"查看本局游戏" forKey:@"title"],
//                                  [NSDictionary dictionaryWithObject:@"查看本局游戏" forKey:@"title"],
//                                  [NSDictionary dictionaryWithObject:@"启动微信" forKey:@"title"],
//                                  nil];
        
//        _model = [[NITableViewModel alloc] initWithSectionedArray:sectionedObjects
//                                                         delegate:self];
        _model = [[NITableViewModel alloc] initWithSectionedArray:sectionedObjects
                                                         delegate:(id)[NICellFactory class]];
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self.model;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.delegate = [self.actions forwardingTo:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object {
    // A pretty standard implementation of creating table view cells follows.
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"row"];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: @"row"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [object objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the stock UIKit didSelectRow method, provided here simply as an example of
    // fetching an object from the model.
    
    id object = [_model objectAtIndexPath:indexPath];
}


@end
