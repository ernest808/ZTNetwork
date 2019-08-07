
//
//  ListDataSource.m
//  winebook
//
//  Created by user on 13-11-14.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import "ListDataSource.h"
#import "NSString+Trim.h"

static NSString *_listName;

@implementation ListDataSource

+(NSMutableArray*) parseDire:(NSData *)data class:(Class)class
{
    return [self parseDireWithListName:data listName:_listName class:class];
}

+(NSMutableArray*)parseDireWithListName:(NSData *)data listName:(NSString*)listName class:(Class)class
{
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        DLog(@"json parse failed \r\n");
        return nil;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (!listName || listName.length<=0) {
        if ([json count]>0) {
            for (NSDictionary *dic in json) {
                id item=[[class alloc] initWithData:dic];
                [items addObject:item];
            }
        }
    }else{
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json count]>0) {
                if (([[(NSDictionary*)json objectForKey:listName] isKindOfClass:[NSDictionary class]] || [[(NSDictionary*)json objectForKey:listName] isKindOfClass:[NSArray class]]) && [[(NSDictionary*)json objectForKey:listName] count]>0) {
                    NSDictionary *dicJson = [(NSDictionary*)json objectForKey:listName];
                    for (NSDictionary *dic in dicJson) {
                        id item=[[class alloc] initWithData:dic];
                        [items addObject:item];
                    }
                }else{
                    for (NSString *subDic in json) {
                        if ([[(NSDictionary*)json objectForKey:subDic] isKindOfClass:[NSDictionary class]] && [[(NSDictionary*)json objectForKey:subDic] objectForKey:listName]) {
                            NSDictionary *dicJson = [[(NSDictionary*)json objectForKey:subDic] objectForKey:listName];
                            if (([dicJson isKindOfClass:[NSArray class]] || [dicJson isKindOfClass:[NSDictionary class]]) && dicJson.count>0) {
                                for (NSDictionary *dic in dicJson) {
                                    id item=[[class alloc] initWithData:dic];
                                    [items addObject:item];
                                }
                            }
                        }
                    }
                }
            }
        }else{
            if ([json count]>0 && [(NSDictionary*)[json objectAtIndex:0] objectForKey:listName] && [[(NSDictionary*)[json objectAtIndex:0] objectForKey:listName] count]>0) {
                NSDictionary *dicJson = [(NSDictionary*)[json objectAtIndex:0] objectForKey:listName];
                for (NSDictionary *dic in dicJson) {
                    id item=[[class alloc] initWithData:dic];
                    [items addObject:item];
                }
            }
        }
    }
    return items;
}

+(NSMutableArray*) parseDireWithArray:(NSArray*)array class:(Class)class
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (![array isKindOfClass:[NSNull class]] && array.count>0 && class) {
        for (NSDictionary *dic in array) {
            id item = [[class alloc] initWithData:dic];
            [items addObject:item];
        }
    }
    return items;
}

+(void)setListName:(NSString *)listName
{
    _listName = listName;
}

@end
