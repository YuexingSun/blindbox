//
//  ZXHumanMachineCertificationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "ZXHumanMachineCertificationModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXHumanMachineCertificationView;

@protocol ZXHumanMachineCertificationViewDelegate <NSObject>

//关闭响应
- (void)closeCertificationView:(ZXHumanMachineCertificationView *)certificationView ;

//认证成功响应
- (void)successfulCertificationView:(ZXHumanMachineCertificationView *)certificationView withHumanMachineCertificationModel:(ZXHumanMachineCertificationModel *)certificationModel;

@end

@interface ZXHumanMachineCertificationView : UIView

@property (nonatomic, weak) id <ZXHumanMachineCertificationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
