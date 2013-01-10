//
//  RWGameInfoController.m
//  Vote
//
//  Created by Ryan Wang on 13-1-8.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWGameInfoController.h"
#import "NimbusModels.h"
#import "NIMutableTableViewModel.h"
#import "NITableViewModel+Private.h"
#import "NIFormCellCatalog2.h"
#import "RWAPI.h"
#import "RWUser.h"

@interface RWGameInfoController () <NIMutableTableViewModelDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NSDictionary *gameInfo;

@end

@implementation RWGameInfoController

@synthesize model = _model;
@synthesize actions = _actions;

@synthesize gameID = _gameID;
@synthesize gameInfo = _gameInfo;

- (id)initWithGameID:(NSString *)anID {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = NSLocalizedString(@"gameInfo", @"游戏信息");
        
        self.gameID = anID;
        
        [RWAPI joinGameWithID:self.gameID username:[RWUser currentUser].nickname success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self loadModelsFromJson:JSON];
            if (self.isViewLoaded) {
                self.tableView.dataSource = self.model;
                self.tableView.delegate = [self.actions forwardingTo:self];
                [self.tableView reloadData];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error :%@",error);
        }];

        
    }
    return self;
    
}

- (void)loadModelsFromJson:(NSDictionary *)json {

    
    self.actions = [[NITableViewActions alloc] initWithTarget:self];

    NSMutableArray *cellObjects = [NSMutableArray array];
    
    
    if ([[json valueForKeyPath:@"success"] integerValue] == 0) {
        NSString *resultMsg = [json valueForKeyPath:@"resultMsg"];
        
        cellObjects = [NSMutableArray arrayWithObjects:
                       [NITitleCellObject objectWithTitle:resultMsg],
                       nil];
        
        self.model = [[NITableViewModel alloc] initWithSectionedArray:cellObjects delegate:(id)[NICellFactory class]];
        return;
    }
    
    NSString *gameID = SAFE_STRING([json valueForKeyPath:@"_object.id"]);
    NISubtitleCellObject *gameIDCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"gameId",@"游戏ID") subtitle:gameID];
    gameIDCellObject.cellStyle = UITableViewCellStyleValue1;

    NSString *goodCount = SAFE_STRING([json valueForKeyPath:@"_object.goodCount"]);
    NISubtitleCellObject *redCountCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"redNumber",@"红方人数") subtitle:goodCount];
    redCountCellObject.cellStyle = UITableViewCellStyleValue1;
    
    NSString *badCount = SAFE_STRING([json valueForKeyPath:@"_object.badCount"]);
    NISubtitleCellObject *blueCountCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"blueNumber",@"蓝方人数") subtitle:badCount];
    blueCountCellObject.cellStyle = UITableViewCellStyleValue1;

    NSString *operator = SAFE_STRING([json valueForKeyPath:@"_object.operator"]);
    if ([operator isEqualToString:[RWUser currentUser].nickname]) {
        // 我是裁判
        NSString *goodWord = SAFE_STRING([json valueForKeyPath:@"_object.goodWord"]);
        NISubtitleCellObject *goodWordCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"redCodeWord",@"红方人物代号") subtitle:goodWord];
        goodWordCellObject.cellStyle = UITableViewCellStyleValue1;

        NSString *badWord = SAFE_STRING([json valueForKeyPath:@"_object.badWord"]);
        NISubtitleCellObject *badWordCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"blueCodeWord",@"蓝方人物代号") subtitle:badWord];
        badWordCellObject.cellStyle = UITableViewCellStyleValue1;

        
        NISubtitleCellObject *operatorCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"owner",@"创建人") subtitle:operator];
        operatorCellObject.cellStyle = UITableViewCellStyleValue1;

        cellObjects = [NSMutableArray arrayWithObjects:
                       gameIDCellObject,
                       redCountCellObject,
                       blueCountCellObject,
                       operatorCellObject,
                       @"",
                       goodWordCellObject,
                       badWordCellObject,
                       @"",                       
                       [self.actions attachToObject:[NITitleCellObject objectWithTitle:NSLocalizedString(@"recreateGame",@"重新创建游戏")] tapBlock:^BOOL(id object, id target) {
            
            [self backAction:nil];
            return YES;
        }],
                       nil];
        
        self.model = [[NITableViewModel alloc] initWithSectionedArray:cellObjects delegate:(id)[NICellFactory class]];

    } else {
        
        NSString *voteWord = SAFE_STRING([json valueForKeyPath:@"voteWord"]);
        NISubtitleCellObject *voteWordCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"myCodeWord",@"我的暗号") subtitle:voteWord];
        voteWordCellObject.cellStyle = UITableViewCellStyleValue1;
        

        NSString *name = SAFE_STRING([json valueForKeyPath:@"_object.name"]);
        NISubtitleCellObject *nameCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"myCodeWord",@"我的人物代号") subtitle:name];
        nameCellObject.cellStyle = UITableViewCellStyleValue1;


        NISubtitleCellObject *operatorCellObject = [NISubtitleCellObject objectWithTitle:NSLocalizedString(@"owner",@"创建人") subtitle:operator];
        operatorCellObject.cellStyle = UITableViewCellStyleValue1;

        cellObjects = [NSMutableArray arrayWithObjects:
                       gameIDCellObject,
                       voteWordCellObject,
                       redCountCellObject,
                       blueCountCellObject,
                       operatorCellObject,
                       @"",
                       nameCellObject,
                       @"",
                       [self.actions attachToObject:[NITitleCellObject objectWithTitle:NSLocalizedString(@"recreateGame",@"重新创建游戏")] tapBlock:^BOOL(id object, id target) {
            
            [self backAction:nil];
            return YES;
        }],
                       nil];

        self.model = [[NITableViewModel alloc] initWithSectionedArray:cellObjects delegate:(id)[NICellFactory class]];

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self.tableView reloadData];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTableView)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back",@"返回") style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didTapTableView {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

