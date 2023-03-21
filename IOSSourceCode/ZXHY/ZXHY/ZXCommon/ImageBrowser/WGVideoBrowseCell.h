//
//  WGVideoBrowseCell.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YBImageBrowser/YBIBCellProtocol.h>
#import "WGIBVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGVideoBrowseCell : UICollectionViewCell<YBIBCellProtocol>

@property (nonatomic, strong) WGIBVideoView *videoView;

@end

NS_ASSUME_NONNULL_END
