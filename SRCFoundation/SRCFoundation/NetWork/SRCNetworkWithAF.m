//
//  SRCNetworkWithAF.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/7.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SRCNetworkWithAF.h"
#import "AFNetworking.h"
#import "NSString+Safe.h"
#import "NSString+URL.h"
#import "ErrorHome.h"


//网络失败数组容量
#define CONNECT_FAIL_ARR_COUNT   3

//相对路径

#define Encoding NSUTF8StringEncoding

@interface SRCNetworkWithAF()<NSCopying,NSMutableCopying>

@property (strong,nonatomic) NSMutableArray *connectFailArr;
@property (strong,nonatomic) AFHTTPSessionManager *manager;


@end

@implementation SRCNetworkWithAF

static SRCNetworkWithAF *instance = nil;//单例对象

+(instancetype)shareNetWorkingUtility
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark 语法逻辑
/**覆盖该方法主要确保当用户通过[[SrcNetWorkingWithAF alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark 重写init
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        instance.connectFailArr = [[NSMutableArray alloc]initWithCapacity:CONNECT_FAIL_ARR_COUNT];
        [instance chectReachAbility];//网络可达性校验
        
        //********************************************************
        instance.manager=[[AFHTTPSessionManager alloc] init];
        //[instance.manager.requestSerializer setValue:@"hq1.itiger.com" forHTTPHeaderField:@"Host"];
        //[instance.manager.requestSerializer setValue:@"v2" forHTTPHeaderField:@"X-API-Version"];
        [instance.manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [instance.manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        //[instance.manager.requestSerializer setValue:@"XAUGVl9TGwYCXVFaBAk=" forHTTPHeaderField:@"X-NewRelic-ID"];
        //[instance.manager.requestSerializer setValue:@"Stock/6.3.4 (iPhone; iOS 11.4.1; Scale/3.00)" forHTTPHeaderField:@"User-Agent"];
        [instance.manager.requestSerializer setValue:@"zh-Hans-CN;q=1, en-CN;q=0.9" forHTTPHeaderField:@"Accept-Language"];
        //[instance.manager.requestSerializer setValue:AUTHENTICATION forHTTPHeaderField:@"Authorization"];
        [instance.manager.requestSerializer setValue:@"br, gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        //[instance.manager.requestSerializer setValue:@"JSESSIONID=DE1EB986168F1DEB9CEEF192061F3DE5; ngxid=fPoiPltiu8ELJylHBB5mAg==" forHTTPHeaderField:@"Cookie"];
        
        
        //********************************************************
        //这里允许不进行证书验证, 主要https,来规避 evaluateServerTrust: forDomain:方法的验证不通过的问题。 code=-999
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        instance.manager.securityPolicy = securityPolicy;
        
        
        //********************************************************
        //这里设置返回的是data类型
        instance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        // 在服务器返回json数据的时候，时常会出现null数据。json解析的时候，可能会将这个null解析成NSNull的对象，我们向这个NSNull对象发送消息的时候就会遇到crash的问题。
        //使用 afhttpjsonresopnse 的时候，需要注意下面这个👇
        //instance.manager.responseSerializer.removesKeysWithNullValues = YES;
        
        
        //这里设置返回的是xml responseObject的类型是NSXMLParser
        //instance.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        //responseObject的类型是NSDictionary或者NSArray
        //instance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (instancetype)copyWithZone:(NSZone *)zone
{
    return instance;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return instance;
}

//自定义描述信息，用于log详细打印
- (NSString *)description
{
    return [super description];
}


#pragma mark 网络可达性
-(void)chectReachAbility
{
    /**
     AFNetworkReachabilityStatusUnknown = -1, // 未知
     AFNetworkReachabilityStatusNotReachable = 0, // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1, // 4G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2, // 局域网络,不花钱
     */
    
    __weak typeof(self) _weakSelf = self;
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        _weakSelf.reachAbility = status;
        
    }];
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}


//GET方法
+(void)requestGetMethodWithPath:(NSString *)path parameters:(NSDictionary *)parameters withProgress:(void (^)(float))downLoadProgress success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    if ([NSString safe_isEmpty:path]) {
        ERROR();
        return;
    }
    [[[self shareNetWorkingUtility] manager] GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if(downLoadProgress)
        {
            double progress=[downloadProgress fractionCompleted];
            downLoadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            if(responseObject)
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(YES,string);
            }
            else
            {
                success(YES,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            if(error)
            {
                failure(error);
            }
            else
            {
                NSString *domain =@"com.src.网络未知错误";
                NSString *desc = [[self class] description];
                NSDictionary *userInfo = @{domain : desc};
                NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                failure(error);
            }
        }
    }];
    
    
    
}


//POST方法
+(void)requestPostMethodWithPath:(NSString *)path parameters:(NSDictionary *)parameters withProgress:(void (^)(float))upLoadProgress success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    if ([NSString safe_isEmpty:path]) {
        ERROR();
        return;
    }
    [[[self shareNetWorkingUtility] manager] POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if(upLoadProgress)
        {
            double progress=[uploadProgress fractionCompleted];
            upLoadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            if(responseObject)
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(YES,string);
            }
            else
            {
                success(YES,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            if(error)
            {
                failure(error);
            }
            else
            {
                NSString *domain =@"com.src.网络未知错误";
                NSString *desc = [[self class] description];
                NSDictionary *userInfo = @{domain : desc};
                NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                failure(error);
            }
        }
    }];
 
}


//PUT
+(void)requestPutDataWithPath:(NSString *)path withParamters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure
{
    if([NSString safe_isEmpty:path])
    {
        ERROR();
        return;
    }
    [[[self shareNetWorkingUtility] manager] PUT:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            if(responseObject)
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(YES,string);
            }
            else
            {
                success(YES,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            if(error)
            {
                failure(error);
            }
            else
            {
                NSString *domain =@"com.src.网络未知错误";
                NSString *desc = [[self class] description];
                NSDictionary *userInfo = @{domain : desc};
                NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                failure(error);
            }
        }
    }];
}
   
//PATCH
+(void)requestPatchDataWithPath:(NSString *)path withParamters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure
{
    if([NSString safe_isEmpty:path])
    {
        ERROR();
        return;
    }
    [[[self shareNetWorkingUtility] manager] PATCH:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            if(responseObject)
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(YES,string);
            }
            else
            {
                success(YES,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            if(error)
            {
                failure(error);
            }
            else
            {
                NSString *domain =@"com.src.网络未知错误";
                NSString *desc = [[self class] description];
                NSDictionary *userInfo = @{domain : desc};
                NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                failure(error);
            }
        }
    }];
}

//DELETE
+(void)requestDeleteDataWithPath:(NSString *)path withParamters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure
{
    if([NSString safe_isEmpty:path])
    {
        ERROR();
        return;
    }
    [[[self shareNetWorkingUtility] manager] DELETE:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            if(responseObject)
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(YES,string);
            }
            else
            {
                success(YES,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            if(error)
            {
                failure(error);
            }
            else
            {
                NSString *domain =@"com.src.网络未知错误";
                NSString *desc = [[self class] description];
                NSDictionary *userInfo = @{domain : desc};
                NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                failure(error);
            }
        }
    }];
}

//cancel all
+(void)cancelAllNetworkRequest
{
    NSOperationQueue *queue=[[[self shareNetWorkingUtility] manager] operationQueue];
    if(queue&&[queue.operations count]>0)
    {
        [queue cancelAllOperations];
    }
}

//cancel the one or some
+(void)cancelRequestWithType:(NSString *)type WithPath:(NSString *)path
{
    NSError * error=nil;
    NSString *targetPath=nil;
    //需要取消的path 根据请求类型和path来
    NSMutableURLRequest *request=[[[[self shareNetWorkingUtility] manager] requestSerializer] requestWithMethod:type URLString:path parameters:nil error:&error];
    if(!error&&request)
    {
        targetPath=[[request URL] path];
        for (NSOperation * operation in [[[[self shareNetWorkingUtility] manager] operationQueue] operations])
        {
            // 如果是请求队列
            if ([operation isKindOfClass:[NSURLSessionTask class]]) {
                // 请求的类型匹配
                BOOL isTypeSame=[type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
                // 请求的url匹配
                BOOL isPahtSame = [targetPath isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
                // 两项都匹配的话  取消该请求
                if (isTypeSame&&isPahtSame) {
                    [operation cancel];
                }
            }
        }
    }
    
}









@end
