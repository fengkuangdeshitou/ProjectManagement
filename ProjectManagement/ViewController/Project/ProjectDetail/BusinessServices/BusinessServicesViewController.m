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

@interface BusinessServicesViewController ()<UITextViewDelegate>

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
    if (self.type == 1){
        if (self.model.abarbeitung != nil){
            self.abarbeitung = self.model.abarbeitung.integerValue;
            self.selectBtn.selected = false;
            self.normalBtn.selected = true;
        }else{
            self.abarbeitung = 1;
        }
    }else if (self.type == 2){
        self.tableView.tableHeaderView.height = 55;
        self.tableView.tableHeaderView.clipsToBounds = true;
    }else if (self.type == 3){
        self.tableView.tableHeaderView.height = 0.01;
        self.tableView.tableHeaderView.clipsToBounds = true;
    }
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImagesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImagesTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ContentTableViewCell class])];
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
//    NSDictionary * params = @{
//        @"abarbeitung":self.model.abarbeitung,
//        @"afterUrl":self.model.afterUrl,
//        @"askFor":self.model.askFor,
//        @"basisContent":self.model.basisContent,
//        @"basisId":self.model.basisId,
//        @"beforeUrl":self.model.beforeUrl,
//        @"conditionContent":self.model.conditionContent,
//        @"conditionId":self.model.conditionId,
//        @"projectId":self.model.projectId,
//        @"subentryClassesSecondLevel":self.subentryClassesSecondLevel,
//        @"type":self.model.type
//    };
//    NSDictionary * params = @{
//        @"abarbeitung":@"1",
//        @"afterUrl":@"/profile/upload/2023/03/09/236fc7c6-3011-4cb0-a757-43e0cfbe07bb_20230309205732A053.jpg",
//        @"askFor":@"......",
//        @"basisContent":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
//        @"basisId":@"1",
//        @"beforeUrl":@"/profile/upload/2023/03/09/c84a336d-2620-486d-ae8b-5f0a4c005012_20230309205732A051.jpg",
//        @"conditionContent":@"1231231",
//        @"conditionId":@"10",
//        @"isAllConfig":[NSNumber numberWithBool:false],
//        @"projectId":@"38",
//        @"subentryClassesSecondLevel":@"6",
//        @"type":@"1"
//    };
    
    
    
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
    if (textView.tag == 2){
        if (self.type == 2){
            self.model.suggest = textView.text;
        }else{
            self.model.askFor = textView.text;
        }
    }
    if (textView.tag == 4){
        self.model.basisContent = textView.text;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == 1){
        if (textView.text.length == 0){
            if (!self.pcProjectEvaluationSituation){
                [APIRequest.shareInstance getUrl:PcProjectEvaluationSituation params:@{@"id":self.subentryClassesSecondLevel} success:^(NSDictionary * _Nonnull result) {
                    self.pcProjectEvaluationSituation = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    [self showPickerViewWithArray:self.pcProjectEvaluationSituation textView:textView];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }else{
                [self showPickerViewWithArray:self.pcProjectEvaluationSituation textView:textView];
            }
            return false;
        }
        return true;
    }else if (textView.tag == 2){
        if (textView.text.length == 0){
            if (self.type == 1){
                return true;
            }else if (self.type == 3){
                if (textView.text.length == 0){
                    if (!self.pcProjectEvaluationBasis){
                        [APIRequest.shareInstance getUrl:PcProjectEvaluationBasis params:@{} success:^(NSDictionary * _Nonnull result) {
                            self.pcProjectEvaluationBasis = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                            [self showPickerViewWithArray:self.pcProjectEvaluationBasis textView:textView];
                        } failure:^(NSString * _Nonnull errorMsg) {
                            
                        }];
                    }else{
                        [self showPickerViewWithArray:self.pcProjectEvaluationBasis textView:textView];
                    }
                    return false;
                }
            }
        }
        return true;
    }else if (textView.tag == 4){
        if (textView.text.length == 0){
            if (!self.pcProjectEvaluationBasis){
                [APIRequest.shareInstance getUrl:PcProjectEvaluationBasis params:@{} success:^(NSDictionary * _Nonnull result) {
                    self.pcProjectEvaluationBasis = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                    [self showPickerViewWithArray:self.pcProjectEvaluationBasis textView:textView];
                } failure:^(NSString * _Nonnull errorMsg) {
                    
                }];
            }else{
                [self showPickerViewWithArray:self.pcProjectEvaluationBasis textView:textView];
            }
            return false;
        }
        return true;
    }
    return false;
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
            self.model.conditionId = dataArray[resultModel.index].Id;
            self.model.conditionContent = textView.text;
        }else if (textView.tag == 4 || textView.tag == 2){
            self.model.basisContent = textView.text;
            self.model.basisId = dataArray[resultModel.index].Id;
        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 3){
        ImagesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImagesTableViewCell class]) forIndexPath:indexPath];
        cell.row = indexPath.row;
        if (self.type == 1){
            cell.titleLabel.text = indexPath.row == 0 ? @"上传整改前图片" : @"上传整改后图片";
        }else if (self.type == 2){
            cell.titleLabel.text = @"上传评测图片";
        }else if (self.type == 3){
            cell.titleLabel.text = @"结果图片上传";
        }
        cell.changeComplete = ^(NSArray * array,NSInteger row) {
            if (row == 0){
                self.befor = array;
            }else{
                self.after = array;
            }
        };
        cell.updateFrame = ^(CGFloat imageHeight,NSInteger row){
            if (row == 0){
                self.beforHeight = imageHeight;
            }else{
                self.afterHeight = imageHeight;
            }
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        if (indexPath.row == 0){
            if (self.type == 2){
                cell.images = self.model.evaluationUrl;
            }else{
                cell.images = self.model.beforeUrl;
            }
        }else{
            if (self.type == 1){
                cell.images = self.model.afterUrl;
            }else if (self.type == 3){
                cell.images = self.model.resultUrl;
            }
        }
        return cell;
    }else{
        ContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContentTableViewCell class]) forIndexPath:indexPath];
        cell.descCell.content.delegate = self;
        cell.descCell.content.tag = indexPath.row;
        if (indexPath.row == 1){
            cell.titleLabel.text = @"评测情况";
            cell.descCell.content.placeholder = @"请输入评测情况";
            cell.descCell.content.text = self.model.conditionContent;
        }else if (indexPath.row == 2){
            cell.descCell.content.placeholder = @"请输入整改建议";
            if (self.type == 1){
                cell.titleLabel.text = @"整改要求";
                cell.descCell.content.text = self.model.askFor;
            }else if (self.type == 2){
                cell.titleLabel.text = @"整改建议";
                cell.descCell.content.text = self.model.suggest;
            }else if (self.type == 3){
                cell.titleLabel.text = @"评测依据";
                cell.descCell.content.text = self.model.basisContent;
            }
        }else if (indexPath.row == 4){
            cell.descCell.content.placeholder = @"请选择";
            cell.titleLabel.text = @"评测依据";
            cell.descCell.content.text = self.model.basisContent;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        if ((self.type == 1 && self.abarbeitung == 0) || self.type == 3){
            return 0.01;
        }
        return self.beforHeight+47;
    }else if (indexPath.row == 1){
        return 132;
    }else if (indexPath.row == 2){
        if (self.type == 1 && self.abarbeitung == 0){
            return 0.01;
        }
        return 132;
    }else if (indexPath.row == 3){
        if ((self.type == 1 && self.abarbeitung == 0) || self.type == 2){
            return 0.01;
        }else{
            return self.afterHeight+47;
        }
    }else if (indexPath.row == 4){
        if (self.type == 3){
            return 0.01;
        }
        return 132;
    }else{
        return 132;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    header.backgroundColor = [UIColor colorWithHexString:@"#F3F5FA"];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
