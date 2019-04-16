//
//  CLNetwork.h
//  Traveling
//
//  Created by 朱成龙 on 2018/11/15.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <AFNetworking.h>
#import <YYCache.h>

@class CLNetworkModel;

NS_ASSUME_NONNULL_BEGIN
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
@end

@interface CLNetworkModel : JSONModel
@property(nonatomic,assign)NSInteger            ret;
@property(nonatomic,copy)NSString <Optional>    * code;
@property(nonatomic,copy)id <Optional>          data;
@property(nonatomic,copy)NSString <Optional> * isNull;
@end

NS_ASSUME_NONNULL_END
