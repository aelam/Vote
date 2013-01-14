//
//  RWGameInfoController.h
//  Vote
//
//  Created by Ryan Wang on 13-1-8.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RWGameInfoTypeView,
    RWGameInfoTypeJoin
}RWGameInfoType;

@interface RWGameInfoController : UITableViewController

- (id)initWithGameID:(NSString *)anID;

- (id)initWithGameID:(NSString *)anID infoType:(RWGameInfoType)type;



@property (nonatomic,copy) NSString *gameID;
@property (nonatomic,assign) RWGameInfoType infoType;

@end
