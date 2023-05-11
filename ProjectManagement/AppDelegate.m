//
//  AppDelegate.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[BMKLocationAuth sharedInstance] setAgreePrivacy:YES];
    [BMKMapManager setAgreePrivacy:YES];

    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"urhw5P2HpeS0cTBTKfG1T9ayCAOYGEuT" authDelegate:self];
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"urhw5P2HpeS0cTBTKfG1T9ayCAOYGEuT"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loadTabbarController) name:Login_NOTIFICATION object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loadLoginViewController) name:Logout_NOTIFICATION object:nil];
    if ([NSUserDefaults.standardUserDefaults objectForKey:TOKEN]){
        [self loadTabbarController];
    }else{
        [self loadLoginViewController];
    }
    return YES;
}

- (void)loadLoginViewController{
    LoginViewController * login = [[LoginViewController alloc] init];
    NavigationViewController * nav = [[NavigationViewController alloc] initWithRootViewController:login];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)loadTabbarController{
    TabbarViewController * tabbar = [[TabbarViewController alloc] init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
}

@end
