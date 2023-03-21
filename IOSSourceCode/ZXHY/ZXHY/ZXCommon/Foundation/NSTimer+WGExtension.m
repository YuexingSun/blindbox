//
//  NSTimer+WGExtension.m
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/30.
//

#import "NSTimer+WGExtension.h"

@implementation NSTimer (WGExtension)

+(id)wg_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats
{
    void (^block)(void) = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(wg_jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)wg_jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)(void) = (void (^)(void))[inTimer userInfo];
        block();
    }
}

@end
