//
//  CLWebView.h
//  jsweb
//
//  Created by 朱成龙 on 2017/11/18.
//  Copyright © 2017年 朱成龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class CLWebView;

@protocol CLWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end

@interface CLWebView : UIView

typedef void (^getValueForJSFuncNameBlock) (NSArray * array);

@property (nonatomic,strong) id<CLWebViewDelegate> delegate;

@property (nonatomic,strong) UIWebView * webView;

@property (nonatomic,strong) NSString * webURL;

//接收js方法
-(void)getValueForJSFuncName:(NSString *)jsFuncName
                       block:(getValueForJSFuncNameBlock)block;
//发送js方法
-(void)setValueForJSFuncName:(NSString *)jsFuncName
                       array:(NSArray *)array;

@end
