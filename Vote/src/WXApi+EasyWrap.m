//
//  WXApi+EasyWrap.m
//  Vote
//
//  Created by Ryan Wang on 13-1-7.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#import "WXApi+EasyWrap.h"
#import "WXApi.h"
#import "WXApiObject.h"

@implementation WXApi (EasyWrap)

+ (void)sendVoteNewGameInfo:(NSDictionary *)gameInfo {
    // 发送内容给微信
    
    NSString *gameId = SAFE_STRING([gameInfo valueForKeyPath:@"_object.id"]);
//    NSString *name = SAFE_STRING([gameInfo valueForKeyPath:@"_object.name"]);
    NSString *name = [NSString stringWithFormat:@"游戏ID:%@",gameId];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"请点击此处获取你的暗号";
    message.description = name;
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = gameId;
//    ext.url = @"http://www.qq.com";

    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];

}



@end
