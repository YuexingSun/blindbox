//
//  ZXVersionCheckUpdatesView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZXCheckUpType) {
    ZXCheckUpType_Normal,        //正常更新
    ZXCheckUpType_Compulsion,    //强制更新
};

typedef void (^CloseCheckUpdatesViewBlock) (void);

@class ZXVersionCheckUpdatesViewModel;

@interface ZXVersionCheckUpdatesView : UIView

//关闭按钮Block
@property (nonatomic, strong) CloseCheckUpdatesViewBlock  checkUpdatesViewBlock;

//更新类型
- (instancetype)initWithFrame:(CGRect)frame withVersionCheckUpdatesModel:(ZXVersionCheckUpdatesViewModel *)versionCheckUpdatesModel;

@end

NS_ASSUME_NONNULL_END
