//
//  ZXHomeModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZXHomeListLocationModel;

@interface ZXHomeModel : NSObject

@property (nonatomic, strong) NSArray   *list;
@property (nonatomic, strong) NSString  *totalnum;
@property (nonatomic, strong) NSString  *totalpage;
@property (nonatomic, strong) NSString  *currpage;

@end


@interface ZXHomeListModel : NSObject

@property (nonatomic, assign) NSInteger  type;
@property (nonatomic, strong) NSString  *typeId;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *banner;
@property (nonatomic, strong) NSString  *bgimg;
@property (nonatomic, strong) NSString  *subtitle;
@property (nonatomic, strong) NSString  *btntxt;
@property (nonatomic, strong) NSString  *bannernumber;
@property (nonatomic, strong) NSArray  *bannerlist;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *sendtime;
@property (nonatomic, strong) NSString  *likenumber;
@property (nonatomic, assign) bool  isliked;
@property (nonatomic, strong) NSString  *commentnumber;
@property (nonatomic, assign) bool  ismine;
@property (nonatomic, strong) NSString  *favnumber;
@property (nonatomic, assign) bool  isfaved;
@property (nonatomic, strong) ZXHomeListLocationModel  *location;
@property (nonatomic, strong) NSArray   *gotavatarlist;
@property (nonatomic, strong) NSString  *h5url;
@property (nonatomic, strong) NSString  *boxId;
@property (nonatomic, strong) UIImage  *bannerImg;

//cell高度
@property (nonatomic, assign) CGFloat  cellHeight;

//bannerSize
@property (nonatomic, assign) CGSize   bannerSize;


//是否从其他页面进入
@property (nonatomic, assign) bool  isOtherEnter;

@property (nonatomic, assign) NSInteger  index;

@end


@interface ZXHomeListLocationModel : NSObject

@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *lng;
@property (nonatomic, strong) NSString  *lat;

@property (nonatomic, strong) NSString  *detailaddress; //"地点地址",
@property (nonatomic, strong) NSString  *point;  //"地点评分",
              

@end

NS_ASSUME_NONNULL_END
