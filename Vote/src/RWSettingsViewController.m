//
//  RWSettingsViewController.m
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWSettingsViewController.h"
#import "NIFormCellCatalog2.h"
#import <RestKit/RestKit.h>
#import "RWUser.h"
#import "AFHTTPClient+Singleton.h"
#import "RWAPI.h"
#import "SVProgressHUD.h"

static NSInteger const kNicknameTag = 100;
static NSInteger const kMoodTag = 101;


@interface RWSettingsViewController () <NITableViewModelDelegate,UITextFieldDelegate>

@property (nonatomic, readwrite, retain) NITableViewModel* model;
@property (nonatomic, readwrite, retain) NITableViewActions* actions;

//@property (nonatomic, readwrite, retain) NITextInputFormElement2* nickElement;
//@property (nonatomic, readwrite, retain) NITextInputFormElement2* signElement;


@end

@implementation RWSettingsViewController

@synthesize model = _model;
@synthesize actions = _actions;
@synthesize modifyingUser = _modifyingUser;
//@synthesize nickElement = _nickElement;
//@synthesize signElement = _signElement;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
- (id)initWithStyle:(UITableViewStyle)style {
    // We explicitly set the table view style in this controller's implementation because we want this
    // controller to control how the table view is displayed.
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.title = NSLocalizedString(@"settings", @"游戏设置");
        
        self.tabBarItem.image = [UIImage imageNamed:@"cog_01"];
        self.tabBarItem.title = NSLocalizedString(@"settings", @"游戏设置");

        NSString *nickname = [RWUser currentUser].nickname;
        NSString *mood = [RWUser currentUser].mood;
        
        
        self.modifyingUser = [RWUser currentUser];
        
        _actions = [[NITableViewActions alloc] initWithTarget:self];

         NITextInputFormElement2 *nickElement = [NITextInputFormElement2 textInputElementWithID:kNicknameTag title:NSLocalizedString(@"nickname", @"昵称") placeholderText:NSLocalizedString(@"required", @"Required") value:nickname delegate:self required:YES];
        nickElement.image = [UIImage imageNamed:@"nickname_setting"];
         NITextInputFormElement2 *signElement = [NITextInputFormElement2 textInputElementWithID:kMoodTag title:NSLocalizedString(@"mood", "个性签名") placeholderText:NSLocalizedString(@"optional",@"Optional") value:mood delegate:self required:NO];
        signElement.image = [UIImage imageNamed:@"setMemo"];

        NSArray* tableContents = [NSArray arrayWithObjects:
                                  nickElement,
                                  signElement,
                                  @"",
                                  [self.actions attachToObject:[NITitleCellObject objectWithTitle:NSLocalizedString(@"update",@"Update")]
                                                      tapBlock:
                                   ^BOOL(id object, id target) {
                                       
                                       [self submitChanges:nil];
                                       
                                       return YES;
                                   }],
                                  nil];
        
        self.model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                             delegate:(id)[NICellFactory class]];
        


    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [self.actions forwardingTo:self];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTableView)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];

}


- (void)reloadData {
//    self.nickElement.title = [RWUser currentUser].nickname;
//    self.signElement.title = [RWUser currentUser].mood;
    [self.tableView reloadData];
}


- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"row"];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: @"row"];
    }
    
    [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    //    cell.textLabel.text = [object objectForKey:@"title"];
    
    return cell;
}



- (void)submitChanges:(id)sender {
    
    [self.view endEditing:YES];
    
    
    if (self.modifyingUser.nickname.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errror",@"error") message:NSLocalizedString(@"nicknameIsNull",@"nicknameIsNull") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    [SVProgressHUD showWithStatus:@"更新中"];
    
    [RWAPI modifyUser:self.modifyingUser result:^(RWUser *modifiedUser, NSError *error) {
        if (error == NULL) {
            if ([RWUser currentUser].userID.length == 0) {
                [RWUser currentUser].userID = modifiedUser.userID;
                [SVProgressHUD showSuccessWithStatus:@"创建成功"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];                
            }
            
            [RWUser currentUser].nickname = modifiedUser.nickname;
            NITextInputFormElement2 *nickElement = (NITextInputFormElement2 *)[self.model elementWithID:kNicknameTag];
            nickElement.value = modifiedUser.nickname;
            
            [[RWUser currentUser] save];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(self.modifyingUser == nil) {
        self.modifyingUser = [RWUser currentUser];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == kMoodTag) {
        self.modifyingUser.mood = textField.text;
        [RWUser currentUser].mood = textField.text;
        [[RWUser currentUser] save];
    } else if (textField.tag == kNicknameTag) {
        self.modifyingUser.nickname = textField.text;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kMoodTag) {
        self.modifyingUser.mood = textField.text;
        [RWUser currentUser].mood = textField.text;
        [[RWUser currentUser] save];
    } else if (textField.tag == kNicknameTag) {
        self.modifyingUser.nickname = textField.text;
    }    
}


- (void)didTapTableView {
    [self.view endEditing:YES];
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
