//
//  ProjectListView.m
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import "ProjectListView.h"
#import "ProjectListTableViewCell.h"
#import "ProjectModel.h"
#import "ProjectDeleteAlertView.h"
@import MJRefresh;

@interface ProjectListView ()<UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong) NSMutableArray<ProjectModel*> * dataArray;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) NSString * classesId;
@property(nonatomic,strong) NSString * classesSecondLevelId;
@property(nonatomic,strong) NSString * subentryClassesId;
@property(nonatomic,strong) NSString * subentryClassesSecondLevelId;

@end

@implementation ProjectListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.frame = frame;
        self.tableView.rowHeight = 297;
        [NSNotificationCenter.defaultCenter addObserverForName:Delete_Project_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSArray * deleteArray = [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = TRUE"]];
            if (deleteArray.count > 0){
                NSMutableArray * idArray = [[NSMutableArray alloc] init];
                [deleteArray enumerateObjectsUsingBlock:^(ProjectModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [idArray addObject:obj.Id];
                }];
                [APIRequest.shareInstance deleteUrl:RemoveProject params:@{@"projectId":[idArray componentsJoinedByString:@","]} success:^(NSDictionary * _Nonnull result) {
                    for (int i=0; i<self.dataArray.count; i++) {
                        if ([idArray componentsJoinedByString:self.dataArray[i].Id]){
                            [self.dataArray removeObjectAtIndex:i];
                        }
                    }
                    [self.tableView reloadData];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:Add_Project_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.page = 0;
            [self getProjectList];
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:Select_Project_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSArray * deleteArray = [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = TRUE"]];
            if (deleteArray.count == 0){
                [UIHelper showToast:@"请先选择项目" toView:self];
            }else{
                [ProjectDeleteAlertView showDeleteAlertViewWithBlock:^{
                    [NSNotificationCenter.defaultCenter postNotificationName:Delete_Project_NOTIFICATION object:nil];
                }];
            }
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:Update_Project_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSString * projectId = note.object;
            for (ProjectModel * model in self.dataArray) {
                if (model.projectId.intValue == projectId.intValue){
                    model.status = @"1";
                }
            }
            [self.tableView reloadData];
        }];
        [NSNotificationCenter.defaultCenter addObserverForName:Filter_Project_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSDictionary * ojb = note.object;
            self.classesId = ojb[@"classesId"];
            self.classesSecondLevelId = ojb[@"classesSecondLevelId"];
            self.subentryClassesId = ojb[@"subentryClassesId"];
            self.subentryClassesSecondLevelId = ojb[@"subentryClassesSecondLevelId"];
            self.page = 0;
            [self getProjectList];
        }];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectListTableViewCell class])];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self getProjectList];
        }];
    }
    return self;
}

- (void)setStatus:(NSString *)status{
    _status = status;
    [self getProjectList];
}

- (void)getProjectList{
    [APIRequest.shareInstance getUrl:PcProjectList params:
         @{@"type":self.type,
           @"status":self.status.intValue < 0 ? [NSNull null] : self.status,
           @"classesId":self.classesId?:@"",
           @"classesSecondLevelId":self.classesSecondLevelId?:@"",
           @"subentryClassesId":self.subentryClassesId?:@"",
           @"subentryClassesSecondLevelId":self.subentryClassesSecondLevelId?:@""} success:^(NSDictionary * _Nonnull result) {
        NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.page == 0){
            self.dataArray = [[NSMutableArray alloc] initWithArray:modelArray];
        }else{
            [self.dataArray addObjectsFromArray:modelArray];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectListTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    cell.isPrivate = self.isPrivate;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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
