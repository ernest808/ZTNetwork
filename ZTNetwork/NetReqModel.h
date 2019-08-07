//
//  NetReqModel.h
//  AFNetworking
//
//  Created by zhuruhong on 2017/10/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetReqMethodType) {
    NetReqMethodTypePost = 0,
    NetReqMethodTypeGet,
    NetReqMethodTypeUnknown
};

@interface NetReqModel : NSObject

@property (nonatomic, assign) NetReqMethodType methodType;
@property (nonatomic, strong) NSString *reqUrl;
@property (nonatomic, strong) NSDictionary *reqParams;
@property (nonatomic, strong) NSDictionary *reqMultipartDataParams;
@property (nonatomic, strong) NSDictionary *reqHeader;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSNumber *timeout;

/** 串联请求参数 key1=value1&key2=value2 */
- (NSString *)stringWithReqParamsForUrl;

@end
