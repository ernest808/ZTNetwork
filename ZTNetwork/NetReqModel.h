//
//  NetReqModel.h
//  AFNetworking
//
//  Created by zhuruhong on 2017/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetReqMethodType) {
    NetReqMethodTypeUnknown = 0,
    NetReqMethodTypePost = 1,
    NetReqMethodTypeGet = 2,
    NetReqMethodTypePut = 3,
    NetReqMethodTypeDelete =4
};

typedef void(^ProcessBlock)(NSProgress * _Nonnull process);

/**
 访问网络请求配置Model
 */
@interface NetReqModel : NSObject

/**
 请求类型
 */
@property (nonatomic, assign) NetReqMethodType methodType;
/**
 请求地址
 */
@property (nonatomic, strong) NSString *reqUrl;
/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary *reqParams;
/**
 请求上传文件参数
 */
@property (nonatomic, strong) NSDictionary *reqMultipartDataParams;
/**
 请求头
 */
@property (nonatomic, strong) NSDictionary *reqHeader;
/**
 http内容类型
 */
@property (nonatomic, strong) NSString *contentType;
/**
 超时时间(默认10.0秒)
 */
@property (nonatomic, strong) NSNumber *timeout;

@property (copy, nonatomic) ProcessBlock processBlock;

/** 串联请求参数 key1=value1&key2=value2 */
- (NSString *)stringWithReqParamsForUrl;

@end

NS_ASSUME_NONNULL_END
