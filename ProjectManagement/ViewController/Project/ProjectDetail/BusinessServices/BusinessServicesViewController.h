//
//  BusinessServicesViewController.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "BaseViewController.h"
#import "ProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessServicesViewController : BaseViewController

@property(nonatomic,strong) NSString * subentryClassesSecondLevel;
@property(nonatomic,strong) ProjectModel * detailModel;
@property(nonatomic,copy)void(^addCompletion)(void);

@end

NS_ASSUME_NONNULL_END
