//
//  WXApi+EasyWrap.h
//  Vote
//
//  Created by Ryan Wang on 13-1-7.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "WXApi.h"

@interface WXApi (EasyWrap)

+ (void)sendVoteNewGameInfo:(NSDictionary *)gameInfo;

@end
