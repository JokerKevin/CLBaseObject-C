//
//  NSObject+CLCategory.h
//  CLBaseObject-C
//
//  Created by 朱成龙 on 2019/4/16.
//  Copyright © 2019 Zhucl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLCategory)
///加密.
-(NSString *)encryptUseDES;
///解密.
-(NSString *)decryptUseDES;
///时间字符串转NSDate.
-(NSDate *)datefromTimeString;
///时间字符串转时间戳字符串.
-(NSString *)timestampfromTimeString;
///金钱显示(每三个字一个逗号).
-(NSString *)moneyType;
///是否数字.
-(BOOL)isNumber;
@end

@interface UIColor (CLCategory)
///获取随机颜色.
#define CLRandomColor CLColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
///根据rgba获取颜色.
#define CLColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
///根据十六进制获取颜色.
+(UIColor *)hex:(int)hex;
@end

@interface UILabel (CLCategory)
///计算字体大小.
-(CGSize)calc;
@end

@interface UIWindow (CLCategory)
- (UIViewController *) visibleViewController;
@end

@interface UIApplication (CLCategory)
///push方法.
#define pushViewControllerClassName(className) [[UIApplication shareViewController].navigationController pushViewController:[[[NSClassFromString(viewcontrollerString) class] alloc]init] animated:YES]
///push方法.
#define pushViewControllerClass(class) [[UIApplication shareViewController].navigationController pushViewController:class animated:YES]
///获取AppDelegate.
+(AppDelegate *)shareAppDelegate;
///获取当前ViewController.
+(UIViewController *)shareViewController;
@end

@interface UIViewController (CLCategory)

@end

NS_ASSUME_NONNULL_END
