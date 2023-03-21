//
//  ZXSearchLocationTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/31.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchLocationTableViewCell : UITableViewCell
+ (NSString *)wg_cellIdentifier;
- (void)zx_setAMapPOI:(AMapPOI *)mapPOI;

@end

NS_ASSUME_NONNULL_END
