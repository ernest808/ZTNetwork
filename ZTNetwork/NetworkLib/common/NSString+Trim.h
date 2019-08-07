//
//  NSString+Trim.h
//  Guide
//
//  Created by zengwu on 13-5-28.
//  Copyright (c) 2013年 ihouseking. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(...) NSLog(@"%s(%d) %@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...) ((void)0)
#endif

@interface NSString (Trim)

/**
 *  判断是否为空
 */
-(Boolean)isNull;

/**
 *  去掉头部和尾部字符串
 *
 *  @param str   需要去掉的字符串
 */
-(NSString*)trim:(NSString*)str;

/**
 *  去掉字符串中的小数部分
 *
 */
-(NSString*)trimDecimals;

/**
 *  去掉日期中的时间(格式为 yyyy-MM-dd HH:mm:ss)
 *
 */
-(NSString*)trimTime;

/**
 *  将字符串转换成固定格式的日期字符串
 *
 *  @param format   日期格式
 */
-(NSString*)getDateWithFormate:(NSString *)format;
@end
