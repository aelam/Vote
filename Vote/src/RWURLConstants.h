//
//  RWURLConstants.h
//  Vote
//
//  Created by Ryan Wang on 13-1-6.
//  Copyright (c) 2013年 Ryan Wang. All rights reserved.
//

#define kBaseURL @"http://1.votebae.duapp.com"


////////////////////////////////////////////////////////////////////////
// 用户相关

/**
 * @param id 第一次注册不需要id, 修改信息需要id
 * @param username
 */
#define kModifyUserPath     @"modifyUser.action"



// 创建游戏相关

/**
 * @param name 第一次注册不需要id, 修改信息需要id
 * @param operator 
 * @param type `auto` or `notAuto`
 * @param goodCount
 * @param badCount
 */
#define kCreateGamePath     @"creatGame.action"





// 查看游戏相关

/**
 * @param id
 * @param operator
 */
#define kViewGameInfo       @"lookGame.action"