//
//  AuditTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "AuditTableViewCell.h"

@interface AuditTableViewCell()

@property(nonatomic,weak)IBOutlet UILabel * projectName;
@property(nonatomic,weak)IBOutlet UILabel * createTime;
@property(nonatomic,weak)IBOutlet UILabel * submissionTime;
@property(nonatomic,weak)IBOutlet UILabel * result;
@property(nonatomic,weak)IBOutlet UILabel * cause;

@end

@implementation AuditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.projectName.text = model[@"projectName"];
    self.result.text = [model[@"result"] intValue] == 0 ? @"审核不通过" : ([model[@"result"] intValue] == 1 ? @"审核通过" : @"正在审核");
    if ([model[@"result"] intValue] == 2){
        self.createTime.text = @"";
        self.submissionTime.text = [model[@"createTime"] isEqual:[NSNull null]] ? @"" : model[@"createTime"];
    }else{
        self.createTime.text = [model[@"createTime"] isEqual:[NSNull null]] ? @"" : model[@"createTime"];
        self.submissionTime.text = [model[@"submissionTime"] isEqual:[NSNull null]] ? @"" : model[@"submissionTime"];
    }
    self.result.textColor = [UIColor colorWithHexString:[model[@"result"] intValue] == 1 ? @"#27B557" : @"#EF3434"];
    self.cause.text = [model[@"cause"] isEqual:[NSNull null]] ? @" " : model[@"cause"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
