//
//  UserInfoTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2023/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UITextField * content;

@end

NS_ASSUME_NONNULL_END
