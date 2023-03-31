//
//  UIHelper.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "UIHelper.h"

@implementation UIHelper

+ (UIViewController *)jsd_getRootViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)currentViewController{
    UIViewController* currentViewController = [self jsd_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}

+ (void)showToast:(NSString *)toast toView:(UIView *)view{
    [view makeToast:toast duration:1.5 position:@"center"];
}

+ (BOOL)checkTextField:(UITextField *)textField toast:(nullable NSString *)toast{
    if (textField.text.length == 0){
        [self showToast:toast?:textField.placeholder toView:UIApplication.sharedApplication.keyWindow];
        return false;
    }
    return true;
}

@end
