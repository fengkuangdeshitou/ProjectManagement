//
//  ProjectFiltrateAlertView.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectFiltrateAlertView : UIView

@property(nonatomic,copy)void(^onTagBlock)(void);

@end

NS_ASSUME_NONNULL_END
