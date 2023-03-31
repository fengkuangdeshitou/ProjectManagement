//
//  ProjectDetailViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "ProjectDetailViewController.h"
#import "ProjectInfoTableViewCell.h"
#import "ProjectTagTableViewCell.h"
#import "ProjectDescTableViewCell.h"
#import "ProjectDetailFooterView.h"
#import "ProjectModel.h"

@interface ProjectDetailViewController ()<UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UILabel * nameLabel;
@property(nonatomic,strong) NSArray * dataArray;
@property(nonatomic,assign) CGFloat intrinsicContentHeight;
@property(nonatomic,strong) ProjectDetailFooterView * footerView;
@property(nonatomic,strong) NSString * Id;
@property(nonatomic,strong) ProjectModel * model;

@end

@implementation ProjectDetailViewController

- (instancetype)initWithId:(NSString *)Id{
    self = [super init];
    if (self) {
        self.Id = Id;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getProjectDetail];
}

- (ProjectDetailFooterView *)footerView{
    if (!_footerView){
        _footerView = [[ProjectDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.model.subentryClassesSecondLevelEvaluation.count*40+30)];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectInfoTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectTagTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDescTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDescTableViewCell class])];
}

- (void)getProjectDetail{
    [APIRequest.shareInstance getUrl:ProjectDetail params:@{@"projectId":self.Id} success:^(NSDictionary * _Nonnull result) {
        self.model = [ProjectModel mj_objectWithKeyValues:result[@"data"]];
        self.nameLabel.text = self.model.name;
        self.dataArray = @[
            @{@"title":@"项目类型",@"value":self.model.type.intValue == 1 ? @"使用评测" : (self.model.type.intValue == 2 ? @"督导评测" : @"设计评估"),@"type":@"info"},
            @{@"title":@"项目类别",@"value":self.model.classesNames,@"type":@"info"},
            @{@"title":@"项目二级类别",@"value":@"",@"type":@"info"},
            @{@"title":@"",@"value":@"",@"type":@"tag"},
            @{@"title":@"使用设施的残障人士类别",@"value":[self.model.groupList componentsJoinedByString:@","],@"type":@"info"},
            @{@"title":@"项目建设单位",@"value":self.model.constructionUnit?:@"",@"type":@"info"},
            @{@"title":@"项目地址",@"value":self.model.addressName,@"type":@"info"},
            @{@"title":@"项目联系人",@"value":self.model.contacts,@"type":@"info"},
            @{@"title":@"联系电话",@"value":self.model.phone,@"type":@"info"},
            @{@"title":@"项目综述",@"value":@"",@"type":@"info"},
            @{@"title":@"",@"value":self.model.review,@"type":@"desc"},
            @{@"title":@"项目分项类别",@"value":[self.model.subentryClassesList componentsJoinedByString:@","],@"type":@"info"},
            @{@"title":@"项目二级分项类别评测",@"value":@"",@"type":@"info"}
        ];
        self.footerView.subentryClassesSecondLevelEvaluation = self.model.subentryClassesSecondLevelEvaluation;
        self.footerView.detailModel = self.model;
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"info"]){
        ProjectInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectInfoTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.content.text = item[@"value"];
        return cell;
    }else if ([item[@"type"] isEqualToString:@"tag"]){
        ProjectTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectTagTableViewCell class]) forIndexPath:indexPath];
        __weak typeof(cell) weakCell = cell;
        cell.tagListViewFrameChange = ^{
            if (self.intrinsicContentHeight == 0){
                self.intrinsicContentHeight = weakCell.tagView.intrinsicContentSize.height;
                [UIView performWithoutAnimation:^{
                    [tableView beginUpdates];
                    [tableView endUpdates];
                }];
            }
        };
        cell.tags = self.model.classesSecondLevelList;
        return cell;
    }else{
        ProjectDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDescTableViewCell class]) forIndexPath:indexPath];
        cell.content.text = item[@"value"];
        cell.content.userInteractionEnabled = false;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"tag"]){
        return self.intrinsicContentHeight;
    }else if ([item[@"type"] isEqualToString:@"desc"]){
        return 82;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.model && self.model.subentryClassesSecondLevelEvaluation.count > 0){
        return self.footerView.height;
    }else{
        return 0.01;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
