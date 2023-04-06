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
#import "UIView+Hud.h"

@interface BusinessServicesViewController ()<UITextViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UILabel * address;
@property(nonatomic,weak)IBOutlet UIButton * selectBtn;
@property(nonatomic,weak)IBOutlet UIButton * normalBtn;
@property(nonatomic,weak)IBOutlet UIButton * submitBtn;

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
@property(nonatomic,assign) BOOL canEdit;
@property(nonatomic,assign) BOOL isEvaluation;
@property(nonatomic,assign) BOOL qualified;

@end

@implementation BusinessServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.type = self.detailModel.type.integerValue;
    self.address.text = self.detailModel.detailAddress;
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
    
}

- (void)getEvaluatingDetails{
    [APIRequest.shareInstance getUrl:EvaluatingDetails params:@{@"projectId":self.detailModel.Id,@"subentryId":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"data"] isKindOfClass:[NSDictionary class]]){
            self.isEvaluation = true;
            self.model = [ProjectModel mj_objectWithKeyValues:result[@"data"]];
            if (self.type == 1){
                if (self.model.afterUrl.length > 0 || self.model.resultContrast.intValue == 1){
                    self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                    self.submitBtn.userInteractionEnabled = false;
                }else{
                    self.canEdit = true;
                }
            }
            if (self.type == 2 && self.model.resultContrast.intValue == 0){
                self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                self.submitBtn.userInteractionEnabled = false;
            }
            if (self.type == 3){
                self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                self.submitBtn.userInteractionEnabled = false;
            }
        }else{
            self.model = [[ProjectModel alloc] init];
            self.canEdit = true;
        }
        self.model.projectId = self.detailModel.Id;
        self.model.subentryClassesSecondLevelId = self.detailModel.subentryClassesSecondLevelId;
        [self.tableView reloadData];
        [self getBasisListToProjectData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getBasisListToProjectData{
    [APIRequest.shareInstance getUrl:BasisListToProject params:@{@"projectId":self.detailModel.Id,@"subentryId":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
        NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        NSMutableArray * idArray = [[NSMutableArray alloc] init];
        if (modelArray.count > 0){
            NSString * basisContent = @"";
            for (int i=0; i<modelArray.count; i++) {
                ProjectModel * model = modelArray[i];
                basisContent = [NSString stringWithFormat:@"%@%@\n%@\n\n",basisContent,model.serialNumber,model.content];
                [idArray addObject:model.Id];
            }
            basisContent = [basisContent substringToIndex:basisContent.length-2];
            self.model.basisContent = basisContent;
            self.model.basisId = [idArray componentsJoinedByString:@","];
            [self.tableView reloadData];
            [self getProblemArrayWithBasisIds:self.model.basisId];
        }else{
            if (self.model.basisId){
                NSArray * filter = [self.detailModel.subentryClassesSecondLevelEvaluation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id = %@",self.subentryClassesSecondLevel]];
                ProjectModel * model = filter.firstObject;
                [APIRequest.shareInstance getUrl:ProjectEvaluationSituation params:@{@"ids":model.evaluation.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
                    NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    NSMutableArray * idArray = [[NSMutableArray alloc] init];
                    NSMutableArray * nameArray = [[NSMutableArray alloc] init];
    
                    [modelArray enumerateObjectsUsingBlock:^(ProjectModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [nameArray addObject:[NSString stringWithFormat:@"%@\n%@",obj.serialNumber,obj.content]];
                        [idArray addObject:obj.Id];
                    }];
                    if (modelArray.count > 0){
                        NSString * content = [nameArray componentsJoinedByString:@"\n"];
                        self.model.basisContent = content;
                        self.model.basisId = [idArray componentsJoinedByString:@","];
                        [self.tableView reloadData];
                        [self getProblemArrayWithBasisIds:self.model.basisId];
                    }else{
                        self.tableView.hidden = false;
                        [self.tableView reloadData];
                    }
                } failure:^(NSString * _Nonnull errorMsg) {
    
                }];
            }else{
                self.tableView.hidden = false;
                [self.tableView reloadData];
            }
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getProblemArrayWithBasisIds:(NSString *)bid{
    [APIRequest.shareInstance getUrl:Problem params:@{@"projectId":self.detailModel.Id,@"basisIds":bid} success:^(NSDictionary * _Nonnull result) {
        self.problemArray = [ProblemModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        self.footer.dataArray = self.problemArray;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.hidden = false;
        });
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
        [self.view hiddenHUD];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)uploadParamsData{
    NSMutableDictionary * pcEvaluation = [[NSMutableDictionary alloc] init];
    [pcEvaluation setValue:self.model.basisId forKey:@"basisId"];
    [pcEvaluation setValue:[NSString stringWithFormat:@"%ld",self.type] forKey:@"type"];
    [pcEvaluation setValue:self.model.projectId forKey:@"projectId"];
    [pcEvaluation setValue:self.subentryClassesSecondLevel forKey:@"subentryClassesSecondLevel"];
    if (self.type == 1 && self.model.afterUrl.length > 0){
        [pcEvaluation setValue:@"1" forKey:@"abarbeitung"];
        [pcEvaluation setValue:self.model.beforeUrl forKey:@"beforeUrl"];
        [pcEvaluation setValue:self.model.afterUrl forKey:@"afterUrl"];
    }
    if (self.type == 2){
        [pcEvaluation setValue:self.model.evaluationUrl forKey:@"evaluationUrl"];
    }
    if (self.type == 3){
        [pcEvaluation setValue:self.model.resultUrl forKey:@"resultUrl"];
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:pcEvaluation forKey:@"pcEvaluation"];
    [params setValue:self.footer.answerArray forKey:@"problemContent"];
    NSLog(@"json=%@",[params mj_JSONString]);

    [APIRequest.shareInstance postUrl:SubmitEvaluation params:params success:^(NSDictionary * _Nonnull result) {
        if (self.addCompletion){
            self.addCompletion();
        }
        self.isEvaluation = true;
        NSDictionary * data = result[@"data"];
        self.qualified = [data[@"qualified"] boolValue];
        if (!self.qualified){
            NSArray * rectificationRequest = data[@"rectificationRequest"];
            self.model.rectificationRequest = rectificationRequest;
            if (self.type != 1){
                self.canEdit = false;
                self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                self.submitBtn.userInteractionEnabled = false;
            }
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:true];
            });
        }else{
            self.submitBtn.userInteractionEnabled = false;
            [UIHelper showToast:@"提交成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                [self.navigationController popViewControllerAnimated:true];
            });
        }
    } failure:^(NSString * _Nonnull errorMsg) {

    }];
}

- (IBAction)submitAction:(id)sender{
    if (self.type == 1){
        if (self.model.rectificationRequest.count > 0){
            if (self.befor.count == 0){
                [UIHelper showToast:@"请添加整改前照片" toView:self.view];
                return;
            }
//            if (self.model.conditionContent.length == 0){
//                [UIHelper showToast:@"请输入评测情况" toView:self.view];
//                return;
//            }
//            if (self.model.askFor.length == 0){
//                [UIHelper showToast:@"请输入整改要求" toView:self.view];
//                return;
//            }
            if (self.after.count == 0){
                [UIHelper showToast:@"请添加整改后照片" toView:self.view];
                return;
            }
            if (self.model.basisContent.length == 0){
                [UIHelper showToast:@"请选择评测依据" toView:self.view];
                return;
            }
            [self.view showHUDToast:@"上传图片中"];
            [self.befor hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
                [self uploadImages:imageArray completion:^(NSString * urls) {
                    self.model.beforeUrl = urls;
                    [self.view showHUDToast:@"上传图片中"];
                    [self.after hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
                        [self uploadImages:imageArray completion:^(NSString * urls) {
                            self.model.afterUrl = urls;
                            [self uploadParamsData];
                        }];
                    }];
                    
                }];
            }];
        }else{
//            if (self.model.conditionContent.length == 0){
//                [UIHelper showToast:@"请输入评测情况" toView:self.view];
//                return;
//            }
            if (self.model.basisContent.length == 0){
                [UIHelper showToast:@"请选择评测依据" toView:self.view];
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
//        if (self.model.conditionContent.length == 0){
//            [UIHelper showToast:@"请输入评测情况" toView:self.view];
//            return;
//        }
//        if (self.model.suggest.length == 0){
//            [UIHelper showToast:@"请输入整改建议" toView:self.view];
//            return;
//        }
        if (self.model.basisContent.length == 0){
            [UIHelper showToast:@"请选择评测依据" toView:self.view];
            return;
        }
        [self.view showHUDToast:@"上传图片中"];
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
        if (self.befor.count == 0){
            [UIHelper showToast:@"请结果照片" toView:self.view];
            return;
        }
        [self.view showHUDToast:@"上传图片中"];
        [self.after hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            [self uploadImages:imageArray completion:^(NSString * urls) {
                self.model.resultUrl = urls;
                [self uploadParamsData];
            }];
        }];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == 1){
        if (textView.text.length == 0){
            if (!self.pcProjectEvaluationBasis){
                [APIRequest.shareInstance getUrl:ProjectEvaluationSituation params:@{@"ids":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
                    NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    NSMutableArray * array = [[NSMutableArray alloc] init];
                    [modelArray enumerateObjectsUsingBlock:^(ProjectModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.name = [NSString stringWithFormat:@"%@-%@",obj.name,obj.serialNumber];
                        [array addObject:obj];
                    }];
                    self.pcProjectEvaluationBasis = array;
                    [self showMultipleSelectionViewWithTextField:textView dataArray:self.pcProjectEvaluationBasis];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }else{
                [self showMultipleSelectionViewWithTextField:textView dataArray:self.pcProjectEvaluationBasis];
            }
        }
        return false;
    }
    return false;
}

- (void)showMultipleSelectionViewWithTextField:(UITextView *)textView
                                     dataArray:(NSArray *)dataArray{
    MultipleSelectionView * selection = [[MultipleSelectionView alloc] init];
    BRStringPickerView * picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
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
        HXWeakSelf
        cell.changeComplete = ^(NSArray * array,NSInteger section) {
            if (weakSelf.type == 1){
                if (section == 2){
                    weakSelf.befor = array;
                }else if (section == 4){
                    weakSelf.after = array;
                }
            }else if (weakSelf.type == 2){
                if (section == 0){
                    weakSelf.befor = array;
                }
            }
        };
        cell.updateFrame = ^(CGFloat imageHeight,NSInteger section){
            if (section == 0){
                weakSelf.beforHeight = imageHeight;
            }else{
                weakSelf.afterHeight = imageHeight;
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
            if (self.type == 1){
                cell.images = self.model.beforeUrl;
            }
        }else if (indexPath.section == 4){
            if (self.type == 1){
                cell.images = self.model.afterUrl;
            }
        }
        cell.canEdit = self.canEdit;
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
                cell.descCell.content.text = [self.model.rectificationRequest componentsJoinedByString:@"\n"];
            }else if (self.type == 2){
                cell.titleLabel.text = @"整改建议";
                cell.descCell.content.text = [self.model.rectificationRequest componentsJoinedByString:@"\n"];
            }
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.isEvaluation || self.model.resultContrast.intValue == 1){
        return 2;
    }else{
        if (!self.qualified){
            return 5;
        }else{
            return 2;
        }
    }
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
        if (self.model.basisContent.length > 0){
            CGFloat contentHeight = [self.model.basisContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            return contentHeight+10+70;
        }else{
            return 120;
        }
    }else if (indexPath.section == 2){
        if (self.type == 1){
            return self.beforHeight+47;
        }else{
            return 0.01;
        }
    }else if (indexPath.section == 3){
        if (self.type == 3){
            return 0.01;
        }else{
            if (self.model.rectificationRequest.count > 0){
                NSString * request = [self.model.rectificationRequest componentsJoinedByString:@"\n"];
                CGFloat contentHeight = [request boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                return contentHeight+10+70;
            }else{
                return 120;
            }
        }
    }else{
        if (self.type == 1){
            return self.afterHeight+47;
        }else{
            return 0.01;
        }
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
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000+37)];
        footerView.clipsToBounds = true;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        label.text = @"评测情况";
        label.hidden = true;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [footerView addSubview:label];
        if(!self.footer){
            self.footer = [[BusinessFooterView alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, self.footer.tableView.contentSize.height == 0 ? 200 : self.footer.tableView.contentSize.height)];
        }
        self.footer.canEdit = self.canEdit;
        self.footer.dataArray = self.problemArray;
        self.footer.answer = self.model.answer;
        HXWeakSelf
        weakSelf.footer.tableViewContentHeightCompletion = ^(CGFloat height){
            label.hidden = weakSelf.problemArray.count == 0;
            [UIView performWithoutAnimation:^{
                [tableView beginUpdates];
                [tableView endUpdates];
            }];
        };
        [footerView addSubview:self.footer];
        return footerView;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1){
        return self.footer.tableView.contentSize.height + 37;
    }else{
        return 0.01;
    }
}
     
- (void)dealloc{
    NSLog(@"------");
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
