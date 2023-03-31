//
//  SelectTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.textField.placeholder.length > 0){
        NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:self.textField.placeholder];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9EA6BB"] range:NSMakeRange(0, self.textField.placeholder.length)];
        self.textField.attributedPlaceholder = attri;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
