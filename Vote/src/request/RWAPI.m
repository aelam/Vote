//
//  RWAPI.m
//  Vote
//
//  Created by Ryan Wang on 13-1-8.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "RWAPI.h"
#import "AFHTTPClient+Singleton.h"

static NSString *const kRWAPIDomain = @"RWAPI Domain";

@implementation RWAPI

+ (void)joinGameWithID:(NSString *)id_ username:(NSString *)name
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    
    AFHTTPClient *client = [AFHTTPClient sharedHTTPClient];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:kAccessToken forKey:@"ak"];
    [params setObject:id_ forKey:@"id"];
    [params setObject:name forKey:@"username"];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kJoinGamePath parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(request,response,JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", error);
        failure(request,response,error,JSON);
    }];
    [operation start];
}

+ (void)modifyUser:(RWUser *)modifyingUser result:(void (^)(RWUser *modifiedUser,NSError *error))result
{
    AFHTTPClient *client = [AFHTTPClient sharedHTTPClient];

    NSMutableDictionary *params;
    NSString *userid = [RWUser currentUser].userID;
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              kAccessToken,@"ak",
              modifyingUser.nickname,@"username",
              nil];
    
    if (userid.length) {
        [params setObject:userid forKey:@"id"];
    }

    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kModifyUserPath parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Success :%@", JSON);
        BOOL success = [[JSON valueForKeyPath:@"success"] boolValue];
        if (success) {
            id object = [JSON valueForKeyPath:@"_object"];
            
            modifyingUser.userID = [NSString stringWithFormat:@"%@",[object valueForKeyPath:@"id"]];
            modifyingUser.nickname = [object valueForKeyPath:@"username"];
            
            result(modifyingUser,NULL);

        } else {
//            resultCode = 002;
//            resultMsg = "\U7528\U6237\U540d\U5df2\U7ecf\U88ab\U5360\U7528\U4e86";
//            success = 0;
            NSInteger resultCode = [[JSON valueForKeyPath:@"resultCode"] intValue];
            NSString * resultMsg = [JSON valueForKeyPath:@"resultMsg"];
            NSDictionary *info = [NSDictionary dictionaryWithObject:resultMsg forKey:NSLocalizedDescriptionKey];
            
            NSError *error0 = [NSError errorWithDomain:kRWAPIDomain code:resultCode userInfo:info];
            result(modifyingUser,error0);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", error);
        result(modifyingUser,error);
    }];
    [operation start];
    
}



@end
