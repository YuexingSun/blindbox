//
//  ZXBlindBoxViewModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/30.
//

#import <Foundation/Foundation.h>
#import "ZXOpenResultsModel.h"
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBlindBoxViewModel : NSObject

@property (nonatomic, strong) NSArray  *parentlist;
@property (nonatomic, assign) NSUInteger  selparentindex;//选定的首层数据索引
@property (nonatomic, assign) NSUInteger  selchildindex; //选定的第二层数据索引;
@property (nonatomic, assign) NSUInteger  heartid; //提交时选中的心情id;
@property (nonatomic, strong) NSString    *heartimg;

@end



@interface ZXBlindBoxViewParentlistModel : NSObject

@property (nonatomic, assign) NSInteger  isBegin;
@property (nonatomic, assign) NSInteger  range;
@property (nonatomic, strong) NSArray  *childlist;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
//选中的index
@property (nonatomic, assign) NSInteger  selectIndex;

@end


NS_ASSUME_NONNULL_END
