//
//  APIRequest.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/29.
//

#import <Foundation/Foundation.h>
#import "APIUrl.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestProgressBlock)(float progress);
typedef void(^RequestSuccessBlock)(NSDictionary * result);
typedef void(^RequestFailureBlock)(NSString *errorMsg);

@interface APIRequest : NSObject

+ (instancetype)shareInstance;

- (void)getUrl:(NSString *)url
        params:(NSDictionary *)params
       success:(RequestSuccessBlock)success
       failure:(RequestFailureBlock)failure;

- (void)postUrl:(NSString *)url
         params:(NSDictionary *)params
        success:(RequestSuccessBlock)success
        failure:(RequestFailureBlock)failure;

- (void)postUrl:(NSString *)url
         params:(NSDictionary *)params
         images:(NSArray<UIImage*>*)images
        success:(RequestSuccessBlock)success
        failure:(RequestFailureBlock)failure;

- (void)deleteUrl:(NSString *)url
           params:(NSDictionary *)params
          success:(RequestSuccessBlock)success
          failure:(RequestFailureBlock)failure;

- (void)putUrl:(NSString *)url
        params:(NSDictionary *)params
       success:(RequestSuccessBlock)success
       failure:(RequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
