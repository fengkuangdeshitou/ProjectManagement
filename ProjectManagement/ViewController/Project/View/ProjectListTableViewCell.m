//
//  ProjectListTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import "ProjectListTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "AllEvaluationViewController.h"

@interface ProjectListTableViewCell ()

@property(nonatomic,weak)IBOutlet UILabel * name;
@property(nonatomic,weak)IBOutlet UILabel * typeLabel;
@property(nonatomic,weak)IBOutlet UILabel * review;
@property(nonatomic,weak)IBOutlet UILabel * constructionUnit;
@property(nonatomic,weak)IBOutlet UILabel * source;
@property(nonatomic,weak)IBOutlet UILabel * status;
@property(nonatomic,weak)IBOutlet UILabel * groupNames;
@property(nonatomic,weak)IBOutlet UIButton * flag;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * nameLeft;
@property(nonatomic,weak)IBOutlet UIButton * detailBtn;
@property(nonatomic,weak)IBOutlet UIButton * evaluation;

@end

@implementation ProjectListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailBtn.layer.cornerRadius = 15;
    self.detailBtn.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR].CGColor;
    self.detailBtn.layer.borderWidth = 1;
}

- (IBAction)flagChange:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.model.isSelected = !self.model.isSelected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isPrivate){
        self.nameLeft.constant = 88;
        self.flag.hidden = false;
    }else{
        self.nameLeft.constant = 15;
        self.flag.hidden = true;
    }
}

- (void)setModel:(ProjectModel *)model{
    _model = model;
    self.typeLabel.text = model.classesNames;
    self.name.text = model.name;
    self.review.text = model.review;
    self.constructionUnit.text = model.constructionUnit;
    self.source.text = model.source.intValue == 0 ? @"后台创建" : @"App创建";
    if (model.status.intValue == 0){
        self.status.text = @"评测中";
        self.status.textColor = [UIColor colorWithHexString:@"#4878F4"];
    }else if (model.status.intValue == 1){
        self.status.text = @"审核中";
        self.status.textColor = [UIColor colorWithHexString:@"#E97331"];
    }else if (model.status.intValue == 2){
        self.status.text = @"已通过";
        self.status.textColor = [UIColor colorWithHexString:@"#27B557"];
    }else if (model.status.intValue == 3){
        self.status.text = @"未通过";
        self.status.textColor = [UIColor colorWithHexString:@"#EF3434"];
    }
    self.groupNames.text = model.groupNames;
    self.evaluation.hidden = model.status.intValue == 1 || model.status.intValue == 2;
    if (model.status.intValue == 0){
        [self.evaluation setTitle:@"去评测" forState:UIControlStateNormal];
    }else{
        [self.evaluation setTitle:@"再次评测" forState:UIControlStateNormal];
    }
}

- (IBAction)projectDetailAction:(id)sender{
    ProjectDetailViewController * detail = [[ProjectDetailViewController alloc] initWithId:self.model.Id];
    detail.title = @"项目详情";
    detail.hidesBottomBarWhenPushed = true;
    [UIHelper.currentViewController.navigationController pushViewController:detail animated:true];
}

- (IBAction)evaluationAction:(id)sender{
    AllEvaluationViewController * evaluation = [[AllEvaluationViewController alloc] init];
    evaluation.hidesBottomBarWhenPushed = true;
    evaluation.title = self.model.name;
    evaluation.projectId = self.model.Id;
    [UIHelper.currentViewController.navigationController pushViewController:evaluation animated:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
