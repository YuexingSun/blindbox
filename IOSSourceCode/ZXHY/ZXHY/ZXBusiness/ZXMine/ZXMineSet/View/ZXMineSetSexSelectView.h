//
//  ZXMineSetSexSelectView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineSetSexSelectView;

@protocol ZXMineSetSexSelectViewDelegate <NSObject>

//取消 响应
- (void)closeSexSelectView:(ZXMineSetSexSelectView *)sexView;

//确定 响应
- (void)sureSexSelectView:(ZXMineSetSexSelectView *)sexView SelectStr:(NSString *)str;

@end

@interface ZXMineSetSexSelectView : UIView

@property (nonatomic, weak) id <ZXMineSetSexSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
