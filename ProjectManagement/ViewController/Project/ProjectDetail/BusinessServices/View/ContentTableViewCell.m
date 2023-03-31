//
//  ContentTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/2.
//

#import "ContentTableViewCell.h"

@implementation ContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.descCell = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([ProjectDescTableViewCell class]) owner:nil options:nil].firstObject;
    [self.contentView addSubview:self.descCell];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.descCell.frame = CGRectMake(0, 50, SCREEN_WIDTH, self.height-50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
