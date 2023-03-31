//
//  LoginViewController.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "LoginViewController.h"
#import "UserInfoViewController.h"

@interface LoginViewController ()<UINavigationControllerDelegate>

@property(nonatomic,weak)IBOutlet UITextField * userName;
@property(nonatomic,weak)IBOutlet UITextField * password;

@end

@implementation LoginViewController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL hidden = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:hidden animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.delegate = self;
}

- (IBAction)change:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.password.secureTextEntry = !self.password.secureTextEntry;
}

- (IBAction)loginAction:(id)sender{
    if (![UIHelper checkTextField:self.userName toast:nil]){
        return;
    }
    if (![UIHelper checkTextField:self.password toast:nil]){
        return;
    }
    [APIRequest.shareInstance postUrl:Login params:@{@"userName":self.userName.text,@"password":self.password.text} success:^(NSDictionary * _Nonnull result) {
        [NSUserDefaults.standardUserDefaults setValue:result[TOKEN] forKey:TOKEN];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self getUserInfo];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getUserInfo{
    [APIRequest.shareInstance getUrl:UserInfo params:@{} success:^(NSDictionary * _Nonnull result) {
        BOOL isEdit = [result[@"user"][@"isEdit"] boolValue];
        if (!isEdit){
            UserInfoViewController * userInfo = [[UserInfoViewController alloc] init];
            userInfo.isEdit = isEdit;
            userInfo.user = result[@"user"];
            userInfo.title = @"个人信息";
            userInfo.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:userInfo animated:true];
        }else{
            [NSNotificationCenter.defaultCenter postNotificationName:Login_NOTIFICATION object:nil];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
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
