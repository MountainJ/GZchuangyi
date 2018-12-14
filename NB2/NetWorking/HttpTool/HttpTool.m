//
//  HttpTool.m
//  VShow
//
//  Created by zhangbing on 15/3/25.
//  Copyright (c) 2015年 zhangbing. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "SBJson.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
static FailureBlock myFailureBlock;
static SuccessBlock mySuccessBlock;

@implementation HttpTool
+(void)myPostWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSMutableString *)paramsStr success:(SuccessBlock)success failure:(FailureBlock)failure
{
    myFailureBlock = failure;
    mySuccessBlock = success;
    NSData *postData = [paramsStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%zi", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,path]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError)//返回请求错误
        {
            myFailureBlock(connectionError);
        }else
        {
             NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            mySuccessBlock((NSDictionary *)json);
        }
    }];

}
+(NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

//+(void)downLoadImage:(NSString *)url placeHolder:(UIImage *)placeHolder inView:(UIImageView *)imageView
//{
//    NSString *fileName = [url lastPathComponent];
//
//    if ([self hasDownLoad:fileName])
//    {
//        NSData *tempImageData = [[NSUserDefaults standardUserDefaults] objectForKey:fileName];
//        UIImage *tempImg = [[UIImage alloc] initWithData:tempImageData];
//        [imageView setImage:tempImg];
//    }
//    else
//    {
//        [self downLoadImg:url];
//        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder];
//    }
//}
+(BOOL)hasDownLoad:(NSString *)imgName
{
    if (imgName==nil) {
        return NO;
    }
    NSData *tempImg;
    @try {
        tempImg = [[NSUserDefaults standardUserDefaults] objectForKey:imgName];
    }
    @catch (NSException *exception) {
        tempImg=nil;
    }
    if (tempImg==nil) {
        return NO;
    }
    UIImage *tempImage = [[UIImage alloc] initWithData:tempImg];
    @try
    {
        if (tempImage!=nil)
        {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    return NO;
}

+ (BOOL)isNULL:(NSString*)string{
    if (((NSNull *)string == [NSNull null]||string == nil || string.length == 0 || [string isEqualToString:@""])) {
        return YES;
    }else{
        return NO;
    }
}
+(void)uploadImage:(NSString *)urlString  // IN
         postParems: (NSString *)userId
         postParemd: (NSString *)md5
        picFileName: (NSString *)picFileName index:(NSString *) signIdex beizhu:(NSString *)beizhuxi data:(NSData *)datas success:(SuccessBlock)success failure:(FailureBlock)failure;  // IN    上传文件打路径
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"-------%@",locationString);
    NSDictionary *diction=@{@"id":userId,@"md5":md5,@"tid":signIdex,@"beizhu":beizhuxi,@"paytime":locationString};
    //NSDictionary *diction=@{@"id":userId,@"md5":md5,@"pic":picFileName};
    
    [manager POST:urlString parameters:diction constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:datas name:@"uploadinput" fileName:@"test.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        success(dic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];


}
+(void)downLoadImage:(NSString *)url placeHolder:(UIImage *)placeHolder inView:(UIImageView *)imageView success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
//    [imageView seti:[NSURL URLWithString:url]  placeholderImage:placeHolder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        success(request,response,image);
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        failure(request,response,error);
//    }];
}

+(NSMutableString *)getDataString:(NSDictionary *)diction
{
   // post2 = [[NSString alloc] initWithFormat:@"user=%@&pwd=%@&ip=%@",@"xiaocase",@"111111",@"14.20.99.242"];
    NSMutableString *param=[[NSMutableString alloc] init];
    for (int i=0;i<diction.count;i++)
    {
//        if (i==0)
//        {
//            [param appendString:[NSMutableString stringWithFormat:@"[{"]];
//        }
        [param appendString:[NSString stringWithFormat:@"%@=%@&",[[diction allKeys] objectAtIndex:i],[[diction allValues] objectAtIndex:i]]];
        if (i==diction.count-1)
        {
            [param deleteCharactersInRange:NSMakeRange(param.length-1, 1)];
            //[param appendString:[NSMutableString stringWithFormat:@"]"]];
            
        }
        
    }
    NSLog(@"%@",param);
    return param;

}
+(void)postWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self sendHttpPostWithBaseURL:baseURL path:path parameters:params callBack:^(id dict) {
        NSLog(@"dict==%@",dict);
        if (dict)
        {
            success(dict);
        }else
        {
//            NSError *error = [[NSError alloc]init];
            failure(dict);
        }
    }]; 
}
+(UIImage *) getUrlDataForm:(NSString *) surl
{
    UIImage *image=nil;
    NSURL *url=[NSURL URLWithString:surl];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error)
    {
        NSLog(@"请求失败！");
        return nil;
    }
    image=[UIImage imageWithData:data];
    return image;
}
+(void)requestWithBaseURL:(NSString *)baseURL path:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure method:(NSString *)method
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",baseURL,path] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

+(void)sendHttpPostWithBaseURL:(NSString *)baseURL path:(NSString *)path parameters:(NSDictionary *)parameters callBack:(VoidBlock_Dict)callback
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 18.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSLog(@"%@",parameters);
    [manager POST:[NSString stringWithFormat:@"%@%@",baseURL,path] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {      // raw data
            [self handleLoadedData:responseObject callBack:callback];
        }
        else {
            if (callback != nil) callback(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        callback(error);
        
    }];
    

}

+ (void) handleLoadedData:(NSData *)data callBack:(VoidBlock_Dict)callback{
    
    
//        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString*pageSource = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",pageSource);
//        NSDictionary * responseDict = [pageSource objectFromJSONString];
    
    NSDictionary * responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (responseDict != nil) {
        
        if (callback != nil) {
            callback(responseDict);
            return;
        }
    }
    else {
       
    }
    
    if (callback != nil) { callback(nil); }
}

+ (void) configureHttpPostRequest:(NSMutableURLRequest *)httpPostRequest
                         withData:(NSData *)httpBody {
    
    [httpPostRequest setTimeoutInterval:15];
    [httpPostRequest setHTTPMethod:@"POST"];
    [httpPostRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8"
           forHTTPHeaderField:@"Content-Type"];
    
    if (httpBody != nil) {
        
        [httpPostRequest setHTTPBody:httpBody];
        
        [httpPostRequest setValue:[NSString stringWithFormat:@"%zi",httpBody.length]
               forHTTPHeaderField:@"Content-Length"];
    }
}

+(NSString *) jsonStringFromObject:(id)anyObject
{
    
    NSString * jsonString = nil;
    
    if ([NSJSONSerialization isValidJSONObject:anyObject]) {
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:anyObject options:0 error:nil];
        
        if ([anyObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * parameters = (NSDictionary *)anyObject;
            
            NSMutableString * mString = [NSMutableString stringWithString:@""];
            
            for (NSString * key  in parameters.allKeys) {
                [mString appendFormat:@"%@=%@&",key,parameters[key]];
            }
            
            return [mString substringToIndex:mString.length -1];
        }
        else {
            
            jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            jsonString = [NSString stringWithFormat:@"Data=%@",jsonString];
        }
    }
    
    return jsonString;

}

// 由Json字符串返回对应的NSData对象
+ (NSData *) dataToBePostFromJsonString:(NSString *)jsonString {
    
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}
@end
