//
//  ZXValidationManager.m
//  ZXHY
//
//  Created by Bern Mac on 8/10/21.
//

#import "ZXValidationManager.h"

@interface ZXValidationManager ()

@end

@implementation ZXValidationManager


#pragma mark -  单例类初始化
+ (instancetype)shareValidationManager{
    
    static ZXValidationManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ZXValidationManager alloc] init];
    });
    return instance;
}


//时间回调
- (void)zx_countDownTimeOut:(NSInteger)countDownTimeOut{
    
    if (self.countDownTimer == nil) {
        
        // 倒计时时间
        __block NSInteger timeout = countDownTimeOut;

        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            //每秒执行
            dispatch_source_set_timer(self.countDownTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0);
            WEAKSELF;
            dispatch_source_set_event_handler(weakSelf.countDownTimer, ^{
                STRONGSELF;
                
                if(timeout <= 0){
                    
                    //  当倒计时结束时
                    [weakSelf zx_closeAndDestroyed];

                } else {
                    // 递减 倒计时-1(总时间以秒来计算)
                    timeout--;
                }
                
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeBlock(timeout);
                });
                
                
            });
            
            dispatch_resume(self.countDownTimer);
        }
    }
}

//关闭和销毁Timer
- (void)zx_closeAndDestroyed{
    if (self.countDownTimer){
        dispatch_source_cancel(self.countDownTimer);
        self.countDownTimer = nil;
    }
    
}


@end
