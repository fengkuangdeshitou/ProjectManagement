//
//  UserInfoViewController.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoViewController : BaseViewController

@property(nonatomic,strong) NSDictionary * user;
@property(nonatomic,assign) BOOL isEdit;
@property(nonatomic,copy) void (^updateInfoCompletion)(void);

@end

NS_ASSUME_NONNULL_END
