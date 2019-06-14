//
//  CLNetwork.m
//  Traveling
//
//  Created by 朱成龙 on 2018/11/15.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import "CLNetwork.h"
//#import "Account.h"

@implementation CLNetwork
+(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   scrollView:(UIScrollView * _Nonnull)scrollView
                      success:(CLSuccessBlock)successBlock
                         fail:(CLFailBlock)failBlock
                          end:(CLSuccessBlock)endBlock
                      isCache:(BOOL)isCache
                       isShow:(BOOL)isShow{
    if (!URLString) {
        NSLog(@"url为空");
        return nil;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    dict[@"version"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    dict[@"device"] = @"iOS";
//    dict[@"token"] = [Account account].token;
    dict[@"appflag"] = @"loqo";
    dict[@"bundleid"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"desParams"] = [dict.mj_JSONString encryptUseDES];
    NSLog(@"\n%@\n%@\n%@",URLString,dict.mj_JSONString,parameter.mj_JSONString);
    
    YYCache * cache = [YYCache cacheWithName:@"zhucl"];
    [dict removeObjectForKey:@"lat"];
    [dict removeObjectForKey:@"lng"];
    NSString * cacheKey = [NSString stringWithFormat:@"%@_%@",URLString,dict.mj_JSONString];
    if (isCache) {
        if ([cache containsObjectForKey:cacheKey]) {
            NSDictionary * response = (NSDictionary *)[cache objectForKey:cacheKey];
            CLNetworkModel * model = [[CLNetworkModel alloc]initWithDictionary:response error:nil];
            if (successBlock) {
                successBlock(model,response,true);
            }
        }
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return [manager POST:URLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * resultDict = [[(NSData *)responseObject mj_JSONString] decryptUseDES].mj_JSONObject;
        //        NSDictionary * resultDict = responseObject;
        if (isCache) {
            [cache setObject:resultDict forKey:cacheKey];
        }
        CLNetworkModel * model = [[CLNetworkModel alloc]initWithDictionary:resultDict error:nil];
        
        if (model.state == 1) {
            [SVProgressHUD dismiss];
        }else if(model.state == -1){
//            [Account removeAccount];
            [SVProgressHUD dismiss];
        }else{
            if (isShow) {
                [SVProgressHUD showErrorWithStatus:model.info.message];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
        
        if (successBlock) {
            successBlock(model,resultDict,false);
        }
        
        [self endSuccesRefresh:scrollView model:model];
        
        if (endBlock) {
            endBlock(model,resultDict,false);
        }
        
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeNone)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        [SVProgressHUD dismissWithDelay:1];
        NSLog(@"%@",URLString);
        NSLog(@"%@",error.localizedDescription);
        if (failBlock) {
            failBlock(error);
        }
        [self endFailRefresh:scrollView];
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeNone)];
    }];
}

+(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   scrollView:(UIScrollView * _Nonnull)scrollView
                      success:(CLSuccessBlock)successBlock
                         fail:(CLFailBlock)failBlock
                          end:(CLSuccessBlock)endBlock
                      isCache:(BOOL)isCache{
    return [self POST:URLString parameters:parameters scrollView:scrollView success:successBlock fail:failBlock end:endBlock isCache:isCache isShow:true];
}

+(NSURLSessionDataTask *)POST:(NSString *)URLString
                       images:(NSArray *)images
                      success:(CLSuccessBlock)successBlock
                     progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress
                         fail:(CLFailBlock)failBlock{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager setSecurityPolicy:securityPolicy];
    return [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage * image in images) {
            [formData appendPartWithFileData:[self compress:image] name:@"file" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * resultDict = responseObject;
        CLNetworkModel * model = [[CLNetworkModel alloc]initWithDictionary:resultDict error:nil];
        if (successBlock) {
            successBlock(model,resultDict,false);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}
+(NSData *)compress:(UIImage *)image{
    NSData * data = UIImageJPEGRepresentation(image, 0.9);
    if (data.length > 1024 * 1024) {
        data = [self compress:image];
    }
    return data;
}


+(void)endSuccesRefresh:(UIScrollView *)scrollView
                  model:(CLNetworkModel *)model{
    
    if (scrollView) {
        if ([model.info.isNull isEqualToString:@"0"]) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [scrollView.mj_footer endRefreshing];
        }
        [scrollView.mj_header endRefreshing];
    }
}

+(void)endFailRefresh:(UIScrollView *)scrollView{
    if (scrollView) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
    }
}
@end

@implementation CLNetworkModel

@end

@implementation CLNetworkInfoModel

@end
