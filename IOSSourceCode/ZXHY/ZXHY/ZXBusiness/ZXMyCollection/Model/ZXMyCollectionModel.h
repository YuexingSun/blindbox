//
//  ZXMyCollectionModel.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyCollectionModel : NSObject


@property (nonatomic, strong) NSArray   *list;

@property (nonatomic, strong) NSString  *totalnum;
@property (nonatomic, strong) NSString  *totalpage;
@property (nonatomic, strong) NSString  *currpage;

@end

@interface ZXMyCollectionListModel : NSObject

@property (nonatomic, strong) NSString  *typeId;
@property (nonatomic, strong) NSString  *banner;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *sendtime;

@end

NS_ASSUME_NONNULL_END
