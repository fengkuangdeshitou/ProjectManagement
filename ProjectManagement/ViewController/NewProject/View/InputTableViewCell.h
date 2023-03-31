//
//  InputTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UITextField * textField;

@end

NS_ASSUME_NONNULL_END
