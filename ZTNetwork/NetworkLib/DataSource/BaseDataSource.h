//
//  BaseDataSource.h
//  winebook
//
//  Created by user on 13-11-13.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

/**
 解析数据源
 */
@interface BaseDataSource : NSObject

/**
 *  解析数据
 *
 *  @param data   数据字典(NSData类型)
 *  @param classtype   实体类
 *  @param errorStr 错误信息
 */
+(BaseModel*)parseDire:(NSData *)data class:(Class)classtype errorStr:(NSString**)errorStr;

/**
 *  解析数据
 *
 *  @param data   数据字典(NSData类型)
 *  @param dataName   需要解析的数据，在字典中的key
 *  @param classtype   实体类
 *  @param errorStr 错误信息
 */
+(BaseModel*)parseDire:(NSData *)data dataName:(NSString*)dataName class:(Class)classtype errorStr:(NSString *__autoreleasing *)errorStr;

/**
 *  将json数据转换成NSDictionary或者NSArray
 *
 *  @param data   json数据(NSData类型)
 */
+(id)parseJson:(NSData*)data;

@end
