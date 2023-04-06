//
//  UserInfoViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
@import BRPickerView;

@interface UserInfoViewController ()<UITextFieldDelegate,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSMutableDictionary * params;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.params = [[NSMutableDictionary alloc] init];
    [self.params setValue:self.user[@"userId"] forKey:@"userId"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ UserInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserInfoTableViewCell class])];
    NSInteger sexValue = [self.user[@"sex"] integerValue];
    NSString * sex = @"";
    if (sexValue == 0){
        sex = @"男";
    }else if (sexValue == 1){
        sex = @"女";
    }else if (sexValue == 2){
        sex = @"未知";
    }
    self.dataArray = @[
        @{@"title":@"姓名",@"value":self.user[@"nickName"]?:@"",@"type":@"normal"},
        @{@"title":@"账号",@"value":self.user[@"userName"],@"type":@"normal"},
        @{@"title":@"职位",@"value":[self.user[@"position"] isEqual:[NSNull null]] ? @"无" : self.user[@"position"],@"type":@"normal"},
        @{@"title":@"性别",@"value":sex,@"type":@"select"},
        @{@"title":@"出生年月日",@"value":self.user[@"birthday"]?[NSString stringWithFormat:@"%@",self.user[@"birthday"]]:@"",@"type":@"select"},
        @{@"title":@"政治面貌",@"value":self.user[@"politicsStatus"]?:@"",@"type":@"input"},
        @{@"title":@"工作单位",@"value":self.user[@"workUnit"]?:@"",@"type":@"input"},
        @{@"title":@"学历",@"value":self.user[@"education"]?:@"",@"type":@"input"},
        @{@"title":@"联系方式",@"value":self.user[@"phonenumber"]?:@"",@"type":@"input"},
    ];
    
    UIButton * submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@" 提交" forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [submit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"ic_edit_submit"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(editUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submit];
}

- (void)editUserInfoAction{
    if (![self.params objectForKey:@"sex"]){
        [UIHelper showToast:@"请选择性别" toView:self.view];
        return;
    }
    if (![self.params objectForKey:@"birthday"]){
        [UIHelper showToast:@"请选择出生年月日" toView:self.view];
        return;
    }
    if (![self.params objectForKey:@"politicsStatus"]){
        [UIHelper showToast:@"请选择政治面貌" toView:self.view];
        return;
    }
    if (![self.params objectForKey:@"workUnit"]){
        [UIHelper showToast:@"请输入工作单位" toView:self.view];
        return;
    }
    if (![self.params objectForKey:@"education"]){
        [UIHelper showToast:@"请选择学历" toView:self.view];
        return;
    }
    if (![self.params objectForKey:@"phonenumber"]){
        [UIHelper showToast:@"请输入联系方式" toView:self.view];
        return;
    }
    [APIRequest.shareInstance putUrl:EditUserInfo params:self.params success:^(NSDictionary * _Nonnull result) {
        if (self.updateInfoCompletion){
            self.updateInfoCompletion();
        }
        if (!self.isEdit){
            [NSNotificationCenter.defaultCenter postNotificationName:Login_NOTIFICATION object:nil];
        }else{
            [UIHelper showToast:@"修改成功" toView:self.view];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:true];
    if (textField.tag == 0){
        return true;
    }
    if (textField.tag == 1 ||  textField.tag == 2){
        return false;
    }else if (textField.tag == 3){
        [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"男",@"女",@"未知"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            textField.text = resultModel.value;
            [self.params setValue:@(resultModel.index) forKey:@"sex"];
        }];
        return false;
    }else if (textField.tag == 4){
        [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:nil selectValue:nil minDate:nil maxDate:NSDate.date isAutoSelect:false resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            textField.text = selectValue;
            [self.params setValue:[selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"birthday"];
        }];
        return false;
    }else if (textField.tag == 5){
        [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"党员",@"预备党员",@"共青团员",@"群众",@"其他"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            textField.text = resultModel.value;
            [self.params setValue:resultModel.value forKey:@"politicsStatus"];
        }];
        return false;
    }else if (textField.tag == 7){
        [BRStringPickerView showPickerWithTitle:nil dataSourceArr:@[@"小学",@"初中",@"高中",@"大专",@"本科",@"本科以上",@"其他"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            textField.text = resultModel.value;
            [self.params setValue:textField.text forKey:@"education"];
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
        [self.params setValue:textField.text forKey:@"nickName"];
    }else if (textField.tag == 6){
        [self.params setValue:textField.text forKey:@"workUnit"];
    }else if (textField.tag == 8){
        [self.params setValue:textField.text forKey:@"phonenumber"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserInfoTableViewCell class]) forIndexPath:indexPath];
    NSDictionary * obj = self.dataArray[indexPath.section];
    cell.titleLabel.text = obj[@"title"];
    cell.content.placeholder = [obj[@"type"] isEqual:@"input"] ? @"请输入" : @"请选择";
    cell.content.text = obj[@"value"];
    cell.content.delegate = self;
    cell.content.tag = indexPath.section;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
