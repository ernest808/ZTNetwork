//
//  NetworkLib.m
//  NetworkLib
//
//  Created by zeng on 2017/6/22.
//  Copyright © 2017年 xinxun. All rights reserved.
//

#import "NetworkLib.h"

@implementation NetworkLib

+(void)saveUserDefault:(id)value forKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}

+(id)getUserDefault:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+(void)saveBoolUserDefault:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:key];
    [ud synchronize];
}

+(BOOL)getBoolUserDefault:(NSString*)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:key];
}

@end
