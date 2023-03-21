//
//  ZXOpenResultsModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/6/21.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>


typedef NS_ENUM(NSUInteger, ZXCurrentNavType) {
    ZXCurrentNavType_Walk,
    ZXCurrentNavType_Drive
};

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultslnglatModel;
@class ZXOpenResultsNavigationlistModel;
@class ZXOpenResultsColorlistModel;

@interface ZXOpenResultsModel : NSObject

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSString *typenameStr;
@property (nonatomic, strong) NSString *typelogo;
@property (nonatomic, strong) NSString *boxid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *readAddress;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *buildName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *gotnum;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) ZXOpenResultslnglatModel *lnglat;
@property (nonatomic, strong) ZXOpenResultsNavigationlistModel *navigationlist;
@property (nonatomic, strong) NSString *expiretime;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger  indexid;
@property (nonatomic, strong) NSString  *mob;


@property (nonatomic, strong) ZXOpenResultsColorlistModel  *colorlist;
@property (nonatomic, strong) NSString  *arrivedtext;
@property (nonatomic, strong) NSArray *arrivedvarlist;
@property (nonatomic, strong) NSString  *beinpoint;
@property (nonatomic, strong) NSString  *commentpoint;
@property (nonatomic, strong) NSString  *sharepoint;
@property (nonatomic, strong) NSArray  *gotlist;
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, assign) NSInteger  islike;
@property (nonatomic, strong) NSArray *mycommentlist;

@property (nonatomic, assign) bool  selectBox;

//现在的导航模式 (1-步行、2-驾车)
@property (nonatomic, assign) ZXCurrentNavType  currentNavType;

//起始坐标
@property (nonatomic, strong) AMapNaviPoint *startPoint;

//是否有活动
@property (nonatomic, assign) NSInteger  activityinfo;
@property (nonatomic, strong) NSString  *url; //活动链接


@end




@interface ZXOpenResultslnglatModel : NSObject

@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;

@end





@interface ZXOpenResultsNavigationlistModel : NSObject

@property (nonatomic, strong) NSString *distance;

@end



@interface ZXOpenResultsColorlistModel : NSObject

@property (nonatomic, strong) NSString *textcolor;
@property (nonatomic, strong) NSString *bgcolor;
@property (nonatomic, strong) NSString *varcolor;

@end




@interface ZXOpenResultsItemsModel : NSObject

@property (nonatomic, strong) NSString *item;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
