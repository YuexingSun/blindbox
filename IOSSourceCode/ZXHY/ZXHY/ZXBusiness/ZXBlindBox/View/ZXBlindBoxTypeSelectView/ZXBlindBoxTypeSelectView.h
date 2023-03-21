//
//  ZXBlindBoxTypeSelectView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxTypeSelectView;
@class ZXBlindBoxViewParentlistModel;

@protocol ZXBlindBoxTypeSelectViewDelegate <NSObject>
//出发
- (void)zx_goBlindBoxTypeSelectView:(ZXBlindBoxTypeSelectView *)typeSelectView;

@end



@interface ZXBlindBoxTypeSelectView : UIView

@property (nonatomic, weak) id <ZXBlindBoxTypeSelectViewDelegate> delegate;

//开启数据传入
- (void)zx_parentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;

//进行中据传入
- (void)zx_beginParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;




@end

NS_ASSUME_NONNULL_END
