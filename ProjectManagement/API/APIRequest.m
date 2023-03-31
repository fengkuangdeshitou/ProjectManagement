//
//  APIRequest.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/29.
//

#import "APIRequest.h"
@import AFNetworking;
#import "UIView+Hud.h"

@interface APIRequest ()

@property(nonatomic,strong) AFHTTPSessionManager * manager;
@property(nonatomic,strong) NSMutableDictionary * headers;

@end

@implementation APIRequest

static APIRequest * _request = nil;

+ (instancetype)shareInstance{
    if (_request == nil) {
        _request = [[APIRequest alloc] init];
    }
    return _request;
}

- (NSMutableDictionary *)headers{
    if (!_headers) {
        _headers = [[NSMutableDictionary alloc] init];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:TOKEN]) {
        [_headers setValue:[NSUserDefaults.standardUserDefaults objectForKey:TOKEN] forKey:@"Authorization"];
    }
    return _headers;
}

- (AFHTTPSessionManager *)manager{
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.operationQueue.maxConcurrentOperationCount = 1;
        _manager.requestSerializer.timeoutInterval = 10;
    }
    return _manager;
}

- (void)getUrl:(NSString *)url
        params:(NSDictionary *)params
       success:(RequestSuccessBlock)success
       failure:(RequestFailureBlock)failure{
    [UIApplication.sharedApplication.keyWindow showHUDToast:@"加载中"];
    [self.manager GET:[Host stringByAppendingPathComponent:url] parameters:params headers:self.headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * code = json[@"code"];
        NSLog(@"url=%@,params=%@,result=%@",url,params,json);
        if (code.intValue == 200) {
            success(json);
        }else if (code.intValue == 401) {
            [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:TOKEN];
            [NSNotificationCenter.defaultCenter postNotificationName:Logout_NOTIFICATION object:nil];
        }else{
            failure(json[@"msg"]);
            [UIHelper showToast:json[@"msg"] toView:UIApplication.sharedApplication.keyWindow];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSLog(@"========%ld,%@",error.code,error.userInfo);
    }];
}

- (void)postUrl:(NSString *)url
         params:(NSDictionary *)params
        success:(RequestSuccessBlock)success
        failure:(RequestFailureBlock)failure{
    [UIApplication.sharedApplication.keyWindow showHUDToast:@"加载中"];
    [self.manager POST:[Host stringByAppendingPathComponent:url] parameters:params headers:self.headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * code = json[@"code"];
        NSLog(@"url=%@,params:%@,result=%@",url,params,json);
        if (code.intValue == 200) {
            success(json);
        }else{
            failure(json[@"msg"]);
            [UIHelper showToast:json[@"msg"] toView:UIApplication.sharedApplication.keyWindow];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSLog(@"err=%@",error);
    }];
}

- (void)postUrl:(NSString *)url
         params:(NSDictionary *)params
         images:(NSArray<UIImage*>*)images
        success:(RequestSuccessBlock)success
        failure:(RequestFailureBlock)failure{
    [self.manager POST:[Host stringByAppendingPathComponent:url] parameters:params headers:self.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<images.count; i++) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 0.5) name:@"files" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * code = json[@"code"];
        NSLog(@"url=%@,params=%@,result=%@",url,params,json);
        if (code.intValue == 200) {
            success(json);
        }else if (code.intValue == 401) {
            [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:TOKEN];
            [NSNotificationCenter.defaultCenter postNotificationName:Logout_NOTIFICATION object:nil];
        }else{
            failure(json[@"msg"]);
            [UIHelper showToast:json[@"msg"] toView:UIApplication.sharedApplication.keyWindow];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)deleteUrl:(NSString *)url
           params:(NSDictionary *)params
          success:(RequestSuccessBlock)success
          failure:(RequestFailureBlock)failure{
    [UIApplication.sharedApplication.keyWindow showHUDToast:@"加载中"];
    [self.manager DELETE:[Host stringByAppendingPathComponent:url] parameters:params headers:self.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * code = json[@"code"];
        NSLog(@"url=%@,params:%@,result=%@",url,params,json);
        if (code.intValue == 200) {
            success(json);
        }else{
            failure(json[@"msg"]);
            [UIHelper showToast:json[@"msg"] toView:UIApplication.sharedApplication.keyWindow];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)putUrl:(NSString *)url
        params:(NSDictionary *)params
       success:(RequestSuccessBlock)success
       failure:(RequestFailureBlock)failure{
    [UIApplication.sharedApplication.keyWindow showHUDToast:@"加载中"];
    [self.manager PUT:[Host stringByAppendingPathComponent:url] parameters:params headers:self.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication.sharedApplication.keyWindow hiddenHUD];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * code = json[@"code"];
        NSLog(@"url=%@,params:%@,result=%@",url,params,json);
        if (code.intValue == 200) {
            success(json);
        }else{
            failure(json[@"msg"]);
            [UIHelper showToast:json[@"msg"] toView:UIApplication.sharedApplication.keyWindow];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end
