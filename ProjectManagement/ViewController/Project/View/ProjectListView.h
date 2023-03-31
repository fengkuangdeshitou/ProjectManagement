//
//  ProjectListView.h
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectListView : UIView

@property(nonatomic,strong) NSString * type;
/// 状态（0评测中 1审核中 2 审核通过 3 审核未通过  null时查询全部）
@property(nonatomic,strong) NSString * status;
@property(nonatomic,assign) BOOL isPrivate;

@end

NS_ASSUME_NONNULL_END
