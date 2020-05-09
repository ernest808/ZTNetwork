//
//  BaseModel.m
//  winebook
//
//  Created by zengwu on 13-11-14.
//  Copyright (c) 2013年 sharemarking.com. All rights reserved.
//

#import "BaseModel.h"
#import "ListDataSource.h"
#import "NSString+Trim.h"
#import "NetworkLib.h"

@implementation BaseModel

-(id)initWithData:(NSDictionary *)result
{
    if(self=[self init])
    {
        if ([result isKindOfClass:[NSDictionary class]] || [result isKindOfClass:[NSData class]]) {
            Class class = [self class];
            while ([class isSubclassOfClass:[BaseModel class]]) {
                unsigned int outCount;
                Ivar * ivars = class_copyIvarList([class class], &outCount);
                for (unsigned int i = 0; i < outCount; i ++) {
                    Ivar ivar = ivars[i];
                    const char * name = ivar_getName(ivar);
                    const char * type = ivar_getTypeEncoding(ivar);
                    
                    NSString *key = [[NSString stringWithCString:name  encoding:NSUTF8StringEncoding] trim:@"_"];
                    NSString *classType = [[NSString stringWithCString:type encoding:NSUTF8StringEncoding] trim:@"@\""];
                    
                    if ([self respondsToSelector:@selector(ReplaceKeys)]) {
                        NSDictionary *dicReplace = [self ReplaceKeys];
                        if (dicReplace && [dicReplace objectForKey:key]) {
                            key = [dicReplace objectForKey:key];
                        }
                    }
                    
                    NSString *arrayType = [[NSString alloc]init];
                    if ([classType rangeOfString:@"NSArray"].location==0 || [classType rangeOfString:@"NSMutableArray"].location==0) {
                        NSArray *array = [classType componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
                        if (array.count>1) {
                            classType = [array objectAtIndex:0];
                            arrayType = [array objectAtIndex:1];
                        }
                    }
                    if ([result isKindOfClass:[NSData class]]) {
                        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:(NSData*)result];
                        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
                        [unarchiver finishDecoding];
                        result = myDictionary;
                    }
                    if ([result objectForKey:key] && ![[result objectForKey:key] isKindOfClass:[NSNull class]]) {
                        Class controllClass=NSClassFromString(classType);
                        id controller = [[controllClass alloc]init];
                        if ([classType length]>0 && [controller isKindOfClass:BaseModel.class]) {
                            [self setValue:[controller initWithData:[result objectForKey:key]] forKey:key];
                        }else if([classType length]>0 && [controller isKindOfClass:NSArray.class]){
                            NSArray *tempArray = [ListDataSource parseDireWithArray:[result objectForKey:key] class:NSClassFromString(arrayType)];
//                            if (tempArray.count>0) {
                                //                                object_setIvar(self, ivar, tempArray);
                                
                                [self setValue:tempArray forKey:key];
//                            }else{
                                //                                object_setIvar(self, ivar, [result objectForKey:key]);
                                
//                                [self setValue:[result objectForKey:key] forKey:key];
//                            }
                        }else{
                            //                            object_setIvar(self, ivar, [result objectForKey:key]);
                            
                            [self setValue:[result objectForKey:key] forKey:key];
                        }
                    }
                }
                class = [class superclass];
                free(ivars);
            }
        }
    }
    return self;
}

-(id)initWithModel:(BaseModel *)result {
    return [self initWithData:result.toDictionary];
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[BaseModel class]]) {
            value = [(BaseModel*)value toDictionary];
        }else if ([value isKindOfClass:[NSArray class]]){
            NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
            for (id arrValue in (NSArray*)value) {
                if ([arrValue isKindOfClass:[BaseModel class]]) {
                    [arrTemp addObject:[(BaseModel*)arrValue toDictionary]];
                }else{
                    [arrTemp addObject:arrValue];
                }
            }
            value = arrTemp;
        }
        if (value){
            [dic setObject:value forKey:key];
        }
    }
    free(properties);
    return dic;
}

-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
}

-(NSString*)toJsonString
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [self toJSONData:[self toDictionary]];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(NSData*)toData
{
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        if ([self valueForKey:key]) {
            [userDic setObject:[self valueForKey:key] forKey:key];
        }
    }
    
    if (self) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        for (NSString *key in userDic.allKeys) {
            if ([[userDic valueForKey:key] isKindOfClass:[NSArray class]] && [(NSArray*)[userDic valueForKey:key] count]>0) {
                NSMutableArray *mutTempArray = [[NSMutableArray alloc]init];
                for (BaseModel *item in [userDic valueForKey:key]) {
                    if (item && [item isKindOfClass:[BaseModel class]]) {
                        [mutTempArray addObject:[item toData]];
                    }else{
                        [mutTempArray addObject:item];
                    }
                }
                [params setObject:mutTempArray forKey:key];
            }else{
                if ([[userDic valueForKey:key] isKindOfClass:[BaseModel class]]) {
                    [params setObject:[[userDic valueForKey:key] toData] forKey:key];
                }else{
                    [params setObject:[userDic valueForKey:key] forKey:key];
                }
            }
        }
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:params forKey:@"Some Key Value"];
        [archiver finishEncoding];
        return data;
    }
    free(properties);
    return [[NSData alloc]init];
}

-(void)SaveInstance{
    [NetworkLib saveUserDefault:[self toData] forKey:[NSString stringWithFormat:@"%@",self.class]];
}

-(id)GetInstance
{
    NSData *data = (NSData*)[NetworkLib getUserDefault:[NSString stringWithFormat:@"%@",self.class]];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
        [unarchiver finishDecoding];
        return [self initWithData:myDictionary];
    }
    return [self init];
}

-(void)CleanInstance
{
    [NetworkLib saveUserDefault:nil forKey:[NSString stringWithFormat:@"%@",self.class]];
}


// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    if ([theData isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:theData];
        for (NSString *strKey in tempDic.allKeys) {
            if ([[tempDic objectForKey:strKey] isKindOfClass:[BaseModel class]]) {
                [tempDic setObject:[[tempDic objectForKey:strKey] toDictionary] forKey:strKey];
            }
        }
        theData = tempDic;
    }else if ([theData isKindOfClass:[NSArray class]]){
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:theData];
        for (id object in tempArr) {
            if ([object isKindOfClass:[BaseModel class]]) {
                [tempArr replaceObjectAtIndex:[tempArr indexOfObject:object] withObject:[object toDictionary]];
            }
        }
        theData = tempArr;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end
