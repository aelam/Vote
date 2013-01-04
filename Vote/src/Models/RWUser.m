//
//  RWUser.m
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWUser.h"

@implementation RWUser

@synthesize userId = _userId;
@synthesize nickname = _nickname;
@synthesize mood = _mood;

+ (id)currentUser {
    static RWUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (user == nil) {
            user = [[RWUser alloc] init];
        }
    });
    return user;
}


@end
