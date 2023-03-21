//
//  WGBaseTableView.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WGEmptyView;

@interface WGBaseTableView : UITableView

@property (nonatomic, strong) WGEmptyView *wg_emptyView;
@property (nonatomic, assign) BOOL wg_needEmptyView;

- (void)wg_addObserver;

- (void)wg_initBaseTableViewEmptyViewWithImageName:(NSString *)imageName tips:(NSString *)tips reloadDataText:(NSString *)reloadDataText;
- (void)wg_initBaseTableViewLogoEmptyViewWithImageName:(NSString *)imageName tips:(NSString *)tips reloadDataText:(NSString *)reloadDataText;

@end
