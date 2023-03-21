//
//  ZXMineBoxListModel.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineBoxModel : NSObject

@property (nonatomic, assign) NSInteger  myboxticketnum;
@property (nonatomic, assign) NSInteger  boxraisenum;
@property (nonatomic, strong) NSArray   *list;

@property (nonatomic, strong) NSString  *totalnum;
@property (nonatomic, strong) NSString  *totalpage;
@property (nonatomic, strong) NSString  *currpage;

@end

@interface ZXMineBoxListModel : NSObject

@property (nonatomic, strong) NSString  *boxid;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *time;
@property (nonatomic, strong) NSString  *subtitle;
@property (nonatomic, assign) NSInteger  status;

@end

NS_ASSUME_NONNULL_END
