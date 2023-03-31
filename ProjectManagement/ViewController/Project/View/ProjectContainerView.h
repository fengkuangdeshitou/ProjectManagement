//
//  ProjectContainerView.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectContainerView : UIView

/// 项目类型(1使用评测 2督导评测 3设计评估 null时查询全部)
@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) BOOL isPrivate;

@end

NS_ASSUME_NONNULL_END
