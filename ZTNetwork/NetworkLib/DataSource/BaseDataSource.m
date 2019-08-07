//
//  BaseDataSource.m
//  winebook
//
//  Created by user on 13-11-13.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import "BaseDataSource.h"
#import "NSString+Trim.h"

static NSString *_dataName;
static NSString *_errorName;

@implementation BaseDataSource

+(BaseModel*)parseDire:(NSData *)data class:(Class)class errorStr:(NSString**)errorStr
{
    return [self parseDire:data dataName:_dataName class:class errorStr:errorStr];
}

+(BaseModel*)parseDire:(NSData *)data dataName:(NSString*)dataName class:(Class)class errorStr:(NSString *__autoreleasing *)errorStr
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        DLog(@"json parse failed \r\n");
        return nil;
    }
    
    if (!dataName || dataName.length<=0) {
        if ([[json objectForKey:@"obj"] count]>0) {
            return [self getData:[json objectForKey:@"obj"] class:class];
        }else{
            return [self getData:json class:class];
        }
    }else{
        if (_errorName && ![[json objectForKey:_errorName] length]<=0) {
            *errorStr = [json objectForKey:_errorName];
        }else{
            return [self getData:json dataName:dataName class:class];
        }
    }
    return nil;
}

+(BaseModel*)getData:(NSDictionary*)json class:(Class)classtype
{
    return [self getData:json dataName:_dataName class:classtype];
}

+(BaseModel*)getData:(NSDictionary*)json dataName:(NSString*)dataName class:(Class)classtype
{
    if (!dataName || dataName.length<=0) {
        BaseModel *item=[[classtype alloc] initWithData:json];
        return item;
    }else if([[json allKeys] containsObject:dataName]){
        id data = [json objectForKey:dataName];
        if ([data isKindOfClass:[NSDictionary class]]) {
            return [[classtype alloc] initWithData:data];
        }else if ([data isKindOfClass:[NSArray class]])
        {
            return [[classtype alloc] initWithData:[data objectAtIndex:0]];
        }
        return nil;
    }else{
        for (NSString *subDic in json) {
            if ([[(NSDictionary*)json objectForKey:subDic] isKindOfClass:[NSDictionary class]] && [[(NSDictionary*)json objectForKey:subDic] objectForKey:dataName] && [[[(NSDictionary*)json objectForKey:subDic] objectForKey:dataName] count]>0) {
                NSDictionary *dicJson = [[(NSDictionary*)json objectForKey:subDic] objectForKey:dataName];
                BaseModel *item=[[classtype alloc] initWithData:dicJson];
                return item;
            }
        }
    }
    return nil;
}

+(id)parseJson:(NSData*)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        DLog(@"json parse failed \r\n");
        return nil;
    }
    return json;
}

+(void)setDataName:(NSString *)dataName
{
    _dataName = dataName;
}

+(void)setErrorName:(NSString *)errorName
{
    _errorName = errorName;
}

@end
