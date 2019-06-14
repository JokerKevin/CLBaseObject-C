//
//  CLNetwork.h
//  Traveling
//
//  Created by 朱成龙 on 2018/11/15.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import "JSONModel/JSONModel.h"
#import <AFNetworking/AFNetworking.h>
#import <YYCache/YYCache.h>
#import "CLCategory.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN
@class CLNetworkModel;

typedef void (^CLFailBlock) (NSError * error);
typedef void (^CLSuccessBlock) (CLNetworkModel * successModel , NSDictionary * successDict , BOOL isCahe);

@interface CLNetwork : NSObject

/**
 POST 自动提示.
 */
+(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   scrollView:(UIScrollView *)scrollView
                      success:(CLSuccessBlock)successBlock
                         fail:(CLFailBlock)failBlock
                          end:(CLSuccessBlock)endBlock
                      isCache:(BOOL)isCache;

/**
 POST 不自动提示.
 */
+(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   scrollView:(UIScrollView *)scrollView
                      success:(CLSuccessBlock)successBlock
                         fail:(CLFailBlock)failBlock
                          end:(CLSuccessBlock)endBlock
                      isCache:(BOOL)isCache
                       isShow:(BOOL)isShow;

+(NSURLSessionDataTask *)POST:(NSString *)URLString
                       images:(NSArray *)images
                      success:(CLSuccessBlock)successBlock
                     progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress
                         fail:(CLFailBlock)failBlock;
@end

@class CLNetworkInfoModel;
@interface CLNetworkModel : JSONModel
@property(nonatomic,assign)NSInteger            state;
@property(nonatomic,copy)CLNetworkInfoModel <Optional> *         info;
//@property(nonatomic,copy)NSString <Optional> * isNull;
@end

@interface CLNetworkInfoModel : JSONModel
@property(nonatomic,copy)NSString <Optional> * message;
@property(nonatomic,copy)id <Optional> data;
@property(nonatomic,copy)NSString <Optional> * isNull;
@end
NS_ASSUME_NONNULL_END
