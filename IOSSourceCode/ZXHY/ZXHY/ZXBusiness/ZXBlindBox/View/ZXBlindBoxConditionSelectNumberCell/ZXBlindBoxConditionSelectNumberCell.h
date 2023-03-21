//
//  ZXBlindBoxConditionSelectNumberCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  ZXBlindBoxSelectViewModel,ZXBlindBoxSelectViewItemlistModel;


@protocol ZXBlindBoxConditionSelectNumberCellDelegate <NSObject>
//出发选择model
- (void)zx_goSelectItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel;

@end


@interface ZXBlindBoxConditionSelectNumberCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel;

@property (nonatomic, weak) id <ZXBlindBoxConditionSelectNumberCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
