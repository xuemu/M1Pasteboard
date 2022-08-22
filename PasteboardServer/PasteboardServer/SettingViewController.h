//
//  SettingViewController.h
//  PasteboardServer
//
//  Created by dhtian on 2022/7/21.
//

#import <Cocoa/Cocoa.h>

typedef void(^SettingBlock)(NSInteger port);

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : NSViewController

@property (copy, nonatomic) SettingBlock settingBlock;

- (void)showErrorText:(NSString *)errTxt;

@end

NS_ASSUME_NONNULL_END
