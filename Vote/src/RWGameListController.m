//
//  RWGameListController.m
//  Vote
//
//  Created by Ryan Wang on 13-1-14.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWGameListController.h"
#import "NimbusModels.h"
#import "NITableViewModel.h"
#import "NIMutableTableViewModel.h"
#import "RWUser.h"
#import "RWGameInfoController.h"


@interface RWGameListController ()<NITableViewModelDelegate,UITextFieldDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) RWGameInfoController* gameInfoController;



@end

@implementation RWGameListController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize gameInfoController = _gameInfoController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

        self.title = NSLocalizedString(@"gameList", @"gameList");
        
        self.tabBarItem.image = [UIImage imageNamed:@"document"];
        self.tabBarItem.title = NSLocalizedString(@"gameList", @"gameList");
        
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];
  
        
        NSArray *tableContents = [NSArray arrayWithObjects:
                                  [self.actions attachToObject: [NISubtitleCellObject objectWithTitle:@"最近游戏ID" subtitle:[RWUser currentUser].lastGameId] navigationBlock:^BOOL(id object, id target) {
            NSLog(@"fsfds");
            
            NSString *lastGameId = [RWUser currentUser].lastGameId;
            if (lastGameId.length == 0 ) {
                return NO;
            }
            
            self.gameInfoController = [[RWGameInfoController alloc] initWithGameID:lastGameId infoType:RWGameInfoTypeView];
            
            [self.navigationController pushViewController:self.gameInfoController animated:YES];
                                            return YES;
                                }],
                                  [NITableViewModelFooter footerWithTitle:@"只有创建者才能查看"],
                                  nil
                                  ];
        
        self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                             delegate:self];//(id)[NICellFactory class]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTableView)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"row"];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                       reuseIdentifier: @"row"]
                ;
    }
    NSLog(@"%@",[RWUser currentUser].lastGameId);
    cell.textLabel.text = [object valueForKey:@"title"];
    cell.detailTextLabel.text = [RWUser currentUser].lastGameId;//[object valueForKey:@"sub"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)didTapTableView {
    [self.view endEditing:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // This is a core Nimbus method that simplifies the logic required to display a controller on
    // both the iPad (where all orientations are supported) and the iPhone (where anything but
    // upside-down is supported). This method will be deprecated in iOS 6.0.
    return NIIsSupportedOrientation(toInterfaceOrientation);
}


@end
