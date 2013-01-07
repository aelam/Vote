//
//  AFHTTPClient+Singleton.m
//  Vote
//
//  Created by Ryan Wang on 13-1-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "AFHTTPClient+Singleton.h"

@implementation AFHTTPClient (Singleton)

+ (id)sharedHTTPClient;
{
    static dispatch_once_t pred = 0;
    __strong static id __httpClient = nil;
    dispatch_once(&pred, ^{
        __httpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        [__httpClient setParameterEncoding:AFFormURLParameterEncoding];
        [__httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    return __httpClient;
}

@end
