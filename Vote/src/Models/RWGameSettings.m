//
//  RWGameSettings.m
//  Vote
//
//  Created by Ryan Wang on 13-1-4.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWGameSettings.h"

static NSString *kRedRoleCountKey   = @"kRedRoleCountKey";
static NSString *kBlueRoleCountKey  = @"kRedRoleCountKey";
static NSString *kAutoDealKey       = @"kAutoDealKey";


@implementation RWGameSettings

@synthesize redRoleCount = _redRoleCount;
@synthesize blueRoleCount = _blueRoleCount;
@synthesize autoDeal = _autoDeal;

+ (RWGameSettings *)defaultSettings {
    static RWGameSettings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[RWGameSettings alloc] init];
        
        if ([self hasSavedSettings]) {
            [settings loadLocalInfo];
        } else {
            [settings loadBundleSettings];
            [settings save];
        }
    });
    
    return settings;
}


- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadBundleSettings {
    NSDictionary *bundleSettings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultSettings" ofType:@"plist"]];
    self.redRoleCount = [[bundleSettings valueForKey:kRedRoleCountKey] integerValue];
    self.blueRoleCount = [[bundleSettings valueForKey:kBlueRoleCountKey] integerValue];
    self.autoDeal = [[bundleSettings valueForKey:kAutoDealKey] boolValue];
}

- (void)loadLocalInfo {
    self.redRoleCount = [[[NSUserDefaults standardUserDefaults] stringForKey:kRedRoleCountKey] integerValue];
    self.blueRoleCount = [[[NSUserDefaults standardUserDefaults] stringForKey:kBlueRoleCountKey] integerValue];
    self.autoDeal = [[[NSUserDefaults standardUserDefaults] stringForKey:kAutoDealKey] boolValue];
}

+ (BOOL)hasSavedSettings {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:kRedRoleCountKey];
    return !!number;
}


- (void)save {
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.redRoleCount] forKey:kRedRoleCountKey];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.blueRoleCount] forKey:kBlueRoleCountKey];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:self.autoDeal] forKey:kAutoDealKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"red : %d , blue : %d auto : %d",self.redRoleCount,self.blueRoleCount,self.autoDeal];
}


@end
