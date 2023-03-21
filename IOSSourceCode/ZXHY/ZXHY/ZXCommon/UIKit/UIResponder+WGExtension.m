//
//  UIResponder+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/5/18.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "UIResponder+WGExtension.h"

@implementation UIResponder (WGExtension)

- (void)routerWithPushController:(UIViewController *)viewController
{
    [self transportName:@"kPushController" info:@{@"viewController":viewController}];
}

- (void)routerWithPopController
{
    [self transportName:@"kPopController" info:nil];
}

- (void)transportName:(NSString *)eventName info:(NSDictionary *)userInfo
{
    [[self nextResponder] transportName:eventName info:userInfo];
}

@end
