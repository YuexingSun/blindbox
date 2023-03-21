//
//  WGImageBrowserHandler.h
//  Yunhuoyouxuan
//
//  Created by apple on 2021/5/12.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBIBToolViewHandler.h>

#import "WGImageBrowserSheetView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGImageBrowserToolViewHandler : NSObject <YBIBToolViewHandler>

- (instancetype)initWithSheetButtonType:(WGImageBrowserSheetBtnType)type;

- (instancetype)initWithSaveButton;

@property (nonatomic, copy) void(^shareToWeChat)(NSURL *resourceURL,UIImage * _Nullable image);

@end

NS_ASSUME_NONNULL_END
