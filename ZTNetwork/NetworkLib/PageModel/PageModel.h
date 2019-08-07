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
 分页Model
 */
@interface PageModel : NSObject
@property (nonatomic,assign) NSInteger defaultPageIndex;    //起始页码(默认1开始)
@property (nonatomic,assign) NSString *pageSizeName;        //每页数量参数名称
@property (nonatomic,retain) NSString *pageIndexName;       //页码参数名称
@property (nonatomic, assign) NSInteger pageSize;           //每页数量(默认10)
@property (nonatomic, assign) NSInteger pageIndex;          //当前页码
@property (nonatomic, retain) NSString *strUrl;             //url地址
@property (nonatomic, retain) NSDictionary *postData;       //post参数
@property (nonatomic, assign) BOOL withPage;                //是否包含分页
@property (nonatomic, copy) SearchBlock searchBlock;        //数据加载回调
@property (nonatomic, retain) NSNumber *timeStamp;            //分页时间戳

/**
 生成包含page信息的url
 */
- (NSString*)buildPageUrl;
/**
 获取分页字典
 */
-(NSMutableDictionary*)getPageDic;

@end
