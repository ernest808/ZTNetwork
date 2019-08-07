//
//  Networking.m
//  AFNetworking
//
//  Created by zhuruhong on 2017/10/29.
//

#import "Networking.h"
#import <AFNetworking/AFNetworking.h>

@implementation Networking

+ (AFHTTPSessionManager *)managerWithHeader:(NSDictionary *)header contentType:(NSString*)contentType
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    for (NSString *key in header) {
        [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
    }
    return manager;
}

+ (NSURLSessionDataTask *)requestWithReqModel:(NetReqModel *)reqModel
                                      success:(SuccessBlock)successBlock
                                      failure:(FailureBlock)failureBlock
{
    if (reqModel.methodType == NetReqMethodTypeGet) {
        return [self requestGetWithReqModel:reqModel header:reqModel.reqHeader progress:nil success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
            ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
            NSInteger status = [resultDic[@"result"] integerValue];
            ZZSafeBlockRun(successBlock, rsp, status, resultDic);
        } failure:failureBlock];
    } else if (reqModel.methodType == NetReqMethodTypePost) {
        return [self requestPostWithReqModel:reqModel header:reqModel.reqHeader progress:nil success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
            ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
            NSInteger status = [resultDic[@"result"] integerValue];
            ZZSafeBlockRun(successBlock, rsp, status, resultDic);
        } failure:failureBlock];
    }
    return nil;
}

+ (NSURLSessionDataTask *)requestGetWithReqModel:(NetReqModel *)reqModel
                                          header:(NSDictionary *)header
                                        progress:(ProgressBlock)progressBlock
                                         success:(SuccessBlock)successBlock
                                         failure:(FailureBlock)failureBlock
{
    NSString *theUrl = reqModel.reqUrl;
    NSDictionary *theParams = reqModel.reqParams;
    
    AFHTTPSessionManager *manager = [self managerWithHeader:header contentType:reqModel.contentType];
    manager.requestSerializer.timeoutInterval = reqModel.timeout.integerValue;
    NSURLSessionDataTask *dataTask = [manager GET:theUrl parameters:theParams progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task.response, 200, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(task, error);
        }
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)requestPostWithReqModel:(NetReqModel *)reqModel
                                           header:(NSDictionary *)header
                                         progress:(ProgressBlock)progressBlock
                                          success:(SuccessBlock)successBlock
                                          failure:(FailureBlock)failureBlock
{
    NSString *theUrl = reqModel.reqUrl;
    NSDictionary *theParams = reqModel.reqParams;
    NSDictionary *theMultipartParam = reqModel.reqMultipartDataParams;
    
    AFHTTPSessionManager *manager = [self managerWithHeader:header contentType:reqModel.contentType];
    manager.requestSerializer.timeoutInterval = reqModel.timeout.integerValue;
    NSURLSessionDataTask *dataTask = [manager POST:theUrl parameters:theParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *multipartParamKeys = [theMultipartParam allKeys];
        for (id key in multipartParamKeys) {
            id value = theMultipartParam[key];
            if ([value isKindOfClass:[NSData class]]) {
                    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                [formData appendPartWithFileData:value name:key fileName:fileName mimeType:@"image/jpeg"];
            }else if ([value isKindOfClass:[NSArray class]]){
                [value enumerateObjectsUsingBlock:^(NSData *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSError *error;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];

                    NSString *dateString = [formatter stringFromDate:[NSDate date]];

                    NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                    [formData appendPartWithFileData:obj name:key fileName:fileName mimeType:@"image/jpeg"];
                }];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task.response, 200, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(task, error);
        }
    }];
    return dataTask;
}

@end
