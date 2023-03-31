//
//  UIHelper.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import <Foundation/Foundation.h>
#import "Toast+UIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIHelper : NSObject

+ (UIViewController *)currentViewController;

+ (void)showToast:(NSString *)toast toView:(UIView *)view;

+ (BOOL)checkTextField:(UITextField *)textField toast:(nullable NSString *)toast;

@end

NS_ASSUME_NONNULL_END
