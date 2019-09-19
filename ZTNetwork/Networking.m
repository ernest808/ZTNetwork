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
    NSString *theUrl = reqModel.reqUrl;
    NSDictionary *theParams = reqModel.reqParams;
    NSDictionary *theMultipartParam = reqModel.reqMultipartDataParams;
    
    AFHTTPSessionManager *manager = [self managerWithHeader:reqModel.reqHeader contentType:reqModel.contentType];
    manager.requestSerializer.timeoutInterval = reqModel.timeout.integerValue;
    switch (reqModel.methodType) {
        case NetReqMethodTypePost: {
            return [self requestPostWithReqModel:manager theUrl:theUrl theParams:theParams theMultipartParam:theMultipartParam processBlock:reqModel.processBlock success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
                ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
                NSInteger status = [resultDic[@"result"] integerValue];
                ZZSafeBlockRun(successBlock, rsp, status, resultDic);
            } failure:failureBlock];
        }
            break;
        case NetReqMethodTypePut: {
            return [self requestPutWithReqModel:manager theUrl:theUrl theParams:theParams success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
                ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
                NSInteger status = [resultDic[@"result"] integerValue];
                ZZSafeBlockRun(successBlock, rsp, status, resultDic);
            } failure:failureBlock];
        }
            break;
        case NetReqMethodTypeDelete: {
            return [self requestDeleteWithReqModel:manager theUrl:theUrl theParams:theParams success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
                ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
                NSInteger status = [resultDic[@"result"] integerValue];
                ZZSafeBlockRun(successBlock, rsp, status, resultDic);
            } failure:failureBlock];
        }
            break;
            
        default:
        {
            return [self requestGetWithReqModel:manager theUrl:theUrl theParams:theParams success:^(NSURLResponse *rsp, NSInteger code, id rspObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:rspObject options:0 error:nil];
                ZTNetworkLog(@"success:%@, %@",reqModel.reqUrl, resultDic);
                NSInteger status = [resultDic[@"result"] integerValue];
                ZZSafeBlockRun(successBlock, rsp, status, resultDic);
            } failure:failureBlock];
        }
            break;
    }
    return nil;
}

+ (NSURLSessionDataTask *) requestDeleteWithReqModel:(AFHTTPSessionManager *)manager
                                           theUrl:(NSString *)theUrl
                                        theParams:(NSDictionary *)theParams
                                          success:(SuccessBlock)successBlock
                                          failure:(FailureBlock)failureBlock {
    NSURLSessionDataTask *dataTask = [manager DELETE:theUrl parameters:theParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *) requestPutWithReqModel:(AFHTTPSessionManager *)manager
                                           theUrl:(NSString *)theUrl
                                        theParams:(NSDictionary *)theParams
                                          success:(SuccessBlock)successBlock
                                          failure:(FailureBlock)failureBlock {
    NSURLSessionDataTask *dataTask = [manager PUT:theUrl parameters:theParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *) requestGetWithReqModel:(AFHTTPSessionManager *)manager
                                           theUrl:(NSString *)theUrl
                                        theParams:(NSDictionary *)theParams
                                          success:(SuccessBlock)successBlock
                                          failure:(FailureBlock)failureBlock {
    NSURLSessionDataTask *dataTask = [manager GET:theUrl parameters:theParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (NSURLSessionDataTask *)requestPostWithReqModel:(AFHTTPSessionManager *)manager
                                           theUrl:(NSString *)theUrl
                                         theParams:(NSDictionary *)theParams
                                         theMultipartParam:(NSDictionary *)theMultipartParam
                                     processBlock:(ProcessBlock)processBlock
                                          success:(SuccessBlock)successBlock
                                          failure:(FailureBlock)failureBlock {
    NSURLSessionDataTask *dataTask = [manager POST:theUrl parameters:theParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *multipartParamKeys = [theMultipartParam allKeys];
        for (id key in multipartParamKeys) {
            id value = theMultipartParam[key];
            [self appendFormData:formData value:value key:key];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (processBlock) {
            processBlock(uploadProgress);
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

+(void)appendFormData:(id<AFMultipartFormData> _Nonnull )formData value:(id)value key:(NSString*)key {
    if ([value isKindOfClass:[NSArray class]]){
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self appendFormData:formData value:value key:key];
        }];
    }else if ([value isKindOfClass:[NSData class]]) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *extention = @"jpg";
        NSString *name = key;
        if ([key pathExtension].length>0) {
            extention = [key pathExtension];
            name = [key stringByDeletingPathExtension];
        }
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", dateString,extention];
        [formData appendPartWithFileData:value name:name fileName:fileName mimeType:@"image/jpeg"];
    }else if ([value isKindOfClass:[NSURL class]]) {
        NSError *error;
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.%@", dateString, [(NSURL*)value absoluteString].pathExtension];
        [formData appendPartWithFileURL:value name:key fileName:fileName mimeType:@"image/jpeg" error:&error];
    }
}

@end
