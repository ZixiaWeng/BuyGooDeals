//
//  BDGAPI.h
//  BuyGoodeals
//
//  Created by LabanL on 16/6/21.
//  Copyright © 2016年 BuyGoodeals. All rights reserved.
//

#ifndef BDGAPI_h
#define BDGAPI_h

#define API_HOST @"http://www.buygoodeals.com/"

//获取商品列表
#define API_GOODS_LIST @"api/index.php?url=Article/index"
#define PARAM_GOODS_LIST_POST_TYPE @"post_type" //headlines,post,haitao

//通过TAG获取商品列表，API同上
#define PARAM_GOODS_LIST_TAG @"tag"

//获取商品详细信息
#define API_GOODS_DETAILS @"api/index.php?url=article/detail"
#define PARAM_GOODS_DETAILS_ID @"id"

//商品收藏
#define API_GOODS_FAVO @"api/index.php?url=favorites/add"
#define PARAM_GOODS_FAVO_ID @"id"
#define PARAM_GOODS_FAVO_ACT @"act" //add,rem

//商品点赞或取消点赞
#define API_GOODS_PRAISE @"api/index.php?url=Vote/add"
#define PARAM_GOODS_PRAISE_ID @"id"
#define PARAM_GOODS_PRAISE_ACT @"act" //up,down

//获取商品评论列表
#define API_GOODS_COMMENT_LIST @"api/index.php?url=Comment/recomment"
#define PARAM_GOODS_COMMENT_LIST_POST_ID @"post_id"

//发送评论
#define API_COMMENT_SEND @"api/index.php?url=Comment/add"
#define PARAM_COMMENT_SEND_POST_ID @"post_id"
#define PARAM_COMMENT_SEND_PARENT @"parent"
#define PARAM_COMMENT_SEND_CONETNT @"content"

//商品搜索
#define API_GOODS_SEARCH @"api/index.php?url=Search/index"
#define PARAM_GOODS_SEARCH_POST_TYPE @"post_type"
#define PARAM_GOODS_SEARCH_KEY @"s"

//商品热门搜索标签
#define API_GOODS_SEARCH_HOT_TAGS @"api/index.php?url=Search/hottags"

//获取用户收藏列表
#define API_USER_FAVO_GOODS_LIST @"api/index.php?url=Favorites/my_favorites"

//获取用户评论列表
#define API_USER_COMMENT_LIST @"api/index.php?url=Comment/my_comment"
#define PARAM_USER_COMMENT_LIST_COMMENT_TYPE @"comment_type" //send,receive

//用户登陆
#define API_USER_LOGIN @"api/index.php?url=User/login"
#define PARAM_USER_LOGIN_USERNAME @"username"
#define PARAM_USER_LOGIN_PASSWORD @"password"

//用户注册
#define API_USER_REGISTER @"api/index.php?url=User/register"
#define PARAM_USER_REGISTER_USERNAME @"username"
#define PARAM_USER_REGISTER_NICKNAME @"nickname"
#define PARAM_USER_REGISTER_PASSWORD @"password"
#define PARAM_USER_REGISTER_EMAIL @"email"

//检查更新
#define API_APP_UPDATE @"api/index.php?url=update/check"

#endif /* BDGAPI_h */
