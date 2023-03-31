//
//  ProjectListTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectListTableViewCell : UITableViewCell

@property(nonatomic,strong) ProjectModel * model;
@property(nonatomic,assign) BOOL isPrivate;

@end

NS_ASSUME_NONNULL_END
