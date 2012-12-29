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

static NSInteger kMainIndex = 0;
static NSInteger kSettingsIndex = 1;

@interface RWRootViewController ()

@end

@implementation RWRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RWMainViewController *mainViewController = [[RWMainViewController alloc] init];
    UINavigationController *mainNavigator = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    RWSettingsViewController *settingsViewController = [[RWSettingsViewController alloc] init];
    UINavigationController *settingsNavigator = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    self.viewControllers = [NSArray arrayWithObjects:mainNavigator,settingsNavigator,nil];

    UITabBarItem *mainTabItem = [self.tabBar.items objectAtIndex:kMainIndex];
    [mainTabItem setTitle:@"Main"];

    UITabBarItem *settingsTabItem = [self.tabBar.items objectAtIndex:kSettingsIndex];
    [settingsTabItem setTitle:@"Settings"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
