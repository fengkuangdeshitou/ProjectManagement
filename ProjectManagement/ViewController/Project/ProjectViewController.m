//
//  ProjectViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import "ProjectViewController.h"
#import "ProjectContainerView.h"
#import "ProjectFiltrateAlertView.h"

@interface ProjectViewController ()

@property(nonatomic,weak)IBOutlet UIScrollView * scrollView;
@property(nonatomic,weak)IBOutlet UIView * contentView;
@property(nonatomic,strong) ProjectFiltrateAlertView * filtrateView;

@end

@implementation ProjectViewController

- (ProjectFiltrateAlertView *)filtrateView{
    if (!_filtrateView){
        _filtrateView = [[ProjectFiltrateAlertView alloc] initWithFrame:CGRectMake(0, NavagationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavagationHeight)];
        __weak typeof(self) weakSelf = self;
        _filtrateView.onTagBlock = ^{
            [weakSelf projectFiltrateAction:weakSelf.navigationItem.rightBarButtonItem.customView];
        };
    }
    return _filtrateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isPrivate){
        UIButton * delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setTitle:@"  删除" forState:UIControlStateNormal];
        delete.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [delete setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [delete setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteProjectAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delete];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"项目列表" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIButton * filtrate = [UIButton buttonWithType:UIButtonTypeCustom];
        [filtrate setTitle:@"  筛选" forState:UIControlStateNormal];
        filtrate.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [filtrate setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [filtrate setImage:[UIImage imageNamed:@"ic_filtrate"] forState:UIControlStateNormal];
        [filtrate addTarget:self action:@selector(projectFiltrateAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filtrate];
    }
    NSArray * type = @[@"2",@"1",@"3"];
    for (int i=0; i<3; i++) {
        ProjectContainerView * container = [[ProjectContainerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavagationHeight-74-(self.isPrivate?0:TabbarHeight))];
        container.type = type[i];
        container.isPrivate = self.isPrivate;
        [self.scrollView addSubview:container];
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    [self buttonClickAction:[self.contentView viewWithTag:10]];
}

- (void)projectFiltrateAction:(UIButton *)btn{
    [UIApplication.sharedApplication.keyWindow addSubview:self.filtrateView];
    self.filtrateView.hidden = btn.selected;
    btn.selected = !btn.selected;
}

- (void)deleteProjectAction{
    [NSNotificationCenter.defaultCenter postNotificationName:Select_Project_NOTIFICATION object:nil];
}

- (IBAction)buttonClickAction:(UIButton *)sender{
    for (UIButton * btn in self.contentView.subviews) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#E5EBFC"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#555C6D"] forState:UIControlStateNormal];
    }
    [sender setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
    [self.scrollView setContentOffset:CGPointMake((sender.tag-10)*SCREEN_WIDTH, 0) animated:true];
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
