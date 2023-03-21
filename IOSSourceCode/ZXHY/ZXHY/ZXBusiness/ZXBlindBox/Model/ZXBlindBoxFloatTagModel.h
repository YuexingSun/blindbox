//
//  ZXBlindBoxFloatTagModel.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBlindBoxFloatTagModel : NSObject

@property (nonatomic, strong) NSArray  *colorlist;
@property (nonatomic, strong) NSArray  *catelist;

@end

@interface ZXBlindBoxFloatTagColorListModel : NSObject

@property (nonatomic, strong) NSString  *txtcolor;
@property (nonatomic, strong) NSString  *bgcolor;
@property (nonatomic, strong) NSString  *linecolor;

@end


@interface ZXBlindBoxFloatTagCatelistModel : NSObject

@property (nonatomic, strong) NSString  *cateid;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, assign) CGFloat  itemWidh;

@end

NS_ASSUME_NONNULL_END
