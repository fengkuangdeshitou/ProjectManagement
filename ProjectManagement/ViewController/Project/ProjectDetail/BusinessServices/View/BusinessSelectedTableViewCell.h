//
//  BusinessSelectedTableViewCell.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessSelectedTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;

@end

NS_ASSUME_NONNULL_END
