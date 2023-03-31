//
//  ProjectTagTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "ProjectTagTableViewCell.h"
#import "ProjectModel.h"

@implementation ProjectTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagView.textFont = [UIFont systemFontOfSize:14];
}

- (void)setTags:(NSArray *)tags{
    _tags = tags;
    [self.tagView removeAllTags];
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]){
            [self.tagView addTag:obj];
        }else if ([obj isKindOfClass:[ProjectModel class]]){
            [self.tagView addTag:((ProjectModel*)obj).name];
        }
    }];
    if (self.tagListViewFrameChange){
        self.tagListViewFrameChange();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
