//
//  CLNetwork.m
//  Traveling
//
//  Created by 朱成龙 on 2018/11/15.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import "CLNetwork.h"
#import "CLCategory.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

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
//    dict[@"vid"] =  [UserTool user].vid;
    dict[@"appflag"] = @"yly";
    dict[@"bundleid"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    dict[@"system"] = [NSString stringWithFormat:@"%.0f", [UIScreen mainScreen].scale];
    
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"data"] = [dict.mj_JSONString encryptUseDES];
    NSLog(@"\n%@\n%@\n%@",URLString,dict.mj_JSONString,parameter.mj_JSONString);
    
    YYCache * cache = [YYCache cacheWithName:@"yilvyou"];
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
    return [manager POST:URLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * resultDict = [responseObject[@"data"] decryptUseDES].mj_JSONObject;
        if (isCache) {
            [cache setObject:resultDict forKey:cacheKey];
        }
        CLNetworkModel * model = [[CLNetworkModel alloc]initWithDictionary:resultDict error:nil];
        if (isShow) {
            
        }
        if (model.ret == 1001 || model.ret == 10086) {
            [SVProgressHUD dismiss];
        }else{
            if (isShow) {            
                [SVProgressHUD showErrorWithStatus:model.code];
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
        if (error.code != -999) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"%@",URLString);
            NSLog(@"%@",error.localizedDescription);
            if (failBlock) {
                failBlock(error);
            }
            [self endFailRefresh:scrollView];
        }
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


+(void)endSuccesRefresh:(UIScrollView *)scrollView
                  model:(CLNetworkModel *)model{
    
    if (scrollView) {
        if ([model.isNull isEqualToString:@"1"]) {
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
