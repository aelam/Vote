//
//  RWGameSettings.h
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWGameSettings : NSObject

@property (nonatomic,assign) NSInteger redRoleCount;
@property (nonatomic,assign) NSInteger blueRoleCount;
@property (nonatomic,assign) BOOL autoDeal;




+ (RWGameSettings *)defaultSettings;
- (void)save;



@end
