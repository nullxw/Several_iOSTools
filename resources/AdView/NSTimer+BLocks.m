

#import "NSTimer+BLocks.h"

@implementation NSTimer(BLocks)

+(NSTimer*)scheduleTimerWithTimerInternal:(NSTimeInterval)interval
                                       block:(void(^)())block
                                     repeats:(BOOL)repeats{
    NSTimer* timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerBlockInvoke:) userInfo:[block copy] repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}
+(void)timerBlockInvoke:(NSTimer*)timer{
    void(^block)() = timer.userInfo;
    if(block){
        block();
    }
}
@end
