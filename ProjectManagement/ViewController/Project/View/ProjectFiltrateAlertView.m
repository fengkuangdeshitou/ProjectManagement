//
//  ProjectFiltrateAlertView.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "ProjectFiltrateAlertView.h"
#import "ProjectTagTableViewCell.h"
#import "ProjectModel.h"

@interface ProjectFiltrateAlertView ()<UITableViewDelegate,TagListViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong) NSArray * projectArray;
@property(nonatomic,strong) NSArray * projectSecondArray;
@property(nonatomic,strong) NSArray * projectSubentryArray;
@property(nonatomic,strong) NSArray * projectSubentrySecondArray;

@property(nonatomic,strong) NSString * classesId;
@property(nonatomic,strong) NSString * classesSecondLevelId;
@property(nonatomic,strong) NSString * subentryClassesId;
@property(nonatomic,strong) NSString * subentryClassesSecondLevelId;


@end

@implementation ProjectFiltrateAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.frame = frame;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectTagTableViewCell class])];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.projectArray = @[];
        self.projectSecondArray = @[];
        self.projectSubentryArray = @[];
        self.projectSubentrySecondArray = @[];
        [self getPcProjectClassesData];
        [self getPcProjectSubentryData];
    }
    return self;
}

- (IBAction)resetAction:(id)sender{
    for (ProjectTagTableViewCell * cell in self.tableView.visibleCells) {
        for (TagView * view in cell.tagView.tagViews) {
            view.selected = false;
        }
    }
    self.classesId = nil;
    self.classesSecondLevelId = nil;
    self.subentryClassesId = nil;
    self.subentryClassesSecondLevelId = nil;
    NSDictionary * obj = @{
        @"classesId":@"",
        @"classesSecondLevelId":@"",
        @"subentryClassesId":@"",
        @"subentryClassesSecondLevelId":@""
    };
    [NSNotificationCenter.defaultCenter postNotificationName:Filter_Project_NOTIFICATION object:obj];
    [self dismissAction];
}

- (IBAction)submitAction:(id)sender{
    NSDictionary * obj = @{
        @"classesId":self.classesId?:@"",
        @"classesSecondLevelId":self.classesSecondLevelId?:@"",
        @"subentryClassesId":self.subentryClassesId?:@"",
        @"subentryClassesSecondLevelId":self.subentryClassesSecondLevelId?:@""
    };
    [NSNotificationCenter.defaultCenter postNotificationName:Filter_Project_NOTIFICATION object:obj];
    [self dismissAction];
}

- (void)getPcProjectClassesData{
    [APIRequest.shareInstance getUrl:PcProjectClasses params:@{} success:^(NSDictionary * _Nonnull result) {
        self.projectArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.projectArray.count > 0){
            ProjectModel * model = self.projectArray.firstObject;
            [self getPcProjectClassesSecondLevelWithClassesId:model.Id];
        }
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getPcProjectClassesSecondLevelWithClassesId:(NSString *)classesId{
    [APIRequest.shareInstance getUrl:PcProjectClassesSecondLevel params:@{@"classesId":classesId} success:^(NSDictionary * _Nonnull result) {
        self.projectSecondArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getPcProjectSubentryData{
    [APIRequest.shareInstance getUrl:PcProjectSubentry params:@{} success:^(NSDictionary * _Nonnull result) {
        self.projectSubentryArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.projectSubentryArray.count > 0){
            ProjectModel * model = self.projectSubentryArray.firstObject;
            [self getPcProjectSubentrySecondLevelWithSubentryClassesId:model.Id];
        }
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getPcProjectSubentrySecondLevelWithSubentryClassesId:(NSString *)subentryClassesId{
    [APIRequest.shareInstance getUrl:PcProjectSubentrySecondLevel params:@{@"subentryClassesId":subentryClassesId} success:^(NSDictionary * _Nonnull result) {
        self.projectSubentrySecondArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)dismissAction{
    if (self.onTagBlock){
        self.onTagBlock();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]){
        return true;
    }
    return false;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectTagTableViewCell class]) forIndexPath:indexPath];
    cell.tagView.delegate = self;
    cell.tagView.tag = indexPath.section;
    NSArray * array = @[self.projectArray,self.projectSecondArray,self.projectSubentryArray,self.projectSubentrySecondArray];
    cell.tags = array[indexPath.section];
    return cell;
}

- (void)tagPressed:(NSString *)title tagView:(TagView *)tagView sender:(TagListView *)sender{
    if (sender.tag == 0){
        for (TagView * view in sender.tagViews) {
            view.selected = false;
        }
        tagView.selected = !tagView.selected;
        self.classesId = [self getIdForTitle:title array:self.projectArray];
        [self getPcProjectClassesSecondLevelWithClassesId:[self getIdForTitle:title array:self.projectArray]];
    }else if (sender.tag == 1){
        tagView.selected = !tagView.selected;
        NSMutableArray * idArrray = [[NSMutableArray alloc] init];
        for (TagView * view in sender.tagViews) {
            if (view.selected){
                [idArrray addObject:[self getIdForTitle:title array:self.projectArray]];
            }
        }
        self.classesSecondLevelId = [idArrray componentsJoinedByString:@","];
    }
    else if (sender.tag == 2){
        tagView.selected = !tagView.selected;
        NSMutableArray * idArrray = [[NSMutableArray alloc] init];
        for (TagView * view in sender.tagViews) {
            if (view.selected){
                [idArrray addObject:[self getIdForTitle:title array:self.projectArray]];
            }
        }
        self.subentryClassesId = [idArrray componentsJoinedByString:@","];
        [self getPcProjectSubentrySecondLevelWithSubentryClassesId:[self getIdForTitle:title array:self.projectSubentryArray]];
    }else{
        tagView.selected = !tagView.selected;
        NSMutableArray * idArrray = [[NSMutableArray alloc] init];
        for (TagView * view in sender.tagViews) {
            if (view.selected){
                [idArrray addObject:[self getIdForTitle:title array:self.projectArray]];
            }
        }
        self.subentryClassesSecondLevelId = [idArrray componentsJoinedByString:@","];
    }
}

- (NSString *)getIdForTitle:(NSString *)title array:(NSArray *)array{
    for (ProjectModel * model in array) {
        if ([model.name isEqualToString:title]){
            return model.Id;
        }
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = @[self.projectArray,self.projectSecondArray,self.projectSubentryArray,self.projectSubentrySecondArray];
    return [array[section] count] > 0 ? 1 : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (section == 1 || section == 3) ? 60 : 72)];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.clipsToBounds = true;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width-30, headerView.height)];
    if (section == 1 || section == 3){
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        titleLabel.text = section == 1 ? @"项目二级类别" : @"项目分类二级类别";
    }else{
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        titleLabel.text = section == 0 ? @"项目类别" : @"项目分类类别";
    }
    titleLabel.textColor = UIColor.blackColor;
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((section == 0 && self.projectArray.count > 0) || (section == 2 && self.projectSubentryArray.count > 0)){
        return 72;
    }else if ((section == 1 && self.projectSecondArray.count > 0 )|| (section == 3 && self.projectSubentrySecondArray.count > 0)){
        return 60;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3){
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        footer.backgroundColor = UIColor.whiteColor;
        return footer;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 3 ? 30 : 0.01;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
