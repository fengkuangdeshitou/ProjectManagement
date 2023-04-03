//
//  BusinessServicesViewController.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "BusinessServicesViewController.h"
#import "ImagesTableViewCell.h"
#import "ContentTableViewCell.h"
@import BRPickerView;
#import "BusinessFooterView.h"
#import "MultipleSelectionView.h"

@interface BusinessServicesViewController ()<UITextViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UILabel * address;
@property(nonatomic,weak)IBOutlet UIButton * selectBtn;
@property(nonatomic,weak)IBOutlet UIButton * normalBtn;

@property(nonatomic,assign) CGFloat beforHeight;
@property(nonatomic,assign) CGFloat afterHeight;
@property(nonatomic,strong) NSArray<ProjectModel*> * pcProjectEvaluationBasis;
@property(nonatomic,strong) NSArray<ProjectModel*> * pcProjectEvaluationSituation;
@property(nonatomic,assign) NSInteger abarbeitung;
@property(nonatomic,assign) NSInteger type;

@property(nonatomic,strong) NSArray * befor;
@property(nonatomic,strong) NSArray * after;
@property(nonatomic,strong) BusinessFooterView * footer;
@property(nonatomic,strong) NSArray<ProblemModel *> * problemArray;

@end

@implementation BusinessServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.type = self.detailModel.type.integerValue;
    if (!self.model){
        self.model = [[ProjectModel alloc] init];
        self.model.type = [NSString stringWithFormat:@"%ld",self.type];
    }
    self.model.projectId = self.detailModel.Id;
    self.model.subentryClassesSecondLevelId = self.detailModel.subentryClassesSecondLevelId;

    self.address.text = self.detailModel.addressName;
    self.beforHeight = (SCREEN_WIDTH-60)/3;
    self.afterHeight = self.beforHeight;
    if (self.type == 3){
        self.tableView.tableHeaderView.height = 0.01;
        self.tableView.tableHeaderView.clipsToBounds = true;
    }else{
        self.tableView.tableHeaderView.height = 55;
        self.tableView.tableHeaderView.clipsToBounds = true;
    }
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImagesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImagesTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ContentTableViewCell class])];
    [self getEvaluatingDetails];
    [self getBasisListToProjectData];
}

- (void)getEvaluatingDetails{
    [APIRequest.shareInstance getUrl:EvaluatingDetails params:@{@"projectId":self.detailModel.Id,@"subentryId":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
        
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getBasisListToProjectData{
    [APIRequest.shareInstance getUrl:BasisListToProject params:@{@"projectId":self.detailModel.Id,@"subentryId":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
        NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        NSString * basisContent = @"";
        NSMutableArray * idArray = [[NSMutableArray alloc] init];
        if (modelArray.count > 0){
            for (int i=0; i<modelArray.count; i++) {
                ProjectModel * model = modelArray[i];
                basisContent = [NSString stringWithFormat:@"%@%@-%@\n%@\n\n",basisContent,model.name,model.serialNumber,model.content];
                [idArray addObject:model.Id];
            }
            basisContent = [basisContent substringToIndex:basisContent.length-1];
            self.model.basisContent = basisContent;
            self.model.basisId = [idArray componentsJoinedByString:@","];
            [self.tableView reloadData];
            [self getProblemArrayWithBasisIds:self.model.basisId];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (IBAction)rectificationChangeAction:(UIButton *)sender{
    if (sender.selected){
        return;
    }
    self.normalBtn.selected = !self.normalBtn.selected;
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBtn.selected){
        self.abarbeitung = 1;
    }else{
        self.abarbeitung = 0;
    }
    [self.tableView reloadData];
}

- (void)uploadImages:(NSArray *)images completion:(void(^)(NSString *))completion{
    [APIRequest.shareInstance postUrl:Uploads params:@{} images:images success:^(NSDictionary * _Nonnull result) {
        completion(result[@"fileNames"]);
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)uploadParamsData{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:[self.model mj_JSONObject]];
    [params removeObjectForKey:@"subentryClassesSecondLevelId"];
    [params removeObjectForKey:@"id"];
    [params setValue:self.subentryClassesSecondLevel forKey:@"subentryClassesSecondLevel"];
    [APIRequest.shareInstance postUrl:EvaluationAdd params:params success:^(NSDictionary * _Nonnull result) {
        [UIHelper showToast:@"提交成功" toView:self.view];
        if (self.addCompletion){
            self.addCompletion([ProjectModel mj_objectWithKeyValues:params]);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
    } failure:^(NSString * _Nonnull errorMsg) {

    }];
}

- (IBAction)submitAction:(id)sender{
//    NSLog(@"%@",[self.model mj_JSONObject]);
    if (self.type == 1){
        self.model.abarbeitung = self.selectBtn.selected ? @"1" : @"0";
        if (self.selectBtn.selected){
            if (self.befor.count == 0){
                [UIHelper showToast:@"请添加整改前照片" toView:self.view];
                return;
            }
            if (self.model.conditionContent.length == 0){
                [UIHelper showToast:@"请输入评测情况" toView:self.view];
                return;
            }
            if (self.model.askFor.length == 0){
                [UIHelper showToast:@"请输入整改要求" toView:self.view];
                return;
            }
            if (self.after.count == 0){
                [UIHelper showToast:@"请添加整改后照片" toView:self.view];
                return;
            }
            if (self.model.basisContent.length == 0){
                [UIHelper showToast:@"请输入评测依据" toView:self.view];
                return;
            }
            [self.befor hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
                [self uploadImages:imageArray completion:^(NSString * urls) {
                    self.model.beforeUrl = urls;
                    
                    [self.after hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
                        [self uploadImages:imageArray completion:^(NSString * urls) {
                            self.model.afterUrl = urls;
                            [self uploadParamsData];
                        }];
                    }];
                    
                }];
            }];
        }else{
            if (self.model.conditionContent.length == 0){
                [UIHelper showToast:@"请输入评测情况" toView:self.view];
                return;
            }
            if (self.model.basisContent.length == 0){
                [UIHelper showToast:@"请输入评测依据" toView:self.view];
                return;
            }
            [self uploadParamsData];
        }
    }
    else if (self.type == 2){
        if (self.befor.count == 0){
            [UIHelper showToast:@"请先选择照片" toView:self.view];
            return;
        }
        if (self.model.conditionContent.length == 0){
            [UIHelper showToast:@"请输入评测情况" toView:self.view];
            return;
        }
        if (self.model.suggest.length == 0){
            [UIHelper showToast:@"请输入整改建议" toView:self.view];
            return;
        }
        if (self.model.basisContent.length == 0){
            [UIHelper showToast:@"请输入评测依据" toView:self.view];
            return;
        }
        [self.befor hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            [self uploadImages:imageArray completion:^(NSString * urls) {
                self.model.evaluationUrl = urls;
                [self uploadParamsData];
            }];
        }];
        
    }
    else if (self.type == 3){
        if (self.model.conditionContent.length == 0){
            [UIHelper showToast:@"请输入评测情况" toView:self.view];
            return;
        }
        if (self.model.basisContent.length == 0){
            [UIHelper showToast:@"请输入评测依据" toView:self.view];
            return;
        }
        if (self.after.count == 0){
            [UIHelper showToast:@"请结果照片" toView:self.view];
            return;
        }
        [self.after hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            [self uploadImages:imageArray completion:^(NSString * urls) {
                self.model.resultUrl = urls;
                [self uploadParamsData];
            }];
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0){
        return;
    }
    if (textView.tag == 1){
        self.model.conditionContent = textView.text;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == 1){
        if (textView.text.length == 0){
            if (!self.pcProjectEvaluationBasis){
                [APIRequest.shareInstance getUrl:BasisListToProject params:@{@"projectId":self.detailModel.Id,@"subentryId":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
                    self.pcProjectEvaluationBasis = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    [self showMultipleSelectionViewWithTextField:textView dataArray:self.pcProjectEvaluationBasis];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }else{
                [self showMultipleSelectionViewWithTextField:textView dataArray:self.pcProjectEvaluationBasis];
            }
            return false;
        }
        return true;
    }
    return false;
}

- (void)showMultipleSelectionViewWithTextField:(UITextView *)textView
                                     dataArray:(NSArray *)dataArray{
    MultipleSelectionView * selection = [[MultipleSelectionView alloc] init];
    BRStringPickerView * picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
//    picker.title = textField.placeholder;
    picker.alertView.userInteractionEnabled = true;
    selection.frame = CGRectMake(0, picker.pickerStyle.titleBarHeight, SCREEN_WIDTH, picker.alertView.height-picker.pickerStyle.titleBarHeight);
    selection.dataArray = dataArray;
    picker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        NSMutableArray * contentArray = [[NSMutableArray alloc] init];
        NSMutableArray * idArray = [[NSMutableArray alloc] init];

        [selection.selectedArray enumerateObjectsUsingBlock:^(ProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [contentArray addObject:obj.name];
            [idArray addObject:obj.Id];
        }];
        if (textView.tag == 1){
//            self.model.basisId = self.pcProjectEvaluationBasis[resultModel.index].Id;
            self.model.basisId = [idArray componentsJoinedByString:@","];
            self.model.basisContent = [contentArray componentsJoinedByString:@"\n"];
            [self getProblemArrayWithBasisIds:self.model.basisId];
        }
        textView.text = [contentArray componentsJoinedByString:@"\n"];
    };
    [picker show];
    [picker.alertView addSubview:selection];
}

- (void)showPickerViewWithArray:(NSArray<ProjectModel*> *)dataArray
                       textView:(UITextView *)textView{
    NSMutableArray * dataSource = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(ProjectModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dataSource addObject:obj.name];
    }];
    [BRStringPickerView showPickerWithTitle:nil dataSourceArr:dataSource selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        textView.text = dataArray[resultModel.index].content;
        if (textView.tag == 1){
            self.model.basisId = dataArray[resultModel.index].Id;
            self.model.basisContent = textView.text;
            [self getProblemArrayWithBasisIds:self.model.basisId];
        }
    }];
}

- (void)getProblemArrayWithBasisIds:(NSString *)bid{
    [APIRequest.shareInstance getUrl:Problem params:@{@"basisIds":bid} success:^(NSDictionary * _Nonnull result) {
        self.problemArray = [ProblemModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        self.footer.dataArray = self.problemArray;
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4){
        ImagesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImagesTableViewCell class]) forIndexPath:indexPath];
        cell.row = indexPath.section;
        if (self.type == 1){
            cell.titleLabel.text = indexPath.section == 2 ? @"上传整改前图片" : @"上传整改后图片";
        }else if (self.type == 2){
            cell.titleLabel.text = @"上传评测图片";
        }else if (self.type == 3){
            cell.titleLabel.text = @"结果图片上传";
        }
        cell.changeComplete = ^(NSArray * array,NSInteger section) {
            if (section == 0){
                self.befor = array;
            }else{
                self.after = array;
            }
        };
        cell.updateFrame = ^(CGFloat imageHeight,NSInteger section){
            if (section == 0){
                self.beforHeight = imageHeight;
            }else{
                self.afterHeight = imageHeight;
            }
            [UIView performWithoutAnimation:^{
                [tableView beginUpdates];
                [tableView endUpdates];
            }];
        };
        if (indexPath.section == 0){
            if (self.type == 2){
                cell.images = self.model.evaluationUrl;
            }else if (self.type == 3){
                cell.images = self.model.resultUrl;
            }
        }else if (indexPath.section == 2){
            cell.images = self.model.beforeUrl;
        }else{
            cell.images = self.model.afterUrl;
        }
        return cell;
    }else{
        ContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContentTableViewCell class]) forIndexPath:indexPath];
        cell.descCell.content.delegate = self;
        cell.descCell.content.tag = indexPath.section;
        if (indexPath.section == 1){
            cell.titleLabel.text = @"评测依据";
            cell.descCell.content.placeholder = @"请选择（根据分类选择编号，带出依据，可多选）";
            cell.descCell.content.text = self.model.basisContent;
        }else if (indexPath.section == 3){
            cell.descCell.content.placeholder = @"请输入整改建议";
            if (self.type == 1){
                cell.titleLabel.text = @"整改要求";
                cell.descCell.content.text = self.model.askFor;
            }else if (self.type == 2){
                cell.titleLabel.text = @"整改建议";
                cell.descCell.content.text = self.model.suggest;
            }
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray * array = [self.detailModel.subentryClassesSecondLevelEvaluation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id == %@",self.subentryClassesSecondLevel]];
    if (array.count > 0){
        ProjectModel * model = array.firstObject;
        return model.evaluation ? 5 : 2;
    }
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (self.type == 1){
            return 0.01;
        }
        return self.beforHeight+47;
    }else if (indexPath.section == 1){
        return 200;
    }else if (indexPath.section == 2){
        if (self.type == 1){
            return self.beforHeight+47;
        }else{
            return 0.01;
        }
    }else if (indexPath.section == 3){
        return 132;
    }else if (indexPath.section == 4){
        if (self.type == 1){
            return self.afterHeight+47;
        }else{
            return 0.01;
        }
    }else{
        return 132;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    header.backgroundColor = [UIColor colorWithHexString:@"#F3F5FA"];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1){
        if(!self.footer){
            self.footer = [[BusinessFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.footer.tableView.contentSize.height == 0 ? 200 : self.footer.tableView.contentSize.height)];
        }
        self.footer.dataArray = self.problemArray;
        self.footer.tableViewContentHeightCompletion = ^(CGFloat height){
            [UIView performWithoutAnimation:^{
                [tableView beginUpdates];
                [tableView endUpdates];
            }];
        };
        return self.footer;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1){
        return self.footer.tableView.contentSize.height;
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
