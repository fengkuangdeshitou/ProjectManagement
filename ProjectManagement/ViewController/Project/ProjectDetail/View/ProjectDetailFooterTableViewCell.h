//
//  ProjectDetailFooterTableViewCell.h
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectDetailFooterTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * content;
@property(nonatomic,weak)IBOutlet UIImageView * more;

@end

NS_ASSUME_NONNULL_END
