//
//  UIResponder+firstResponder.h
//  PasteboardiOS
//
//  Created by dhtian on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (firstResponder)

#if TARGET_IPHONE_SIMULATOR

+ (id)currentFirstResponder;

#endif

@end

NS_ASSUME_NONNULL_END
