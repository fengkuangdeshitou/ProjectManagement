//
//  BusinessIntervalTableViewCell.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessIntervalTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * value1;
@property(nonatomic,weak)IBOutlet UILabel * value2;
@property(nonatomic,weak)IBOutlet UITextField * textfield1;
@property(nonatomic,weak)IBOutlet UITextField * textfield2;

@end

NS_ASSUME_NONNULL_END
