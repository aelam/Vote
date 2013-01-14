//
//  RWUser.h
//  Vote
//
//  Created by Ryan Wang on 13-1-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RWUser : NSObject

@property (nonatomic, retain) NSString * mood;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * userID;

@property (nonatomic,copy) NSString *lastGameId;

+ (RWUser *)currentUser;

- (void)save;

@end
