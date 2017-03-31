//
//  MainTabBarViewController.m
//  Nav+Tab
//
//  Created by ugamehome on 16/9/12.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MainNavigationController.h"
#import "Text1ViewController.h"
#import "Text2ViewController.h"
#import "Text3ViewController.h"
#import "Text4ViewController.h"
#import "Text5ViewController.h"


@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabarItem];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTabarItem{
    NSArray *titles = @[@"发现", @"关注", @"消息", @"我的",@"是我"];
    NSArray *images = @[@"tab_home", @"tab_product", @"tab_cart", @"tab_activity",@"tab_more"];
    NSArray *selectedImages = @[@"tab_home_seleced", @"tab_product_seleced", @"tab_cart_seleced", @"tab_activity_seleced",@"tab_more_seleced"];
    
    Text1ViewController * homeVc = [[Text1ViewController alloc] init];
    MainNavigationController *homeNav = [self SetupChildVc:homeVc title:titles[0] image:images[0] selectedImage:selectedImages[0]];
    
    Text2ViewController * subscriptionVc = [[Text2ViewController alloc] init];
    MainNavigationController *subscriptionNav =  [self SetupChildVc:subscriptionVc title:titles[1] image:images[1] selectedImage:selectedImages[1]];
    
    Text3ViewController * notificationVc = [[Text3ViewController alloc] init];
    MainNavigationController *notificationNav =  [self SetupChildVc:notificationVc title:titles[2] image:images[2] selectedImage:selectedImages[2]];
    
    Text4ViewController * meVc = [[Text4ViewController alloc] init];
    MainNavigationController *meNav = [self SetupChildVc:meVc title:titles[3] image:images[3] selectedImage:selectedImages[3]];
    
    Text5ViewController * meVc1 = [[Text5ViewController alloc] init];
    MainNavigationController *meNav1 = [self SetupChildVc:meVc1 title:titles[4] image:images[4] selectedImage:selectedImages[4]];
    
    NSArray *viewControllers = @[homeNav, subscriptionNav, notificationNav, meNav,meNav1];

    self.viewControllers = viewControllers;
//    self.toolbarItems = viewControllers;
    
}



- (MainNavigationController*)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    UIImage *musicImage = [UIImage imageNamed:imageName];
    UIImage *musicImageSel = [UIImage imageNamed:selectedImageName];
    
    musicImage = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    musicImageSel = [musicImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:musicImage selectedImage:musicImageSel];
    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    NSLog(@"childVc-->%@",childVc);
    NSLog(@"childVc.tabViewController -->%@",childVc.tabBarController);
    NSLog(@"%ld",self.selectedIndex);
    
    
    return nav;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UITabBarItem *items = item;
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
