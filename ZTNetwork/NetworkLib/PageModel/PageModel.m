//
//  Search.m
//  winebook
//
//  Created by user on 13-11-16.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import "PageModel.h"

@implementation PageModel

- init {
	if (self = [super init]) {
        _pageSizeName = @"pageSize";
        _pageIndexName = @"pageNumber";
        _pageStampName = nil;
		[self initData];
	}
	return self;
}

- (void)initData
{
    _defaultPageIndex = 1;
	_pageSize = 10;
	_pageIndex = _defaultPageIndex;
}

-(void)setDefaultPageIndex:(NSInteger)defaultPageIndex {
    _defaultPageIndex = defaultPageIndex;
    _pageIndex = defaultPageIndex;
}

-(NSMutableDictionary*)getPageDic
{
    NSMutableDictionary *dicPage = [[NSMutableDictionary alloc]init];
    [dicPage setObject:[NSString stringWithFormat:@"%ld",(long)_pageSize] forKey:_pageSizeName];
    [dicPage setObject:[NSString stringWithFormat:@"%ld",(long)_pageIndex] forKey:_pageIndexName];
    if (self.pageStampName && self.pageStamp) {
        [dicPage setObject:self.pageStamp forKey:self.pageStampName];
    }
    return dicPage;
}

-(void)refresh {
    self.pageIndex = self.defaultPageIndex;
    self.pageStamp = nil;
}

@end
