//
//  NetReqModel.m
//  AFNetworking
//
//  Created by zhuruhong on 2017/10/29.
//

#import "NetReqModel.h"

@implementation NetReqModel

-(id)init {
    if (self==[super init]) {
        self.methodType = NetReqMethodTypePost;
        self.timeout = @(10.0);
        self.resultCodeKey = @"result";
    }
    return self;
}

/** 串联请求参数 key1=value1&key2=value2 */
- (NSString *)stringWithReqParamsForUrl
{
    NSMutableString *theParams = [[NSMutableString alloc] init];
    NSArray *allKeys = _reqParams.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = _reqParams[key];
        [theParams appendFormat:@"%@=%@&", key, value];
    }
    
    if (theParams.length > 0) {
        NSRange theRange = NSMakeRange(0, theParams.length - 1);
        return [theParams substringWithRange:theRange];
    } else {
        return @"";
    }
}

@end
