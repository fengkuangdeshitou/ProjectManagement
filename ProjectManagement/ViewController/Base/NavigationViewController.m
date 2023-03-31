//
//  NavigationViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightHeavy]};
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance * appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
        appearance.backgroundImage = [UIImage new];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.compactAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // Fallback on earlier versions

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
