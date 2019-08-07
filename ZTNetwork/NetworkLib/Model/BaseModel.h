//
//  BaseModel.h
//  winebook
//
//  Created by zengwu on 13-11-14.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BaseModel : NSObject

/**
 初始化实体数据

 @param result 实体数据
 @return 实体
 */
-(id)initWithData:(NSDictionary *)result;

/**
 初始化实体数据
 
 @param result 实体数据
 @return 实体
 */
-(id)initWithModel:(BaseModel *)result;

/**
 实体数据转换成字典

 @return 数据字典
 */
-(NSDictionary*)toDictionary;

/**
 从内存中获取实体数据

 @return 实体
 */
-(id)GetInstance;

/**
 把实体数据保存到内存中去
 */
-(void)SaveInstance;

/**
 清除内存中实体数据
 */
-(void)CleanInstance;

/**
 实体转换成data类型

 @return 实体数据
 */
-(NSData*)toData;

/**
 实体转换成json字符串

 @return 数据json字符串
 */
-(NSString*)toJsonString;

@end
