//
//  UIControl+ClickButton.m
//  SLActionSheet
//
//  Created by jiahao on 15/11/10.
//  Copyright © 2015年 silicn. All rights reserved.
//

#import "UIControl+ClickButton.h"

#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

static const char * UIController_ignoreEvent = "silicn";


@implementation UIControl (ClickButton)

@dynamic uxy_acceptEventInterval;

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)uxy_ignoreEvent
{
    return [objc_getAssociatedObject(self, UIController_ignoreEvent) boolValue];
}


- (void)setUxy_ignoreEvent:(BOOL)uxy_ignoreEvent
{
    objc_setAssociatedObject(self, UIController_ignoreEvent, @(uxy_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    
    if (self.uxy_ignoreEvent) {
        NSLog(@"没执行");
        return;
    }
    
    if (self.uxy_acceptEventInterval > 0)
    {
        self.uxy_ignoreEvent = YES;
        [self performSelector:@selector(setUxy_ignoreEvent:) withObject:@(NO) afterDelay:self.uxy_acceptEventInterval];
    }
    NSLog(@"执行");
    [self __uxy_sendAction:action to:target forEvent:event];
}

@end
