//
//  Search.h
//  winebook
//
//  Created by user on 13-11-16.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SearchBlock)(void);

/**
 分页管理Model
 */
@interface PageModel : NSObject
/**
 起始页码(默认1开始)
 */
@property (nonatomic,assign) NSInteger defaultPageIndex;
/**
 每页数量参数名称
 */
@property (nonatomic,assign) NSString *pageSizeName;
/**
 页码参数名称
 */
@property (nonatomic,retain) NSString *pageIndexName;
/**
 每页数量(默认10)
 */
@property (nonatomic, assign) NSInteger pageSize;
/**
 当前页码
 */
@property (nonatomic, assign) NSInteger pageIndex;
/**
 分页数据加载回调(下拉刷新/上拉加载更多)
 */
@property (nonatomic, copy) SearchBlock searchBlock;
/**
 分页标识(用于防止分页数据重复或错乱)
 */
@property (nonatomic, retain) id pageStamp;
/**
 分页标识名(用于防止分页数据重复或错乱)，默认为timeStamp
 */
@property (nonatomic, retain) NSString * _Nullable pageStampName;
/**
 获取分页字典
 */
-(NSMutableDictionary*)getPageDic;

/**
 刷新数据(等同下拉刷新，重置分页信息)
 */
-(void)refresh;

@end
