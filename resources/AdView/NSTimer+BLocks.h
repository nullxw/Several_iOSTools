

#import <Foundation/Foundation.h>

@interface NSTimer(BLocks)

+(NSTimer*)scheduleTimerWithTimerInternal:(NSTimeInterval)interval
                                       block:(void(^)())block
                                     repeats:(BOOL)repeats;
@end
