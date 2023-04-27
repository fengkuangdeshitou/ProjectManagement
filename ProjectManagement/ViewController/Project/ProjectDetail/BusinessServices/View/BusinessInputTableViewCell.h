//
//  BusinessInputTableViewCell.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessInputTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UITextField * textfield;

@end

NS_ASSUME_NONNULL_END
