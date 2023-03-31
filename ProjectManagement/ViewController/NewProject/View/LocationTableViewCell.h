//
//  LocationTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2023/3/31.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet MLPAutoCompleteTextField * textField;
@property(nonatomic,weak)IBOutlet UIButton * btn;

@end

NS_ASSUME_NONNULL_END
