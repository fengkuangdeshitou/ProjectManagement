//
//  MineViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "UserInfoViewController.h"
#import "ProjectViewController.h"
#import "AuditCenterViewController.h"
@import SDWebImage;

@interface MineViewController ()<UINavigationControllerDelegate,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * titleTop;
@property(nonatomic,weak)IBOutlet UIView * headerView;
@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet UIButton * logoutBtn;
@property(nonatomic,weak)IBOutlet UIImageView * avatar;
@property(nonatomic,weak)IBOutlet UILabel * nickname;
@property(nonatomic,weak)IBOutlet UILabel * position;
@property(nonatomic,weak)IBOutlet UILabel * createBy;
@property(nonatomic,strong) NSDictionary * user;
@property(nonatomic,strong) NSString * messageCount;

@end

@implementation MineViewController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL hidden = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:hidden animated:true];
    [self getCheckInformNum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.delegate = self;
    self.titleTop.constant = StatusBarHeight;
    CAGradientLayer * layer = [[CAGradientLayer alloc] init];
    layer.colors = @[(id)[UIColor colorWithHexString:@"#48ACF4"].CGColor,(id)[UIColor colorWithHexString:@"#2F69FC"].CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320);
    [self.headerView.layer insertSublayer:layer atIndex:0];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineTableViewCell class])];
    self.tableView.layer.cornerRadius = 30;
    self.tableView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.logoutBtn.layer.borderColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR].CGColor;
    self.logoutBtn.layer.borderWidth = 1;
    [self getUserInfo];
}

- (void)getUserInfo{
    [APIRequest.shareInstance getUrl:UserInfo params:@{} success:^(NSDictionary * _Nonnull result) {
        self.user = result[@"user"];
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.user[@"avatar"]] placeholderImage:nil];
        self.nickname.text = self.user[@"nickName"];
        self.position.text = [NSString stringWithFormat:@"  %@  ",[self.user[@"position"] isEqual:[NSNull null]] ? @"无" : self.user[@"position"]];
        self.createBy.text = self.user[@"userName"];
        self.position.layer.cornerRadius = 12;
        self.position.layer.masksToBounds = true;
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)getCheckInformNum{
    [APIRequest.shareInstance getUrl:CheckInformNum params:@{} success:^(NSDictionary * _Nonnull result) {
        NSInteger count = [result[@"data"] intValue];
        if (count == 0){
            self.messageCount = @"";
        }else{
            self.messageCount = [NSString stringWithFormat:@"%ld",count];
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (IBAction)logoutAction:(id)sender{
    [NSUserDefaults.standardUserDefaults removeObjectForKey:TOKEN];
    [NSNotificationCenter.defaultCenter postNotificationName:Logout_NOTIFICATION object:nil];
}

- (IBAction)editUserInfoAction:(id)sender{
    UserInfoViewController * userInfo = [[UserInfoViewController alloc] init];
    userInfo.isEdit = [self.user[@"isEdit"] boolValue];
    userInfo.user = self.user;
    userInfo.updateInfoCompletion = ^{
        [self getUserInfo];
    };
    userInfo.title = @"个人信息";
    userInfo.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:userInfo animated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.icon.image = [UIImage imageNamed:@"ic_mine0"];
        cell.titleLabel.text = @"我的项目";
        cell.content.text = @"";
    }else{
        cell.icon.image = [UIImage imageNamed:@"ic_mine1"];
        cell.titleLabel.text = @"审核通知";
        cell.content.text = self.messageCount;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        ProjectViewController * project = [[ProjectViewController alloc] init];
        project.title = @"我的项目";
        project.isPrivate = true;
        project.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:project animated:true];
    }else{
        AuditCenterViewController * audit = [[AuditCenterViewController alloc] init];
        audit.title = @"审核中心";
        audit.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:audit animated:true];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
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
