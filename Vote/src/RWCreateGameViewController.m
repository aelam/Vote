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
#import "SVProgressHUD.h"

static NSInteger const kRedElementTag   = 1001;
static NSInteger const kBlueElementTag  = 1003;
static NSInteger const kAutoCardElementTag  = 1004;

static NSInteger const kRedNumberElementTag   = 1011;
static NSInteger const kBlueNumberElementTag  = 1013;


@interface RWCreateGameViewController () <NITableViewModelDelegate,UITextFieldDelegate>

@property (nonatomic, readwrite, retain) NIMutableTableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;
//@property (nonatomic, readwrite, retain) NINumberPickerFormElement* redNumberElement;
//@property (nonatomic, readwrite, retain) NINumberPickerFormElement* blueNumberElement;
//@property (nonatomic, readwrite, retain) NISwitchFormElement *autoCardElement;
//@property (nonatomic, readwrite, retain) NITextInputFormElement2 *redCodeElement;
//@property (nonatomic, readwrite, retain) NITextInputFormElement2 *blueCodeElement;

@end

@implementation RWCreateGameViewController

@synthesize model = _model;
@synthesize actions = _actions;
//@synthesize redNumberElement = _redNumberElement;
//@synthesize blueNumberElement = _blueNumberElement;
//@synthesize autoCardElement = _autoCardElement;
//@synthesize redCodeElement = _redCodeElement;
//@synthesize blueCodeElement = _blueCodeElement;

- (id)initWithStyle:(UITableViewStyle)style {
    // We explicitly set the table view style in this controller's implementation because we want this
    // controller to control how the table view is displayed.
    self = [super initWithStyle:UITableViewStyleGrouped];
    {
        self.title = NSLocalizedString(@"createGame",@"创建游戏");
        self.tabBarItem.image = [UIImage imageNamed:@"plus"];
        self.tabBarItem.title = NSLocalizedString(@"create",@"创建");

        _actions = [[NITableViewActions alloc] initWithTarget:self];
        
        BOOL isAutoDeal = [RWGameSettings defaultSettings].autoDeal;
        
        
        
        NINumberPickerFormElement *redNumberElement = [NINumberPickerFormElement numberPickerElementWithID:kRedNumberElementTag labelText:NSLocalizedString(@"redNumber",@"红方人数") min:3 max:9 defaultValue:[RWGameSettings defaultSettings].redRoleCount didChangeTarget:self didChangeSelector:@selector(numberPickerValueChanged:)];
        redNumberElement.image = [UIImage imageNamed:@"set_red_count.png"];
        
        NINumberPickerFormElement *blueNumberElement = [NINumberPickerFormElement numberPickerElementWithID:kBlueNumberElementTag labelText:NSLocalizedString(@"blueNumber",@"蓝方人数") min:1 max:2 defaultValue:[RWGameSettings defaultSettings].blueRoleCount didChangeTarget:self didChangeSelector:@selector(numberPickerValueChanged:)];
        blueNumberElement.image = [UIImage imageNamed:@"set_blue_count.png"];
        
        NISwitchFormElement *autoCardElement = [NISwitchFormElement switchElementWithID:kAutoCardElementTag labelText:NSLocalizedString(@"autoDeal",@"自动发牌") value:isAutoDeal didChangeTarget:self didChangeSelector:@selector(switchAction:)];

        NSMutableArray* sectionedObjects =
        [NSMutableArray arrayWithObjects:
         [self.actions attachToObject:redNumberElement
                             tapBlock:
          ^BOOL(id object, id target) {
              
              NSLog(@"Object was tapped with an explicit action: %@ target : %@", object,target);
              return YES;
          }],
         blueNumberElement,
         @"",
         autoCardElement,
         @"",
         [self.actions attachToObject:[NITitleCellObject objectWithTitle:NSLocalizedString(@"createGame",@"创建游戏")]
                             tapBlock:
          ^BOOL(id object, id target) {
              
              [self createGame:nil];
              return YES;
          }],
         nil
         ];
        
        if (isAutoDeal == NO) {
            NSInteger index = [sectionedObjects indexOfObject:autoCardElement];
            [sectionedObjects insertObject:[self createBlueCodeElement] atIndex:index+1];
            [sectionedObjects insertObject:[self createRedCodeElement] atIndex:index+1];
            
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
    if (picker.tag == kRedNumberElementTag) {
        NINumberPickerFormElement *redNumberElement = (NINumberPickerFormElement *)[self.model elementWithID:kRedNumberElementTag];
        
        [RWGameSettings defaultSettings].redRoleCount = redNumberElement.value;
        [[RWGameSettings defaultSettings] save];
    } else if (picker.tag == kBlueNumberElementTag) {
        NINumberPickerFormElement *blueNumberElement = (NINumberPickerFormElement *)[self.model elementWithID:kBlueNumberElementTag];

        [RWGameSettings defaultSettings].blueRoleCount = blueNumberElement.value;
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
        
        NSArray *cell0 = [self.model insertObject:[self createRedCodeElement] atRow:1 inSection:1];
        NSArray *cell1 = [self.model insertObject:[self createBlueCodeElement] atRow:2 inSection:1];
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
    
    
//    NSLog(@"redNumberElement.selectedValue = %d",self.redNumberElement.selectedValue);
//    NSLog(@"blueCodeElement.selectedValue = %d",self.blueNumberElement.selectedValue);
    
    NSString *nickname = [RWUser currentUser].nickname;
    if (nickname.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"提示") message:NSLocalizedString(@"pleaseSetYourNickNameInSettings", @"设置昵称")delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *mood = [RWUser currentUser].mood;
    if (mood.length == 0) {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"提示") message:NSLocalizedString(@"pleaseSetYourMoodInSettings", @"设置昵称") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
  
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

    
    NISwitchFormElement *autoCardElement = (NISwitchFormElement*)[self.model elementWithID:kAutoCardElementTag];
    
    BOOL isAutoDeal = autoCardElement.value;
    if (isAutoDeal) {
        [params setObject:@"auto" forKey:@"type"];
    } else {
        NITextInputFormElement2 *redCodeElement = [self.model elementWithID:kRedElementTag];
        NITextInputFormElement2 *blueCodeElement = [self.model elementWithID:kBlueElementTag];

        
        if (redCodeElement.value.length == 0 || redCodeElement.value.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"提示") message:NSLocalizedString(@"codeWordCantBeNull",@"暗号不能为空") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [params setObject:[NSString stringWithFormat:@"%@",redCodeElement.value] forKey:@"goodWord"];
        [params setObject:[NSString stringWithFormat:@"%@",blueCodeElement.value] forKey:@"badWord"];
        [params setObject:@"notAuto" forKey:@"type"];
    }
    
    [params setObject:nickname forKey:@"operator"];
    [params setObject:kAccessToken forKey:@"ak"];
    [params setObject:mood forKey:@"name"];
    
    
    NINumberPickerFormElement *redNumberElement = [self.model elementWithID:kRedNumberElementTag];
    NINumberPickerFormElement *blueNumberElement = [self.model elementWithID:kBlueNumberElementTag];
    
    [params setObject:[NSString stringWithFormat:@"%d",redNumberElement.value] forKey:@"goodCount"];
    [params setObject:[NSString stringWithFormat:@"%d",blueNumberElement.value] forKey:@"badCount"];
    
    NSLog(@"%@",params);
    
    [SVProgressHUD showWithStatus:@"创建中"];
    
    AFHTTPClient *client = [AFHTTPClient sharedHTTPClient];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kCreateGamePath parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success :%@", JSON);
        BOOL success = [[JSON valueForKeyPath:@"success"] boolValue];
        if (success) {            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"createSuccess",@"nil")];
            
            
            id gameId = SAFE_STRING([JSON valueForKeyPath:@"_object.id"]);
            [RWUser currentUser].lastGameId = gameId;
            [[RWUser currentUser] save];

            
            [self sentToWeChatClient:JSON];
            
            
        } else {
            NSString * resultMsg = [JSON valueForKeyPath:@"resultMsg"];

            [SVProgressHUD showSuccessWithStatus:resultMsg];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD dismiss];

        NSLog(@"Failure: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"requestError", @"提示") message:NSLocalizedString(@"re",@"暗号不能为空") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;

    }];
    [operation start];

    
    
}


- (void)sentToWeChatClient:(NSDictionary *)json {
    [WXApi sendVoteNewGameInfo:json];
}

- (NITextInputFormElement2 *)createRedCodeElement {
       NITextInputFormElement2* _redCodeElement = [NITextInputFormElement2 textInputElementWithID:kRedElementTag title:NSLocalizedString(@"redCodeWord",@"红方暗号") placeholderText:NSLocalizedString(@"required",@"必需") value:nil delegate:self required:YES];
    return _redCodeElement;
}

- (NITextInputFormElement2 *)createBlueCodeElement {
    NITextInputFormElement2 * _blueCodeElement = [NITextInputFormElement2 textInputElementWithID:kBlueElementTag title:NSLocalizedString(@"blueCodeWord",@"蓝方暗号") placeholderText:NSLocalizedString(@"required",@"必需") value:nil delegate:self required:YES];
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
