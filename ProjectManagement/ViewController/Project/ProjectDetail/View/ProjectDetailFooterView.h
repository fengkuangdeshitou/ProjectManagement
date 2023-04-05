//
//  ProjectDetailFooterView.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/1.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectDetailFooterView : UIView

@property(nonatomic,strong) NSArray<ProjectModel*> * subentryClassesSecondLevelEvaluation;
@property(nonatomic,strong) ProjectModel * detailModel;
@property(nonatomic,copy)void(^addCompletion)(void);

@end

NS_ASSUME_NONNULL_END
