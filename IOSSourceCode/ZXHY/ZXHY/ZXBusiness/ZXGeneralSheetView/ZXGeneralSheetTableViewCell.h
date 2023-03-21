//
//  ZXGeneralSheetTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGeneralSheetTableViewCell : UITableViewCell
+ (NSString *)wg_cellIdentifier;

- (void)zx_setLabelText:(NSString *)text TextColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
