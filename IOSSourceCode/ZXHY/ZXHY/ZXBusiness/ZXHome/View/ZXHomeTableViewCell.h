//
//  ZXHomeTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeModel,ZXHomeListModel;

@interface ZXHomeTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

+ (CGFloat)zx_heightWithListModel:(ZXHomeListModel *)listModel;

- (void)zx_setListModel:(ZXHomeListModel *)listModel;


/*
 * 和当前时间进行比较  输出字符串为（刚刚几个小时前 几天前 ）
 * 需要传入的时间格式 2017-06-14 14:18:54
 */
+ (NSString *)zx_compareCurrentTime:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
