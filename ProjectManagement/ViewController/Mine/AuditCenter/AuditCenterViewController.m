//
//  AuditCenterViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "AuditCenterViewController.h"
#import "AuditTableViewCell.h"

@interface AuditCenterViewController ()<UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@end

@implementation AuditCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getAuditData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuditTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuditTableViewCell class])];
}

- (void)getAuditData{
    [APIRequest.shareInstance getUrl:CheckInformList params:@{} success:^(NSDictionary * _Nonnull result) {
        self.dataArray = result[@"data"];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuditTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
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
