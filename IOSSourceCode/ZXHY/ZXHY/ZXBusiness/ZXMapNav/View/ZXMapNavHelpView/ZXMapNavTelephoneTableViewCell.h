//
//  ZXMapNavTelephoneTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMapNavTelephoneTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, strong) UILabel *numberLabel;

@end

NS_ASSUME_NONNULL_END
