//
//  RWGameInfoController.h
//  Vote
//
//  Created by Ryan Wang on 13-1-8.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWGameInfoController : UITableViewController

- (id)initWithGameID:(NSString *)anID;

@property (nonatomic,copy) NSString *gameID;

@end
