//
//  ZXMsgEmojiCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMsgEmojiCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_typeImage:(UIImage *)img;

@end

NS_ASSUME_NONNULL_END
