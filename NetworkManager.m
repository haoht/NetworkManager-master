//
//  NetworkManager.m
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark - tool method
// 开启状态栏菊花
- (void)open
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// 关闭状态栏菊花
- (void)close
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - public method
// GCD单例
+ (NetworkManager *)sharedInstance
{
    static NetworkManager *__singletion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion = [[self alloc] init];
        
    });
    
    return __singletion;
}


// 请求网络数据 (POST或PUT时, 需要手动拼接url?后面的参数)
- (void)requestDataWithFrontURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    [self open];
    
    /******************************************** GET方法 ********************************************/
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
    
    
    /******************************************* DELETE方法 ******************************************/
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
    
    
    /************************************* POST方法, PUT方法 *************************************/
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
    {
        // 0. 拼接完整的URL地址
        NSMutableArray *laterArr = [NSMutableArray array];
        
        for (NSString *key in [parameter allKeys]) {
            
            NSString *keyValue = [key stringByAppendingFormat:@"=%@",[parameter objectForKey:key]];
            [laterArr addObject:keyValue];
        }
        
        NSString *laterURL = [laterArr componentsJoinedByString:@"&"];
        NSString *finalURL = [url stringByAppendingFormat:@"?%@", laterURL];
        
        
        // 1.初始化
//        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//        NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:url parameters:parameter error:nil];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalURL]];
        
        
        // 2.设置请求类型
        request.HTTPMethod = method;
        
        
        // 3.设置超时时间
        request.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [request setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置消息体
        if (body) {
            
            request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        
        // 6.请求
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
        
        [operation start];
//        [operation waitUntilFinished]; //同步
    }
}



// 请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    // 开启状态栏菊花
    [self open];
    
    /******************************************** GET方法 ********************************************/
    
    if ([method isEqualToString:@"GET"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
    
    
    /******************************************* DELETE方法 ******************************************/
    
    if ([method isEqualToString:@"DELETE"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager DELETE:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
    
    
    /******************************************* POST方法 ******************************************/
    
    if ([method isEqualToString:@"POST"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
    
    
    /******************************************* PUT方法 ******************************************/
    
    if ([method isEqualToString:@"PUT"])
    {
        // 1.初始化
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        // 2.设置请求格式 (默认二进制, 这里不用改也OK)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        // 3.设置超时时间
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        
        
        // 4.设置消息头
        if (header) {
            
            for (NSString *key in [header allKeys]) {
                [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        
        // 5.设置返回格式 (默认JSON, 这里必须改为二进制)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 6.请求
        [manager PUT:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 成功
            successBlock(operation, responseObject);
            
            // 关闭状态栏菊花
            [self close];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 失败
            failureBlock(operation, error);
            
            // 关闭状态栏菊花
            [self close];
        }];
    }
}

@end
