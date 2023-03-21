//
//  ZXMineFooterCollectionReusableView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineFooterCollectionReusableView : UICollectionReusableView

+ (NSString *)wg_cellIdentifier;

- (void)zx_isHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
