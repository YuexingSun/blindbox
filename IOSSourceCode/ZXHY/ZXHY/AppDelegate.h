//
//  AppDelegate.h
//  ZXHY
//
//  Created by Bern Mac on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "WGBaseTabBarController.h"
#import "ZXBaseTabBarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) WGBaseTabBarController *tabBarController;
@property (nonatomic, assign) NSInteger  homeType;
@property (nonatomic, strong) ZXBaseTabBarController *tabBarController;

@end

