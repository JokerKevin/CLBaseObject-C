//
//  ViewController.m
//  kd
//
//  Created by 朱成龙 on 2017/11/23.
//  Copyright © 2017年 朱成龙. All rights reserved.
//

#import "CLViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
@interface CLViewController ()

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.fd_prefersNavigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void)pushViewControllerString:(NSString *)viewcontrollerString{
    [self.navigationController pushViewController:[[[NSClassFromString(viewcontrollerString) class] alloc]init] animated:YES];
}

-(void)pushViewControllerVC:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
