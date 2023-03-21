//
//  ZXHomeAdModel.h
//  ZXHY
//
//  Created by Bern Lin on 2022/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeAdModel : NSObject

@property (nonatomic, strong) NSString  *param;
@property (nonatomic, strong) NSString  *targettype;
@property (nonatomic, strong) NSString  *pic;
@property (nonatomic, assign) bool  showpic;

@end


@interface ZXHomeTopAdModel : NSObject


@property (nonatomic, assign) NSInteger  bannertype;
@property (nonatomic, strong) NSArray  *list;

@end

NS_ASSUME_NONNULL_END
