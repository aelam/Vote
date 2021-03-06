//
//  RWMainViewController.m
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWRootViewController.h"
#import "RWMainViewController.h"
#import "RWSettingsViewController.h"
#import "RWCreateGameViewController.h"
#import "RWGameInfoController.h"
#import "RWGameListController.h"

//static NSInteger kMainIndex = 0;
//static NSInteger kSettingsIndex = 1;

@interface RWRootViewController ()

@property (nonatomic,strong) RWGameInfoController *gameInfoController;
@property (nonatomic,strong) UINavigationController *gameInfoNavigator;

@end

@implementation RWRootViewController

@synthesize gameInfoController = _gameInfoController;
@synthesize gameInfoNavigator = _gameInfoNavigator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RWCreateGameViewController *mainViewController = [[RWCreateGameViewController alloc] init];
    UINavigationController *mainNavigator = [[UINavigationController alloc] initWithRootViewController:mainViewController];

    RWGameListController *listController = [[RWGameListController alloc] init];
    UINavigationController *listNavigator = [[UINavigationController alloc] initWithRootViewController:listController];
    
    
    RWSettingsViewController *settingsViewController = [[RWSettingsViewController alloc] init];
    UINavigationController *settingsNavigator = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    self.viewControllers = [NSArray arrayWithObjects:mainNavigator,listNavigator,settingsNavigator,nil];

//    UITabBarItem *mainTabItem = [self.tabBar.items objectAtIndex:kMainIndex];
////    [mainTabItem setTitle:NSLocalizedString(@"vote", nil)];
//    [mainTabItem setTitle:nil];
//    [mainTabItem setImage:[UIImage imageNamed:@"help_40"]];
//    UITabBarItem *settingsTabItem = [self.tabBar.items objectAtIndex:kSettingsIndex];
////    [settingsTabItem setTitle:NSLocalizedString(@"settings", nil)];
//    [settingsTabItem setTitle:nil];
//    [settingsTabItem setImage:[UIImage imageNamed:@"tab_settings_pressed"]];
    
}

- (void)joinGameWithGameId:(NSString *)gameId {
    NSLog(@"%@",self.presentingViewController);
//    if ([self.gameInfoNavigator isBeingPresented]) {
        [self.gameInfoNavigator dismissModalViewControllerAnimated:NO];
//    } else {
    
        self.gameInfoController = [[RWGameInfoController alloc] initWithGameID:gameId];
        self.gameInfoNavigator = [[UINavigationController alloc] initWithRootViewController:self.gameInfoController];
//    }
    
    [self presentViewController:self.gameInfoNavigator animated:YES completion:NULL];
    
    NSLog(@"%@",self.gameInfoController.presentingViewController);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
