//
//  NSString+Trim.m
//  Guide
//
//  Created by zengwu on 13-5-28.
//  Copyright (c) 2013年 ihouseking. All rights reserved.
//

#import "NSString+Trim.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (Trim)
/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

-(NSString*)trim:(NSString*)str
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:str]];
}

-(NSString*)trimDecimals
{
    return [NSString stringWithFormat:@"%.0f",[self floatValue]];
}

-(NSString*)trimTime
{
    NSArray *arrDate = [self componentsSeparatedByString:@" "];
    if ([arrDate count]>0) {
        return [arrDate objectAtIndex:0];
    }else{
        return self;
    }
}

-(NSString*)getFloat
{
    if (self.length<=0) {
        return @"0.0";
    }else{
        @try {
            return [NSString stringWithFormat:@"%f",[self floatValue]];
        }
        @catch (NSException *exception) {
            return @"0.0";
        }
        @finally {
        }
    }
}

-(NSString*)getNumberFormatter
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *strResult = [formatter stringFromNumber:[NSNumber numberWithInt:[self integerValue]]];
    return [NSString stringWithFormat:@"%@",strResult];
}

-(Boolean)isNull
{
    if (self.length<=0) {
        return YES;
    }else{
        return NO;
    }
}


-(NSString*)getDateWithFormate:(NSString *)format
{
    NSDate *date = [self dateFromString:self];
    if (!date) {
        date = [self dateFromString:self withFormat:@"yyyy-MM-dd"];
    }
    return [self stringWithFormat:date format:format];
}

- (NSString *)stringWithFormat:(NSDate*)date format:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:date];
    return timestamp_str;
}

- (NSDate *)dateFromString:(NSString *)string {
    return [self dateFromString:string withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

@end
