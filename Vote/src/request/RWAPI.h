//
//  RWAPI.h
//  Vote
//
//  Created by Ryan Wang on 13-1-8.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWUser.h"

@interface RWAPI : NSObject



+ (void)joinGameWithID:(NSString *)id_ username:(NSString *)name
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

+ (void)modifyUser:(RWUser *)modifyingUser result:(void (^)(RWUser *modifiedUser,NSError *error))result;

+ (void)viewGameWithID:(NSString *)id_ username:(NSString *)name
               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;



@end
