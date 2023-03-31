//
//  ProjectDeleteAlertVIew.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectDeleteAlertView : UIView

+ (void)showDeleteAlertViewWithBlock:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
