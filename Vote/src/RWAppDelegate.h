//
//  RWAppDelegate.h
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "WXApi.h"
#import "RWRootViewController.h"

@interface RWAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RWRootViewController *mainViewController;

@end
