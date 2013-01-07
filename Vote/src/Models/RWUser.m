//
//  RWUser.m
//  Vote
//
//  Created by Ryan Wang on 13-1-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWUser.h"


static NSString *kUserIDKey     = @"kUserIDKey";
static NSString *kNicknameKey   = @"kNicknameKey";
static NSString *kMoodKey       = @"kMoodKey";

@interface RWUser ()

- (void)loadLocalInfo;

@end

@implementation RWUser

//@dynamic mood;
//@dynamic nickname;
//@dynamic userID;

@synthesize mood = _mood;
@synthesize nickname = _nickname;
@synthesize userID = _userID;

+ (RWUser *)currentUser {
    static RWUser *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[RWUser alloc] init];
        [currentUser loadLocalInfo];
    });
    
    return currentUser;
}

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (id)copyWithZone:(id)zone {
    RWUser *user = [[RWUser alloc] init];
    user.userID = self.userID;
    user.nickname = self.nickname;
    user.mood = self.mood;
    
    return user;
}

- (void)loadLocalInfo {
    self.mood = [[NSUserDefaults standardUserDefaults] stringForKey:kMoodKey];
    self.userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];
    self.nickname = [[NSUserDefaults standardUserDefaults] stringForKey:kNicknameKey];    
}


- (void)save {
    [[NSUserDefaults standardUserDefaults]setObject:self.mood forKey:kMoodKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.userID forKey:kUserIDKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.nickname forKey:kNicknameKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"id : %@ , nickname : %@ mood : %@",self.userID,self.nickname,self.mood];
}

@end
