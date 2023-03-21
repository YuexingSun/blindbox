//
//  NSTimer+WGExtension.h
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (WGExtension)

+(id)wg_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats;

@end

NS_ASSUME_NONNULL_END
