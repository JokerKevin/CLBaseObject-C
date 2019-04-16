//
//  CLWebView.m
//  jsweb
//
//  Created by 朱成龙 on 2017/11/18.
//  Copyright © 2017年 朱成龙. All rights reserved.
//

#import "CLWebView.h"
#import <Masonry.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface CLWebView()<UIWebViewDelegate>
typedef void (^didFinishBlock) (CLWebView * webview);
@property (nonatomic,strong) NSMutableArray * blockArray;
@property (nonatomic,strong) JSContext * jsContext;

@end

@implementation CLWebView
-(instancetype)init{
    if (self = [super init]) {
        [self webLayout];

    }
    return self;
}
-(instancetype)initWithURL:(NSString *)url{
    if (self = [super init]) {
        _webURL = url;
        [self webLayout];
    }
    return self;
}
-(void)webLayout{
    _blockArray = [NSMutableArray array];
    
    _webView = [[UIWebView alloc]init];
    
    [self addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    
    _webView.delegate = self;

    if (_webURL) {
        
        NSLog(@"%@",_webURL);
        
        self.webURL = _webURL;
    }
}
-(void)setWebURL:(NSString *)webURL{
    
    NSLog(@"%@",_webURL);
    
    _webURL = webURL;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    });
}
#pragma mark - delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"JSCallOCModelObject"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };

    for ( int i = 0 ; i < _blockArray.count; ++i) {
        didFinishBlock block = _blockArray[i];
        if (block) {
            block(self);
        }
    }
    @try {
        [_delegate webViewDidFinishLoad:webView];
    } @catch (NSException *exception) {
        
    }

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    @try {
        return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } @catch (NSException *exception) {
        return YES;
    }
}
#pragma mark - JS
-(void)getValueForJSFuncName:(NSString *)jsFuncName
                       block:(getValueForJSFuncNameBlock)block{
    didFinishBlock blcok = ^(CLWebView *webview) {
        webview.jsContext[jsFuncName] = ^() {
            block([JSContext currentArguments]);
        };
    };
    [_blockArray addObject:blcok];
}
-(void)setValueForJSFuncName:(NSString *)jsFuncName
                       array:(NSArray *)array{
    JSValue *ocInvokeJs = self.jsContext[jsFuncName];
    [ocInvokeJs callWithArguments:array];
}

@end
