//
//  ZXBlindBoxSelectViewModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBlindBoxSelectViewModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSDictionary  *itemdict;
@property (nonatomic, strong) NSArray  *itemlist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger selectIndex;

/*
 tag: 标签选择样式
 range:选择距离样式
 image:选择图片样式
*/
@property (nonatomic, strong) NSString *type;



@end



@interface ZXBlindBoxSelectViewMainModel : NSObject

@property (nonatomic, strong) NSArray  *list;
@property (nonatomic, assign) NSInteger  pagenum;

@end


@interface ZXBlindBoxSelectViewItemlistModel : NSObject

@property (nonatomic, strong) NSString      *itemid;
@property (nonatomic, strong) NSString      *itemname;
@property (nonatomic, strong) NSString      *itempic;
@property (nonatomic, strong) NSString      *itemselpic;
@property (nonatomic, assign) NSInteger     isdefault;
@property (nonatomic, strong) NSString      *imglistname;
@property (nonatomic, assign) bool          select;


@end

NS_ASSUME_NONNULL_END
