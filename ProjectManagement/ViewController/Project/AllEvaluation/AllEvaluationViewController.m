//
//  AllEvaluationViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2023/3/9.
//

#import "AllEvaluationViewController.h"
#import "ProjectDetailFooterView.h"
#import "ProjectInfoTableViewCell.h"
#import "ProjectDescTableViewCell.h"
#import "InputTableViewCell.h"
@import BRPickerView;
#import "ImagesTableViewCell.h"
#import "UIView+Hud.h"
#import "MultipleSelectionView.h"

@interface AllEvaluationViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong) ProjectDetailFooterView * footerView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) NSArray<ProjectModel*> * pcProjectEvaluationBasis;
@property(nonatomic,strong) NSArray<ProjectModel*> * pcProjectEvaluationConclusion;
@property(nonatomic,strong) ProjectModel * model;
@property(nonatomic,strong) ProjectModel * classModel;
@property(nonatomic,strong) NSString * basisContent;
@property(nonatomic,assign) CGFloat imagesCellHeight;
@property(nonatomic,strong) NSArray * images;

@end

@implementation AllEvaluationViewController

- (ProjectDetailFooterView *)footerView{
    if (!_footerView){
        _footerView = [[ProjectDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.model.subentryClassesSecondLevelEvaluation.count*40+30)];
    }
    __weak typeof (self) weakSelf = self;
    _footerView.addCompletion = ^{
        [weakSelf updateBottomData];
    };
    return _footerView;
}

- (void)updateBottomData{
    [APIRequest.shareInstance getUrl:ProjectDetail params:@{@"projectId":self.projectId} success:^(NSDictionary * _Nonnull result) {
        ProjectModel * model = [ProjectModel mj_objectWithKeyValues:result[@"data"]];
        self.model.subentryClassesSecondLevelEvaluation = model.subentryClassesSecondLevelEvaluation;
        self.footerView.subentryClassesSecondLevelEvaluation = self.model.subentryClassesSecondLevelEvaluation;
        self.footerView.detailModel = self.model;
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectInfoTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDescTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDescTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InputTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InputTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImagesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImagesTableViewCell class])];

    UIButton * submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"  提交" forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [submit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"ic_submit"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitActionAlert) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submit];
    [self getProjectDetail];
    
    
}

- (void)uploadImages:(NSArray *)images completion:(void(^)(NSString *))completion{
    [APIRequest.shareInstance postUrl:Uploads params:@{} images:images success:^(NSDictionary * _Nonnull result) {
        completion(result[@"fileNames"]);
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)submitActionAlert{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否确认提交审核" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * done = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self submitAction];
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)submitAction{
    BOOL evaluation = false;
    for (ProjectModel * model in self.model.subentryClassesSecondLevelEvaluation) {
        if (model.evaluation){
            evaluation = true;
        }
    }
    if (!self.classModel && !evaluation){
        [UIHelper showToast:@"请先填写二级分项类别测评" toView:self.view];
        return;
    }
    if (self.model.value.length == 0){
        [UIHelper showToast:@"请输入测评面积/道路总长" toView:self.view];
        return;
    }
    if (self.model.conclusionContent.length == 0){
        [UIHelper showToast:@"请选择评测结论" toView:self.view];
        return;
    }
    if (self.model.type.intValue == 3){
        if (self.images.count == 0){
            [UIHelper showToast:@"请添加结果照片" toView:self.view];
            return;
        }
        [self.view showHUDToast:@"图片上传中"];
        [self.images hx_requestImageWithOriginal:true completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            [self uploadImages:imageArray completion:^(NSString * urls) {
                self.model.url = urls;
                [self.view hiddenHUD];
                [self uploadParamsData];
            }];
        }];
    }else{
        [self uploadParamsData];
    }
}

- (void)uploadParamsData{
    [APIRequest.shareInstance postUrl:EvaluationAdd params:@{@"value":self.model.value,@"conclusionContent":self.model.conclusionContent,@"conclusionId":self.model.conclusionId,@"projectId":self.projectId,@"type":self.model.type} success:^(NSDictionary * _Nonnull result) {
        [UIHelper showToast:@"提交成功" toView:self.view];
        [NSNotificationCenter.defaultCenter postNotificationName:Add_Project_NOTIFICATION object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
    } failure:^(NSString * _Nonnull errorMsg) {

    }];
}

- (void)getProjectDetail{
    [APIRequest.shareInstance getUrl:ProjectDetail params:@{@"projectId":self.projectId} success:^(NSDictionary * _Nonnull result) {
        self.model = [ProjectModel mj_objectWithKeyValues:result[@"data"]];
        if (self.model.projectEvaluation){
            self.model.conclusionContent = self.model.projectEvaluation.conclusionContent;
            self.model.conclusionId = self.model.projectEvaluation.conclusionId;
        }
        self.dataArray = [NSMutableArray arrayWithArray:@[
            @{@"title":@"项目地址",@"value":self.model.detailAddress,@"type":@"info"},
            @{@"title":@"项目联系人",@"value":self.model.contacts,@"type":@"info"},
            @{@"title":@"联系电话",@"value":self.model.phone,@"type":@"info"},
            @{@"title":@"项目综述",@"value":@"",@"type":@"info"},
            @{@"title":@"",@"value":self.model.review,@"type":@"desc"},
            @{@"title":@"测评面积/道路总长",@"placeholder":@"请输入",@"value":self.model.value?:@"",@"type":@"input"},
            @{@"title":@"评测依据",@"value":@"",@"type":@"info"},
            @{@"title":@"评测依据",@"value":self.model.basisContent?:@"",@"type":@"desc"},
            @{@"title":@"结论",@"value":@"",@"type":@"info"},
            @{@"title":@"",@"value":self.model.conclusionContent?:@"",@"type":@"desc"},
            @{@"title":@"项目分项类别",@"value":self.model.subentryClassesList.count == 0 ? @"" : [self.model.subentryClassesList componentsJoinedByString:@","],@"type":@"info"},
            @{@"title":@"结果图片上传",@"placeholder":@"",@"value":@"",@"type":@"image"},
            @{@"title":@"项目二级分项类别评测",@"value":@"",@"type":@"info"}
        ]];
        if (self.model.type.intValue == 3){
            self.imagesCellHeight = (SCREEN_WIDTH-50)/3;
        }
        [self getBasisListToProjectData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getBasisListToProjectData{
    [APIRequest.shareInstance getUrl:BasisListToProject params:@{@"projectId":self.projectId} success:^(NSDictionary * _Nonnull result) {
        NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        self.basisContent = @"";
        NSMutableArray * contentArray = [[NSMutableArray alloc] init];
        if (modelArray.count > 0){
            for (int i=0; i<modelArray.count; i++) {
                ProjectModel * model = modelArray[i];
                if (![contentArray containsObject:model.name]){
                    [contentArray addObject:model.name];
                }
            }
            self.basisContent = [contentArray componentsJoinedByString:@"\n"];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[self.dataArray.count-6]];
            [dict setValue:self.basisContent forKey:@"value"];
            [self.dataArray replaceObjectAtIndex:self.dataArray.count-6 withObject:dict];
        }
        self.footerView.subentryClassesSecondLevelEvaluation = self.model.subentryClassesSecondLevelEvaluation;
        self.footerView.detailModel = self.model;
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.view endEditing:true];
    if (textView.tag == 7){
        if (textView.text.length == 0){
            NSMutableArray * idArray = [[NSMutableArray alloc] init];
            for (ProjectModel * model in self.model.subentryClassesSecondLevelEvaluation) {
                [idArray addObject:model.Id];
            }
            [APIRequest.shareInstance getUrl:ProjectEvaluationSituation params:@{@"ids":[idArray componentsJoinedByString:@","],@"isAll":@"1"} success:^(NSDictionary * _Nonnull result) {
                NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                NSMutableArray * array = [[NSMutableArray alloc] init];
                [modelArray enumerateObjectsUsingBlock:^(ProjectModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    obj.name = [NSString stringWithFormat:@"%@-%@",obj.name,obj.serialNumber];
                    [array addObject:obj];
                }];
                self.pcProjectEvaluationBasis = array;
                [self showMultipleSelectionViewWithTextField:textView dataArray:self.pcProjectEvaluationBasis];
            } failure:^(NSString * _Nonnull errorMsg) {

            }];
        }
        return false;
    }
    if (textView.tag == 9){
        if (textView.text.length == 0){
            if (!self.pcProjectEvaluationConclusion){
                [APIRequest.shareInstance getUrl:PcProjectEvaluationConclusion params:@{} success:^(NSDictionary * _Nonnull result) {
                    self.pcProjectEvaluationConclusion = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    [self showPickerViewWithArray:self.pcProjectEvaluationConclusion textView:textView];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }else{
                [self showPickerViewWithArray:self.pcProjectEvaluationConclusion textView:textView];
            }
            return false;
        }else{
            return true;
        }
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
            self.model.basisId = [idArray componentsJoinedByString:@","];
            self.model.basisContent = [contentArray componentsJoinedByString:@"\n"];
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
        if (textView.tag == 7){
            self.model.basisId = dataArray[resultModel.index].Id;
            self.model.basisContent = textView.text;
        }else if (textView.tag == 9){
            self.model.conclusionContent = textView.text;
            self.model.conclusionId = dataArray[resultModel.index].Id;
        }
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0){
        return;
    }
    self.model.value = textField.text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"info"]){
        ProjectInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectInfoTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.content.text = item[@"value"];
        return cell;
    }else if([item[@"type"] isEqualToString:@"input"]){
        InputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InputTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.textField.placeholder = item[@"placeholder"];
        cell.textField.text = item[@"value"];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        return cell;
    }else if ([item[@"type"] isEqualToString:@"image"]){
        ImagesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImagesTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.changeComplete = ^(NSArray * array,NSInteger row) {
            self.images = array;
        };
        cell.updateFrame = ^(CGFloat imageHeight,NSInteger row){
            self.imagesCellHeight = imageHeight;
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        return cell;
    } else{
        ProjectDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDescTableViewCell class]) forIndexPath:indexPath];
        cell.content.placeholder = @"请选择";
        cell.content.text = item[@"value"];
        cell.content.delegate = self;
        cell.content.tag = indexPath.row;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"desc"]){
        if ([item[@"title"] isEqualToString:@"评测依据"]){
            NSString * value = item[@"value"];
            if (value.length == 0){
                return 50;
            }else{
                return [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+30;
            }
        }
        return 82;
    }else if ([item[@"type"] isEqualToString:@"image"]){
        if (self.model.type.intValue == 3){
            return self.imagesCellHeight+47;
        }else{
            return 0.01;
        }
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
