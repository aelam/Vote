//
//  RWCreateGameViewController.m
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWCreateGameViewController.h"

#import "NimbusModels.h"
#import "NIMutableTableViewModel.h"
#import "NITableViewModel+Private.h"
#import "NIFormCellCatalog2.h"
#import "RWGameSettings.h"
#import "RWUser.h"
#import "AFHTTPClient+Singleton.h"
#import "WXApi+EasyWrap.h"

static NSInteger const kRedElementTag   = 1001;
static NSInteger const kBlueElementTag  = 1003;


@interface RWCreateGameViewController () <NITableViewModelDelegate,UITextFieldDelegate>

@property (nonatomic, readwrite, retain) NIMutableTableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
@property (nonatomic, readwrite, retain) NINumberPickerFormElement* redNumberElement;
@property (nonatomic, readwrite, retain) NINumberPickerFormElement* blueNumberElement;
@property (nonatomic, readwrite, retain) NISwitchFormElement *autoCardElement;
@property (nonatomic, readwrite, retain) NITextInputFormElement2 *redCodeElement;
@property (nonatomic, readwrite, retain) NITextInputFormElement2 *blueCodeElement;

@end

@implementation RWCreateGameViewController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize redNumberElement = _redNumberElement;
@synthesize blueNumberElement = _blueNumberElement;
@synthesize autoCardElement = _autoCardElement;
@synthesize redCodeElement = _redCodeElement;
@synthesize blueCodeElement = _blueCodeElement;

- (id)initWithStyle:(UITableViewStyle)style {
    // We explicitly set the table view style in this controller's implementation because we want this
    // controller to control how the table view is displayed.
    self = [super initWithStyle:UITableViewStyleGrouped];
    {
        self.title = @"游戏设置";

        _actions = [[NITableViewActions alloc] initWithTarget:self];
        
        BOOL isAutoDeal = [RWGameSettings defaultSettings].autoDeal;
        
        
        self.redNumberElement = [NINumberPickerFormElement numberPickerElementWithID:kRedElementTag labelText:@"红方人数" min:0 max:10 defaultValue:[RWGameSettings defaultSettings].redRoleCount didChangeTarget:self didChangeSelector:@selector(numberPickerValueChanged:)];
        
        self.blueNumberElement = [NINumberPickerFormElement numberPickerElementWithID:kBlueElementTag labelText:@"蓝方人数" min:0 max:10 defaultValue:[RWGameSettings defaultSettings].blueRoleCount didChangeTarget:self didChangeSelector:@selector(numberPickerValueChanged:)];
        
        self.autoCardElement = [NISwitchFormElement switchElementWithID:0 labelText:@"自动发牌" value:isAutoDeal didChangeTarget:self didChangeSelector:@selector(switchAction:)];

        NSMutableArray* sectionedObjects =
        [NSMutableArray arrayWithObjects:
         [self.actions attachToObject:_redNumberElement
                             tapBlock:
          ^BOOL(id object, id target) {
              
              NSLog(@"Object was tapped with an explicit action: %@ target : %@", object,target);
              return YES;
          }],
         _blueNumberElement,
//         [self.actions attachToObject:_blueNumberElement
//                             tapBlock:
//          ^BOOL(id object, id target) {
//              
//              NSLog(@"Object was tapped with an explicit action: %@ target : %@", object,target);
//              return YES;
//          }],
         @"",
         _autoCardElement,
         @"",
         [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"创建游戏"]
                             tapBlock:
          ^BOOL(id object, id target) {
              
              [self createGame:nil];
              return YES;
          }],
         nil
         ];
        
        if (isAutoDeal == NO) {
            NSInteger index = [sectionedObjects indexOfObject:_autoCardElement];
            [sectionedObjects insertObject:self.blueCodeElement atIndex:index+1];
            [sectionedObjects insertObject:self.redCodeElement atIndex:index+1];
            
        }
        
        
        
        _model = [[NIMutableTableViewModel alloc] initWithSectionedArray:sectionedObjects
                                                         delegate:(id)[NICellFactory class]];

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

- (void)numberPickerValueChanged:(UIPickerView *)picker {
    if (picker.tag == kRedElementTag) {
        [RWGameSettings defaultSettings].redRoleCount = self.redNumberElement.selectedValue;
        [[RWGameSettings defaultSettings] save];
    } else if (picker.tag == kBlueElementTag) {
        [RWGameSettings defaultSettings].blueRoleCount = self.blueNumberElement.selectedValue;
        [[RWGameSettings defaultSettings] save];
    }
}

- (void)switchAction:(UISwitch *)switch0 {
    [RWGameSettings defaultSettings].autoDeal = switch0.on;
    [[RWGameSettings defaultSettings] save];
    
    if (switch0.on == NO) {        

        NITableViewModelSection *section = [[self.model sections] objectAtIndex:1];
        if ([section.rows count] > 1) {
            return;
        }
        
        NSArray *cell0 = [self.model insertObject:self.redCodeElement atRow:1 inSection:1];
        NSArray *cell1 = [self.model insertObject:self.blueCodeElement atRow:2 inSection:1];
        NSArray *cells = [NSArray arrayWithObjects:[cell0 lastObject],[cell1 lastObject],nil];
        
        [self.model updateSectionIndex];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];

    } else {

        NITableViewModelSection *section = [[self.model sections] objectAtIndex:1];
        if ([section.rows count] <= 1) {
            return;
        }

        NSArray *cell0 = [self.model removeObjectAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        NSArray *cell1 = [self.model removeObjectAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        NSArray *cells = [NSArray arrayWithObjects:[cell0 lastObject],[cell1 lastObject],nil];
        
        [self.model updateSectionIndex];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];

    }
    
}

- (void)createGame:(id)sender {
    NSLog(@"redNumberElement.selectedValue = %d",self.redNumberElement.selectedValue);
    NSLog(@"blueCodeElement.selectedValue = %d",self.blueNumberElement.selectedValue);
    
    NSString *nickname = [RWUser currentUser].nickname;
    if (nickname.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置里面设置昵称" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *mood = [RWUser currentUser].mood;
    if (mood.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置里面设置个性签名" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
  
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

    BOOL isAutoDeal = self.autoCardElement.value;
    if (isAutoDeal) {
        [params setObject:@"auto" forKey:@"type"];
    } else {
        if (self.redCodeElement.value.length == 0 || self.blueCodeElement.value.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暗号不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [params setObject:[NSString stringWithFormat:@"%@",self.redCodeElement.value] forKey:@"goodWord"];
        [params setObject:[NSString stringWithFormat:@"%@",self.blueCodeElement.value] forKey:@"badWord"];
        [params setObject:@"notAuto" forKey:@"type"];
    }
    
    [params setObject:nickname forKey:@"operator"];
    [params setObject:kAccessToken forKey:@"ak"];
    [params setObject:mood forKey:@"name"];
    [params setObject:[NSString stringWithFormat:@"%d",self.redNumberElement.selectedValue] forKey:@"goodCount"];
    [params setObject:[NSString stringWithFormat:@"%d",self.blueNumberElement.selectedValue] forKey:@"badCount"];
    
    NSLog(@"%@",params);
    
    AFHTTPClient *client = [AFHTTPClient sharedHTTPClient];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kCreateGamePath parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success :%@", JSON);
        BOOL success = [[JSON valueForKeyPath:@"success"] boolValue];
        if (success) {
            id object = [JSON valueForKeyPath:@"_object"];
            
            [self sentToWeChatClient];
            
        } else {
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", error);
    }];
    [operation start];

    
    
}


- (void)sentToWeChatClient {
    [WXApi sendVoteMessage:nil];
}

- (NITextInputFormElement2 *)redCodeElement {
    if (_redCodeElement == nil) {
        _redCodeElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"红方暗号" placeholderText:@"必需" value:nil delegate:self required:YES];
    }
    return _redCodeElement;
}

- (NITextInputFormElement2 *)blueCodeElement {
    if (_blueCodeElement == nil) {
        _blueCodeElement = [NITextInputFormElement2 textInputElementWithID:0 title:@"蓝方暗号" placeholderText:@"必需" value:nil delegate:self required:YES];
    }
    return _blueCodeElement;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NINumberPickerFormElementCell *cell = (NINumberPickerFormElementCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[NINumberPickerFormElementCell class]]) {
        [cell.numberField becomeFirstResponder];
    }
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
