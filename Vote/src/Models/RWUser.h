//
//  RWUser.h
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWUser : NSObject

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *mood;  //个性签名


+ (id)currentUser;

@end
