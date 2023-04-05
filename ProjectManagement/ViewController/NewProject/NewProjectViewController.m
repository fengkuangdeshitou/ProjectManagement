//
//  NewProjectViewController.m
//  ProjectManagement
//
//  Created by maiyou on 2022/11/30.
//

#import "NewProjectViewController.h"
#import "InputTableViewCell.h"
#import "SelectTableViewCell.h"
#import "ProjectDescTableViewCell.h"
@import BRPickerView;
#import "ProjectModel.h"
#import "MultipleSelectionView.h"
#import "ImagesTableViewCell.h"
#import "LocationTableViewCell.h"
#import "LocationViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "UIView+Hud.h"

@interface NewProjectViewController ()<UITextFieldDelegate,UITextViewDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) ProjectModel * model;
@property(nonatomic,strong) NSArray<ProjectModel*> * classesArray;
@property(nonatomic,strong) NSArray<ProjectModel*> * classesSecondArray;
@property(nonatomic,strong) NSArray<ProjectModel*> * projectGroup;
@property(nonatomic,strong) NSArray<ProjectModel*> * projectSubentry;
@property(nonatomic,strong) NSArray<ProjectModel*> * projectSubentrySecondLevel;
@property(nonatomic,strong) NSArray<ProjectModel*> * projectEvaluationSituation;;

@property(nonatomic,strong) NSArray * images;
@property(nonatomic,assign) CGFloat imagesCellHeight;

@end

@implementation NewProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新建项目";
    self.model = [[ProjectModel alloc] init];
    self.dataArray = [NSMutableArray arrayWithArray:@[
        @{@"title":@"项目名称",@"placeholder":@"请输入",@"value":@"",@"type":@"input"},
        @{@"title":@"项目类型",@"placeholder":@"请选择",@"value":@"",@"type":@"select"},
        @{@"title":@"项目类别",@"placeholder":@"请选择",@"value":@"",@"type":@"select"},
        @{@"title":@"项目二级类别",@"placeholder":@"请选择",@"value":@"",@"type":@"select"},
        @{@"title":@"使用设施的残障人士类别",@"placeholder":@"请选择（多选）",@"value":@"",@"type":@"select"},
        @{@"title":@"项目建设单位",@"placeholder":@"请输入",@"value":@"",@"type":@"input"},
        @{@"title":@"项目地址",@"placeholder":@"请输入，上传经纬度到后台",@"value":@"",@"type":@"location"},
        @{@"title":@"项目联系人",@"placeholder":@"请输入",@"value":@"",@"type":@"input"},
        @{@"title":@"联系电话",@"placeholder":@"请输入",@"value":@"",@"type":@"input"},
        @{@"title":@"项目综述",@"placeholder":@"",@"value":@"",@"type":@"input"},
        @{@"title":@"",@"placeholder":@"请输入项目综述",@"value":@"",@"type":@"desc"},
        @{@"title":@"项目分项类别",@"placeholder":@"请选择",@"value":@"",@"type":@"select"},
        @{@"title":@"项目二级分项类别评测",@"placeholder":@"请选择",@"value":@"",@"type":@"select"},
        @{@"title":@"关联评测依据",@"placeholder":@"请选择（多选）",@"value":@"",@"type":@"select"},
        @{@"title":@"evaluationSituation",@"placeholder":@"请输入项目综述",@"value":@"",@"type":@"desc"},
        @{@"title":@"上传图片",@"placeholder":@"",@"value":@"",@"type":@"image"}
    ]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InputTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InputTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SelectTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDescTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDescTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImagesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImagesTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LocationTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LocationTableViewCell class])];
    
    [NSNotificationCenter.defaultCenter addObserverForName:UITextViewTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        UITextView * textView = note.object;
        if (textView.text.length > 0){
            self.model.review = textView.text;
        }
    }];
    UIButton * submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"  提交" forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [submit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"ic_submit"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submit];
}

- (void)submitAction{
    if (self.model.name.length == 0){
        [UIHelper showToast:@"请输入项目名称" toView:self.view];
        return;
    }
    if (!self.model.type){
        [UIHelper showToast:@"请选择项目类型" toView:self.view];
        return;
    }
    if (!self.model.classesId){
        [UIHelper showToast:@"请选择项目类别" toView:self.view];
        return;
    }
    if (!self.model.classesSecondLevelId){
        [UIHelper showToast:@"请选择项目二级类别" toView:self.view];
        return;
    }
    if (!self.model.groupId){
        [UIHelper showToast:@"请选择项目群体" toView:self.view];
        return;
    }
    if (!self.model.constructionUnit){
        [UIHelper showToast:@"请输入项目建设单位" toView:self.view];
        return;
    }
    if (self.model.addressName.length == 0){
        [UIHelper showToast:@"请输入项目地址名称" toView:self.view];
        return;
    }
    if (self.model.contacts.length == 0){
        [UIHelper showToast:@"请输入项目联系人" toView:self.view];
        return;
    }
    if (self.model.phone.length == 0){
        [UIHelper showToast:@"请输入项目联系人电话" toView:self.view];
        return;
    }
    if (self.model.review.length == 0){
        [UIHelper showToast:@"请输入项目综述" toView:self.view];
        return;
    }
    if (!self.model.subentryClassesId){
        [UIHelper showToast:@"请选择项目分项类别" toView:self.view];
        return;
    }
    if (!self.model.subentryClassesSecondLevelId){
        [UIHelper showToast:@"请选择项目二级分项类别" toView:self.view];
        return;
    }
    if (self.model.type.intValue == 3 && self.images.count == 0){
        [UIHelper showToast:@"请选择图片" toView:self.view];
        return;
    }
    if (self.model.type.intValue == 3){
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

- (void)uploadImages:(NSArray *)images completion:(void(^)(NSString *))completion{
    [APIRequest.shareInstance postUrl:Uploads params:@{} images:images success:^(NSDictionary * _Nonnull result) {
        completion(result[@"fileNames"]);
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)uploadParamsData{
    [APIRequest.shareInstance postUrl:AddProject params:[self.model mj_JSONObject] success:^(NSDictionary * _Nonnull result) {
        [UIHelper showToast:@"新建项目成功" toView:self.view];
        self.navigationController.viewControllers = @[[[NewProjectViewController alloc] init]];
        [NSNotificationCenter.defaultCenter postNotificationName:Add_Project_NOTIFICATION object:nil];
    } failure:^(NSString * _Nonnull errorMsg) {

    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:true];
    if (textField.tag == 1){
        [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"试用评测",@"督导评测",@"设计评估"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            textField.text = resultModel.value;
            self.model.type = [NSString stringWithFormat:@"%ld",resultModel.index+1];
            if (self.model.type.intValue == 3){
                self.imagesCellHeight = (SCREEN_WIDTH-60)/3+47;
            }else{
                self.imagesCellHeight = 0;
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:12 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return false;
    }else if (textField.tag == 2){
        [APIRequest.shareInstance getUrl:PcProjectClasses params:@{} success:^(NSDictionary * _Nonnull result) {
            self.classesArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self showPickerViewWithArray:self.classesArray textField:textField];
        } failure:^(NSString * _Nonnull errorMsg) {
            
        }];
        return false;
    }else if (textField.tag == 3){
        if (!self.model.classesId){
            [UIHelper showToast:@"请先选择项目类别" toView:self.view];
            return false;
        }
        [APIRequest.shareInstance getUrl:PcProjectClassesSecondLevel params:@{@"classesId":self.model.classesId} success:^(NSDictionary * _Nonnull result) {
            self.classesSecondArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (self.classesSecondArray.count == 0){
                [UIHelper showToast:@"未查询到项目二级类别,请联系管理人员添加" toView:self.view];
            }else{
                [self showMultipleSelectionViewWithTextField:textField dataArray:self.classesSecondArray];
            }
        } failure:^(NSString * _Nonnull errorMsg) {
            
        }];
        return false;
    }else if (textField.tag == 4){
        [APIRequest.shareInstance getUrl:PcProjectGroup params:@{} success:^(NSDictionary * _Nonnull result) {
            self.projectGroup = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self showMultipleSelectionViewWithTextField:textField dataArray:self.projectGroup];
        } failure:^(NSString * _Nonnull errorMsg) {
            
        }];
        return false;
    }else if (textField.tag == 11){
        [APIRequest.shareInstance getUrl:PcProjectSubentry params:@{} success:^(NSDictionary * _Nonnull result) {
            self.projectSubentry = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self showMultipleSelectionViewWithTextField:textField dataArray:self.projectSubentry];
        } failure:^(NSString * _Nonnull errorMsg) {

        }];
        return false;
    }else if (textField.tag == 12){
        if (!self.model.subentryClassesId){
            [UIHelper showToast:@"请选择项目分项类别" toView:self.view];
            return false;
        }
        [APIRequest.shareInstance getUrl:PcProjectSubentrySecondLevel params:@{@"subentryClassesId":self.model.subentryClassesId} success:^(NSDictionary * _Nonnull result) {
            self.projectSubentrySecondLevel = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self showMultipleSelectionViewWithTextField:textField dataArray:self.projectSubentrySecondLevel];
        } failure:^(NSString * _Nonnull errorMsg) {
            
        }];
        return false;
    }else if (textField.tag == 13){
        if (!self.model.subentryClassesSecondLevelId){
            [UIHelper showToast:@"请选择项目分项二级类别" toView:self.view];
            return false;
        }
        [APIRequest.shareInstance getUrl:ProjectEvaluationSituation params:@{@"ids":self.model.subentryClassesSecondLevelId} success:^(NSDictionary * _Nonnull result) {
            NSArray * modelArray = [ProjectModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            NSMutableArray * array = [[NSMutableArray alloc] init];
            [modelArray enumerateObjectsUsingBlock:^(ProjectModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.name = [NSString stringWithFormat:@"%@-%@",obj.name,obj.serialNumber];
                [array addObject:obj];
            }];
            self.projectEvaluationSituation = array;
            [self showMultipleSelectionViewWithTextField:textField dataArray:self.projectEvaluationSituation];
        } failure:^(NSString * _Nonnull errorMsg) {
            
        }];
        return false;
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0){
        return;
    }
    if (textField.tag == 0){
        self.model.name = textField.text;
    }else if (textField.tag == 5){
        self.model.constructionUnit = textField.text;
    }else if (textField.tag == 6){
        self.model.addressName = textField.text;
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
        search.delegate = self;
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.address = textField.text;
        geoCodeSearchOption.city = textField.text;
        BOOL flag = [search geoCode: geoCodeSearchOption];
        if (flag) {
            NSLog(@"geo检索发送成功");
        }  else  {
            NSLog(@"geo检索发送失败");
        }
    }else if (textField.tag == 7){
        self.model.contacts = textField.text;
    }else if (textField.tag == 8){
        self.model.phone = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isKindOfClass:[MLPAutoCompleteTextField class]]){
        [textField resignFirstResponder];
    }
    return true;
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.model.address = [NSString stringWithFormat:@"%.06f,%.06f",result.location.longitude,result.location.latitude];
        NSLog(@"===%@",self.model.address);
    } else {
        NSLog(@"检索失败");
        
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == self.dataArray.count-2){
        return false;
    }
    return true;
}

- (void)showMultipleSelectionViewWithTextField:(UITextField *)textField
                                     dataArray:(NSArray *)dataArray{
    MultipleSelectionView * selection = [[MultipleSelectionView alloc] init];
    BRStringPickerView * picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = textField.placeholder;
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
        if (textField.tag == 3){
            self.model.classesSecondLevelId = self.classesSecondArray[resultModel.index].Id;
        }else if (textField.tag == 4){
            self.model.groupId = [idArray componentsJoinedByString:@","];
        }else if (textField.tag == 11){
            self.model.subentryClassesId = [idArray componentsJoinedByString:@","];
        }else if (textField.tag == 12){
            self.model.subentryClassesSecondLevelId = [idArray componentsJoinedByString:@","];
        }else if (textField.tag == 13){
            self.model.basisId = [idArray componentsJoinedByString:@","];
            __block NSString * evaluationSituation = @"";
            [self.projectEvaluationSituation enumerateObjectsUsingBlock:^(ProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                evaluationSituation = [evaluationSituation stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@-%@\n%@\n\n",obj.name,obj.serialNumber,obj.content]];
            }];
            evaluationSituation = [evaluationSituation substringToIndex:evaluationSituation.length-2];
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[textField.tag+1]];
            [params setValue:evaluationSituation forKey:@"value"];
            [self.dataArray replaceObjectAtIndex:textField.tag+1 withObject:params];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        textField.text = [contentArray componentsJoinedByString:@","];
    };
    [picker show];
    [picker.alertView addSubview:selection];
}

- (void)showPickerViewWithArray:(NSArray<ProjectModel*> *)dataArray
                      textField:(UITextField *)textField{
    NSMutableArray * dataSource = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(ProjectModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dataSource addObject:obj.name];
    }];
    [BRStringPickerView showPickerWithTitle:nil dataSourceArr:dataSource selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        if (resultModel){
            textField.text = resultModel.value;
            if (textField.tag == 2){
                self.model.classesId = self.classesArray[resultModel.index].Id;
                self.model.classesSecondLevelId = nil;
                UITextField * tf = [self.tableView viewWithTag:3];
                tf.text = @"";
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"input"]){
        InputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InputTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.textField.placeholder = item[@"placeholder"];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        return cell;
    }else if ([item[@"type"] isEqualToString:@"location"]){
        LocationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LocationTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.textField.placeholder = item[@"placeholder"];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        cell.textField.autoCompleteTableBackgroundColor = UIColor.whiteColor;
        [cell.btn addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if ([item[@"type"] isEqualToString:@"select"]){
        SelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectTableViewCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = item[@"title"];
        cell.textField.placeholder = item[@"placeholder"];
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
    }else{
        ProjectDescTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDescTableViewCell class]) forIndexPath:indexPath];
        cell.content.placeholder = @"请输入项目综述";
        cell.content.tag = indexPath.row;
        cell.content.text = [item[@"value"] length] > 0 ? item[@"value"] : @"";
        cell.content.delegate = self;
        return cell;
    }
}

- (void)locationAction:(UIButton *)btn{
    LocationTableViewCell * cell = (LocationTableViewCell *)btn.superview.superview;
    LocationViewController * location = [[LocationViewController alloc] init];
    location.title = @"位置";
    location.locationCompletion = ^(CLLocationCoordinate2D centerCoordinate,NSString * addressName) {
        cell.textField.text = addressName;
        self.model.addressName = addressName;
        self.model.address = [NSString stringWithFormat:@"%.06f,%.06f",centerCoordinate.longitude,centerCoordinate.latitude];
    };
    location.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:location animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    if ([item[@"type"] isEqualToString:@"desc"]){
        NSString * title = item[@"title"];
        if ([title isEqualToString:@"evaluationSituation"]){
            NSString * value = item[@"value"];
            CGFloat valueHeight = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            if (value.length > 0){
                return valueHeight > 300 ? 300 : valueHeight;
            }else{
                return 0.01;
            }
        }else{
            return 82;
        }
    }else if ([item[@"type"] isEqualToString:@"image"]){
        if (self.model.type.intValue == 3){
            return self.imagesCellHeight+47;
        }else{
            return 0.01;
        }
    }
    return 44;
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
