//
//  HttpTool.h
//  VShow
//
//  Created by zhangbing on 15/3/25.
//  Copyright (c) 2015年 zhangbing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock)(NSDictionary *dict);
typedef void (^FailureBlock)(NSError* error);
typedef void(^VoidBlock_Dict)(id dict);
@interface HttpTool : NSObject

+(UIImage *) getUrlDataForm:(NSString *) surl;
//下载图片
//+(void)downLoadImage:(NSString *)url placeHolder:(UIImage *)placeHolder inView:(UIImageView *)imageView;
+(void)myPostWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSString *)paramsStr success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)downLoadImage:(NSString *)url placeHolder:(UIImage *)placeHolder inView:(UIImageView *)imageView success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

//POST请求
+(void)postWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)requestWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure method:(NSString *)method;
+(NSMutableString *)getDataString:(NSDictionary *)diction;
+(NSString *)deviceIPAdress;
+ (void) sendHttpPostWithBaseURL:(NSString *)baseURL path:(NSString *)path
                       parameters:(NSDictionary *)parameters
                         callBack:(VoidBlock_Dict)callback;

+ (void)uploadImage:(NSString *)urlString  // IN
         postParems: (NSString *)userId
         postParemd: (NSString *)md5
        picFileName: (NSString *)picFileName index:(NSString *) signIdex beizhu:(NSString *)beizhuxi data:(NSData *)datas success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
