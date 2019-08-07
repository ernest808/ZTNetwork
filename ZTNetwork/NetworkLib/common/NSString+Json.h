//
//  NSString+Json.h
//  shopplus
//
//  Created by Kevin Zhang on 11/29/13.
//  Copyright (c) 2013 Gaoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/**
 *  将数据转换成json字符串
 *
 *  @param dictionary   数据字典
 */
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

/**
 *  将数据转换成json字符串
 *
 *  @param object NSString\NSDictionary\NSArray，这三种类型数据
 */
+(NSString *) jsonStringWithObject:(id) object;

@end
