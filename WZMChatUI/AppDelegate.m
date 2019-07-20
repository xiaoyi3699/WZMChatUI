//
//  AppDelegate.m
//  WZMChatUI
//
//  Created by WangZhaomeng on 2019/7/20.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "AppDelegate.h"
#import "LLUserViewController.h"
#import "LLSessionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UITabBarController *rootVC = [[UITabBarController alloc] init];
    rootVC.tabBar.translucent = NO;
    
    LLSessionViewController *firstViewController = [[LLSessionViewController alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    LLUserViewController *secondViewController = [[LLUserViewController alloc] init];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    [rootVC setViewControllers:@[firstNav,secondNav]];
    [self setConfig:rootVC];
    
    [self.window setRootViewController:rootVC];
    
    //禁止多点触控
    [[UIView appearance] setExclusiveTouch:YES];
    
    NSLog(@"%@",NSHomeDirectory());
    
    return YES;
}

- (void)setConfig:(UITabBarController *)tabBarController {
    NSArray *titles = @[@"会话",@"好友"];
    NSArray *normalImages = @[@"chat_tabbar_session_normal",@"chat_tabbar_friend_normal"];
    NSArray *selectImages = @[@"chat_tabbar_session_selected",@"chat_tabbar_friend_selected"];
    
    for (NSInteger i = 0; i < tabBarController.viewControllers.count; i ++) {
        
        UIViewController *viewController = tabBarController.viewControllers[i];
        
        UIColor *color = [UIColor colorWithRed:34/255. green:207/255. blue:172/255. alpha:1];
        NSDictionary *atts = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSDictionary *selAtts = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:12]};
        
        UIImage *img = [[UIImage imageNamed:normalImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImg = [[UIImage imageNamed:selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        viewController.tabBarItem.title = titles[i];
        viewController.tabBarItem.image = img;
        viewController.tabBarItem.selectedImage = selImg;
        [viewController.tabBarItem setTitleTextAttributes:atts forState:UIControlStateNormal];
        [viewController.tabBarItem setTitleTextAttributes:selAtts forState:UIControlStateSelected];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
