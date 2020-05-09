//
//  BaseModel.h
//  winebook
//
//  Created by zengwu on 13-11-14.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol BaseModelProtocol <NSObject>
@optional
/**
 自定义 “联合主键” 函数, 如果需要自定义 “联合主键”,则在类中自己实现该函数.
 @return 返回值是 “联合主键” 的字段名(即相对应的变量名).
 注：当“联合主键”和“唯一约束”同时定义时，“联合主键”优先级大于“唯一约束”.
 */
-(NSDictionary* _Nonnull)ReplaceKeys;

@end

@interface BaseModel : NSObject<BaseModelProtocol>

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
