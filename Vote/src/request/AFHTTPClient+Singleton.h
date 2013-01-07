//
//  AFHTTPClient+Singleton.h
//  Vote
//
//  Created by Ryan Wang on 13-1-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface AFHTTPClient (Singleton)

+ (id)sharedHTTPClient;

@end
