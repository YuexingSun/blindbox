//
//  ZXMineModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineMemberInfoModel;
@class ZXMineMyBeingBoxListModel;
@class ZXMineUserProfileModel;
@class ZXMineLastSevenDaysModel;


@interface ZXMineModel : NSObject

@property (nonatomic, strong) NSString  *myboxnum;
@property (nonatomic, strong) NSString  *mypropsnum;
@property (nonatomic, strong) NSString  *servicewechat;
@property (nonatomic, strong) NSArray  *myachievelist;

@property (nonatomic, strong) ZXMineMemberInfoModel  *memberinfo;
@property (nonatomic, strong) ZXMineMyBeingBoxListModel  *mybeingboxlist;
@property (nonatomic, strong) ZXMineLastSevenDaysModel *last7days;

@end



@interface ZXMineUserProfileModel : NSObject

@property (nonatomic, strong) NSString  *headimg;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *mob;
@property (nonatomic, strong) NSString  *age;
@property (nonatomic, strong) NSString  *sex;
@property (nonatomic, strong) NSString  *notifystatus;
@property (nonatomic, strong) NSArray   *taglist;

@end


@interface ZXMineMemberInfoModel : NSObject

@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *nowlevel;
@property (nonatomic, strong) NSString  *levelpoint;
@property (nonatomic, strong) NSString  *nextlevel;
@property (nonatomic, strong) NSString  *nextlevelpoint;
@property (nonatomic, strong) NSString  *nowpoint;
@property (nonatomic, strong) NSString  *nextpoint;

@end


@interface ZXMineMyBeingBoxListModel : NSObject

@property (nonatomic, strong) NSString  *beingbox;
@property (nonatomic, strong) NSString  *boxid;
@property (nonatomic, strong) NSString  *status;

@end


@interface ZXMineMyAchieveListModel : NSObject

@property (nonatomic, strong) NSString  *achieveid;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *pic;
@property (nonatomic, strong) NSString  *lightpic;
@property (nonatomic, assign) NSInteger  islight;


@end



@interface ZXMineLastSevenDaysModel : NSObject

@property (nonatomic, strong) NSString  *boxnumber;
@property (nonatomic, strong) NSArray   *catelist;

@end



@interface ZXMineLastSevenDaysCatelistModel : NSObject

@property (nonatomic, strong) NSString  *cateid;
@property (nonatomic, strong) NSString  *catename;
@property (nonatomic, strong) NSString  *number;

@end

NS_ASSUME_NONNULL_END
