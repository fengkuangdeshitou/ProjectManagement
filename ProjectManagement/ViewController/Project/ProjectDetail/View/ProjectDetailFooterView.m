//
//  ProjectDetailFooterView.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/1.
//

#import "ProjectDetailFooterView.h"
#import "ProjectDetailFooterTableViewCell.h"
#import "BusinessServicesViewController.h"

@interface ProjectDetailFooterView ()<UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;

@end

@implementation ProjectDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.frame = frame;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDetailFooterTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDetailFooterTableViewCell class])];
    }
    return self;
}

- (void)setSubentryClassesSecondLevelEvaluation:(NSArray<ProjectModel *> *)subentryClassesSecondLevelEvaluation{
    _subentryClassesSecondLevelEvaluation = subentryClassesSecondLevelEvaluation;
    self.height = subentryClassesSecondLevelEvaluation.count*40+30;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectDetailFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDetailFooterTableViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = self.subentryClassesSecondLevelEvaluation[indexPath.row].name;
    if (self.subentryClassesSecondLevelEvaluation[indexPath.row].evaluation){
        cell.content.text = @"已填写";
        cell.content.textColor = [UIColor colorWithHexString:@"#4878F4"];
    }else{
        cell.content.text = @"去填写";
        cell.content.textColor = [UIColor colorWithHexString:@"#F8354C"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessServicesViewController * service = [[BusinessServicesViewController alloc] init];
//    service.model = self.subentryClassesSecondLevelEvaluation[indexPath.row].evaluation;
    service.title = self.subentryClassesSecondLevelEvaluation[indexPath.row].name;
    service.subentryClassesSecondLevel = self.subentryClassesSecondLevelEvaluation[indexPath.row].Id;
    service.detailModel = self.detailModel;
    service.addCompletion = ^{
        [tableView reloadData];
        if (self.addCompletion){
            self.addCompletion();
        }
    };
    [UIHelper.currentViewController.navigationController pushViewController:service animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subentryClassesSecondLevelEvaluation.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return UIView.new;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
