//
//  ZXGeneralSheetView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CancelTag 99999

@class  ZXGeneralSheetView;

@protocol ZXGeneralSheetViewDelegate <NSObject>

//按钮 响应
- (void)zx_generalSheetView:(ZXGeneralSheetView *)sheetView Index:(NSUInteger)index;

@end


@interface ZXGeneralSheetView : UIView

@property (nonatomic, weak) id <ZXGeneralSheetViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray <NSString *>*)dataSourceArray DataColor:(NSMutableArray <UIColor *> *)dataColorArray;

@property (nonatomic, assign) NSUInteger  sheetViewType;

@end

NS_ASSUME_NONNULL_END
