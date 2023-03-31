//
//  ProjectDescTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import <UIKit/UIKit.h>
#import "UITextView+Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectDescTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UITextView * content;

@end

NS_ASSUME_NONNULL_END
