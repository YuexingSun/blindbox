//
//  CustomUIViewController.h
//  DevDemoNavi
//
//  Created by eidan on 2018/5/11.
//  Copyright © 2018年 Amap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGBaseViewController.h"


@class ZXOpenResultsModel,ZXBlindBoxViewParentlistModel;

@interface CustomUIViewController : WGBaseViewController

//传入数据
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel;



@end
