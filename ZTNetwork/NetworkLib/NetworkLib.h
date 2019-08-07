//
//  NetworkLib.h
//  NetworkLib
//
//  Created by zeng on 2017/6/22.
//  Copyright © 2017年 xinxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkLib : NSObject

/**
 *  保存用户数据到本地
 *
 *  @param value 数据
 *  @param key key
 */
+(void)saveUserDefault:(id)value forKey:(NSString *)key;

/**
 *  获取本地用户数据
 *
 *  @param key key
 */
+(id)getUserDefault:(NSString *)key;

/**
 *  保存BOOL值用户数据到本地
 *
 *  @param value 数据
 *  @param key key
 */
+(void)saveBoolUserDefault:(BOOL)value forKey:(NSString *)key;

/**
 *  获取本地BOOL值用户数据
 *
 *  @param key key
 */
+(BOOL)getBoolUserDefault:(NSString*)key;

@end
