//
//  TabbarViewController.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/29.
//

#import "TabbarViewController.h"
#import "NavigationViewController.h"
#import "ProjectViewController.h"
#import "NewProjectViewController.h"
#import "MineViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTabBarItemTextAttributes];
    [self setUpChildViewController];
    
}

- (void)setUpTabBarItemTextAttributes{
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#B8BECD"];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
        appearance.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.05];
        appearance.backgroundColor = [UIColor whiteColor];
        [self.tabBar setStandardAppearance:appearance];
        if (@available(iOS 15.0, *)) {
            [self.tabBar setScrollEdgeAppearance:appearance];
        } else {
            // Fallback on earlier versions
        }
    }else{
        self.tabBar.shadowImage = [UIImage new];
        self.tabBar.backgroundImage = [UIImage new];
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-27, -10, 54, 54)];
    view.backgroundColor = UIColor.whiteColor;
    view.layer.cornerRadius = 27;
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 36, 36)];
    bg.image = [UIImage imageNamed:@"ic_tab_bg"];
    [view addSubview:bg];
    
    UIImageView * add = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 18, 18)];
    add.image = [UIImage imageNamed:@"ic_tab_add"];
    [bg addSubview:add];
    
    [self.tabBar addSubview:view];
    [self addShadowForView:self.tabBar];
}

- (void)addShadowForView:(UIView *)view{
    view.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.05].CGColor;
    view.layer.shadowRadius = 10;
    view.layer.shadowOpacity = 1;
    view.layer.shadowOffset = CGSizeMake(0, -4);
}

- (void)setUpChildViewController{
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    [self addOneChildViewController:[[NavigationViewController alloc]initWithRootViewController:[[ProjectViewController alloc]init]]
                          WithTitle:@"项目"
                          imageName:@"tabbar_home_normal"
                  selectedImageName:@"tabbar_home_active"];
    
    [self addOneChildViewController:[[NavigationViewController alloc]initWithRootViewController:[[NewProjectViewController alloc] init]]
                          WithTitle:@""
                          imageName:@""
                  selectedImageName:@""];
    
    [self addOneChildViewController:[[NavigationViewController alloc]initWithRootViewController:[[MineViewController alloc]init]]
                          WithTitle:@"我的"
                          imageName:@"tabbar_mine_normal"
                  selectedImageName:@"tabbar_mine_active"];
    
}

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    
    viewController.view.backgroundColor     = [UIColor whiteColor];
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
    
}

- (void)addOneNewChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    
    viewController.view.backgroundColor     = [UIColor whiteColor];
    viewController.tabBarItem.title         = title;
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    viewController.tabBarItem.image         = image;
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 10)];
    [self addChildViewController:viewController];
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
