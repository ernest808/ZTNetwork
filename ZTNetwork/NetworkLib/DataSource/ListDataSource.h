//
//  ListDataSource.h
//  winebook
//
//  Created by user on 13-11-14.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 解析列表数据源
 */
@interface ListDataSource : NSObject

/**
 *  解析列表数据
 *
 *  @param data   数组数据(NSData类型)
 *  @param classtype   实体类型
 */
+(NSMutableArray*) parseDire:(NSData *)data class:(Class)classtype;

/**
 *  解析列表数据
 *
 *  @param array   数组数据(NSArray类型)
 *  @param classtype   实体类型
 */
+(NSMutableArray*) parseDireWithArray:(NSArray*)array class:(Class)classtype;

/**
 *  解析列表数据
 *
 *  @param data         数据字典(NSData类型)
 *  @param listName     需要解析的实体在数组中的key
 *  @param classtype    实体类型
 */
+(NSMutableArray*)parseDireWithListName:(NSData *)data listName:(NSString*)listName class:(Class)classtype;

@end
