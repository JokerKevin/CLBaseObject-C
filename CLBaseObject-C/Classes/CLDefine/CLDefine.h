//
//  CLDefine.m
//  CLBaseObject-C
//
//  Created by 朱成龙 on 2019/4/16.
//  Copyright © 2019 Zhucl. All rights reserved.
//

#import <Foundation/Foundation.h>
///获取导航栏高度.
#define CLNavBarHeight AppDelegate.shareViewController.navigationController.navigationBar.frame.size.height
///获取状态栏高度.
#define CLStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
///获取顶部高度.
#define CLTopHeight (CLNavBarHeight + CLStatusBarHeight)
///获取底部高度.
#define CLBottomHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

