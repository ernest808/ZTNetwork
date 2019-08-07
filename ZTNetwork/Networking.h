//
//  Networking.h
//  AFNetworking
//
//  Created by zhuruhong on 2017/10/29.
//

#import <Foundation/Foundation.h>
#import "NetReqModel.h"

#ifdef DEBUG
#define ZTNetworkLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define ZTNetworkLog(format, ...)
#endif

#define ZZSafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil

typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^SuccessBlock)(NSURLResponse *rsp, NSInteger code, id rspObject);
typedef void(^FailureBlock)(NSURLSessionTask *task,NSError *error);
typedef void(^CompleteBlock)(id result);

/**
 网络请求
 */
@interface Networking : NSObject

+ (NSURLSessionDataTask *)requestWithReqModel:(NetReqModel *)reqModel
                                      success:(SuccessBlock)successBlock
                                      failure:(FailureBlock)failureBlock;

@end
