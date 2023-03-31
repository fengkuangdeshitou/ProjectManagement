//
//  ContentTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/2.
//

#import <UIKit/UIKit.h>
#import "ProjectDescTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,strong) ProjectDescTableViewCell * descCell;

@end

NS_ASSUME_NONNULL_END
