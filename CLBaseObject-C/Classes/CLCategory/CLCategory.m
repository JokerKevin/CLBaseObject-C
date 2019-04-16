//
//  NSObject+CLCategory.m
//  CLBaseObject-C
//
//  Created by 朱成龙 on 2019/4/16.
//  Copyright © 2019 Zhucl. All rights reserved.
//

#import "CLCategory.h"
#import "CommonCrypto/CommonDigest.h"
#import "CommonCrypto/CommonCryptor.h"
#import "Base64.h"
#import "objc/runtime.h"

@implementation NSString (CLCategory)
const NSString *key = @"00000000";
const NSString *password = @"00000000";

-(NSString *)encryptUseDES{
    NSData* ivData = [password dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *ciphertext = nil;
    NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[dataLength + ivData.length];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [textData bytes], dataLength,
                                          buffer, dataLength + ivData.length,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedString];
    }
    return ciphertext;
}
-(NSString *)decryptUseDES{
    NSData * ivData = [password dataUsingEncoding: NSUTF8StringEncoding];
    Byte * ivBytes = (Byte *)[ivData bytes];
    NSString * plaintext = nil;
    NSData * cipherdata = [self base64DecodedData];
    unsigned char buffer[ivData.length + cipherdata.length];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,kCCAlgorithmDES,kCCOptionPKCS7Padding,[key UTF8String], kCCKeySizeDES,ivBytes,[cipherdata bytes],[cipherdata length],buffer, ivData.length + cipherdata.length,&numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}
-(NSDate *)datefromTimeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:self];
}
-(NSString *)timestampfromTimeString{
    NSInteger timeSp = [[NSNumber numberWithDouble:[[self datefromTimeString]  timeIntervalSince1970]] integerValue];
    
    NSString * timeStr = [NSString stringWithFormat:@"%ld",(long)timeSp];
    
    return timeStr;
}
-(NSString *)moneyType{
    int count = 0;
    long long int a = self.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
-(BOOL)isNumber{
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}
@end

@implementation UIColor (CLCategory)
+(UIColor *)hex:(int)hex{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
@end

@implementation UILabel (CLCategory)

-(CGSize)calc{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.font.pointSize + 0.5]};
    CGSize size=[self.text sizeWithAttributes:attrs];
    return size;
}
@end

@implementation UIWindow (CLCategory)
- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end

@implementation UIApplication (CLCategory)
//+(AppDelegate *)shareAppDelegate{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}
//
//+(UIViewController * )shareViewController{
//    return [[self shareAppDelegate].window visibleViewController];
//}
@end

@implementation UIViewController (CLCategory)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [self swizzled_swizzleMethod:class originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(swizzled_viewDidAppear:)];
        [self swizzled_swizzleMethod:class originalSelector:@selector(viewWillDisappear:) swizzledSelector:@selector(endKeyboard_viewWillDisAppear:)];
    });
}

//在viewDidAppear 时打印控制器名 // 未来可以添加页面统计跟其他在viewWillAppear等操作
- (void)swizzled_viewDidAppear:(BOOL)animated
{
    [self swizzled_viewDidAppear:animated];
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"UI"] ||[className hasPrefix:@"Nav"] || [className hasPrefix:@"Base"]) {
        return;
    }
    
    NSLog(@"%@", NSStringFromClass([self class]));
}

//控制器消失时关闭所有键盘 用IQkeyboar一定要用这个，键盘不消失会引起页面上浮
-(void)endKeyboard_viewWillDisAppear:(BOOL) animated
{
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"UI"]) {
        return;
    }
    [self endKeyboard_viewWillDisAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

+ (void)swizzled_swizzleMethod:(Class)cls originalSelector:(SEL)originalSel swizzledSelector:(SEL)swizzledSel {
    Class class = cls;
    SEL originalSelector = originalSel;
    SEL swizzledSelector = swizzledSel;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding   (originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
