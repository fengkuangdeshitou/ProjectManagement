//
//  GlobalConstant.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define StatusBarHeight   [UIApplication sharedApplication].statusBarFrame.size.height
#define NavagationHeight (StatusBarHeight + NavagationBarHeight)
#define TabbarHeight (StatusBarHeight == 20 ? 49 : (49+34))
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height

@interface GlobalConstant : NSObject

extern CGFloat const NavagationBarHeight;

extern NSString * const COLOR_MAIN_COLOR;

extern NSString * const TOKEN;


extern NSString * const Login_NOTIFICATION;

extern NSString * const Logout_NOTIFICATION;

extern NSString * const Add_Project_NOTIFICATION;

extern NSString * const Delete_Project_NOTIFICATION;

extern NSString * const Update_Project_NOTIFICATION;

extern NSString * const Select_Project_NOTIFICATION;

extern NSString * const Filter_Project_NOTIFICATION;

@end

NS_ASSUME_NONNULL_END
