//
//  RWCreateGameViewController.m
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWCreateGameViewController.h"

#import <NimbusModels/NimbusModels.h>
#import "NIFormCellCatalog2.h"

@interface RWCreateGameViewController () <NITableViewModelDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;

@end

@implementation RWCreateGameViewController

@synthesize model = _model;
@synthesize actions = _actions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"游戏设置";

        
        _actions = [[NITableViewActions alloc] initWithTarget:self];


        NITextInputFormElement2 *setRedNameElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"设置红方暗号" placeholderText:@"随机生成" value:nil];

        NITextInputFormElement2 *setBlackNameElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"设置蓝方暗号" placeholderText:@"随机生成" value:nil];
        
        
        NSArray* sectionedObjects =
        [NSArray arrayWithObjects:
         setRedNameElement,
         setBlackNameElement,
         [_actions attachToObject:[NITitleCellObject objectWithTitle:@"分享游戏"] detailBlock:^BOOL(id object, id target) {
            
            NSLog(@"%s",__func__);
            return YES;

        }],
         
         
         nil];

        
//
//
        
//        
//        NSArray* tableContents = [NSArray arrayWithObjects:
//                                  setRedNameElement,
//                                  setBlackNameElement,
//                                  nil];
    
        
        
//        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
//                                                         delegate:[NICellFactory class]];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:sectionedObjects
                                                         delegate:(id)[NICellFactory class]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self.model;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
