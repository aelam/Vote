//
//  RWCreateGameViewController.m
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWCreateGameViewController.h"

#import "NimbusModels.h"
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
        
        NINumberPickerFormElement *redNumberElement = [NINumberPickerFormElement numberPickerElementWithID:0 labelText:@"红方人数" min:0 max:5 defaultValue:4 didChangeTarget:nil didChangeSelector:nil];
        
        NINumberPickerFormElement *blueNumberElement = [NINumberPickerFormElement numberPickerElementWithID:0 labelText:@"蓝方人数" min:0 max:5 defaultValue:4 didChangeTarget:nil didChangeSelector:nil];
        
        NISwitchFormElement *autoCardElement = [NISwitchFormElement switchElementWithID:0 labelText:@"自动发牌" value:YES];

        
        NSArray* sectionedObjects =
        [NSArray arrayWithObjects:
         setRedNameElement,
         setBlackNameElement,
         redNumberElement,
         blueNumberElement,
         autoCardElement,
         [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Explicit tap handler"]
                             tapBlock:
          ^BOOL(id object, id target) {
              NSLog(@"Object was tapped with an explicit action: %@", object);
              return YES;
          }],
         nil
         ];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:sectionedObjects
                                                         delegate:(id)[NICellFactory class]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
