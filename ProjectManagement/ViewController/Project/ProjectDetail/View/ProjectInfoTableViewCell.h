//
//  ProjectInfoTableViewCell.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectInfoTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * content;

@end

NS_ASSUME_NONNULL_END
