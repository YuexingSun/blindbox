//
//  ZXBlindBoxConditionSelectMoodCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewModel,ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxConditionSelectMoodCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel NumberModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel DataList:(NSMutableArray *)dataList;

@end

NS_ASSUME_NONNULL_END
