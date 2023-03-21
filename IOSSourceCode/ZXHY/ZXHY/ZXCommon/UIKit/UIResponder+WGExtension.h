//
//  UIResponder+WGExtension.h
//  WG_Common
//
//  Created by apple on 2021/5/18.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (WGExtension)

- (void)routerWithPushController:(UIViewController *)viewController;

- (void)routerWithPopController;

- (void)transportName:(NSString *)eventName info:(NSDictionary * _Nullable)userInfo NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
