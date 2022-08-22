//
//  UIResponder+firstResponder.m
//  PasteboardiOS
//
//  Created by dhtian on 2022/7/21.
//

#import "UIResponder+firstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (firstResponder)

#if TARGET_IPHONE_SIMULATOR
+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
   currentFirstResponder = self;
}
#endif
@end
