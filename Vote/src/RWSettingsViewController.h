//
//  RWSettingsViewController.h
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"
#import "RWUser.h"

@interface RWSettingsViewController : UITableViewController

@property (nonatomic,copy)RWUser *modifyingUser;

@end
