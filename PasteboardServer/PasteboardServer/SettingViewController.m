//
//  SettingViewController.m
//  PasteboardServer
//
//  Created by dhtian on 2022/7/21.
//

#import "SettingViewController.h"
#import <ServiceManagement/ServiceManagement.h>

#define ZTPasteboardAutoLaunchKey @"ZTPasteboardAutoLaunchKey"

@interface SettingViewController ()
@property (weak) IBOutlet NSTextField *tipLabel;
@property (weak) IBOutlet NSButton *autoLaunchCheckBoxButton;

@property (weak) IBOutlet NSTextField *portField;

- (IBAction)restartAction:(id)sender;

@end

@implementation SettingViewController

- (void)dealloc
{
    NSLog(@"SettingViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tipLabel.hidden = YES;
    self.autoLaunchCheckBoxButton.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"ZTPasteboardAutoLaunchKey"];
}
- (IBAction)launchSwitchChanged:(NSButton *)sender {
    if (sender.state == NSControlStateValueOn) {
        [self daemon:YES];
    } else {
        [self daemon:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:ZTPasteboardAutoLaunchKey];
}

//- (BOOL)isStartAtLogin {
//    NSDictionary *dict = (__bridge NSDictionary*)SMJobCopyDictionary(kSMDomainUserLaunchd,
//                                                            CFSTR("com.demo.PasteboardServerHelper"));
//    BOOL contains = (dict!=NULL);
//    return contains;
//}

-(void)daemon:(BOOL)install{
   
    NSString *helperPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Library/LoginItems/PasteboardServerHelper.app"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:helperPath])
    {
        return;
    }
    NSURL *helperUrl = [NSURL fileURLWithPath:helperPath];
    // Registering helper app
//    if (LSRegisterURL((__bridge CFURLRef)helperUrl, true) != noErr)
//    {
//        NSLog(@"LSRegisterURL failed!");
//        [self showErrorText:@"注册开机启动失败"];
//    }
    // Setting login
    // com.xxx.xxx为Helper的BundleID,ture/false设置开启还是关闭
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)@"com.demo.PasteboardServerHelper",install))
    {
        NSLog(@"SMLoginItemSetEnabled failed!");
        [self showErrorText:@"Failed to set startup"];
    }
    
    NSString *mainAPP = [NSBundle mainBundle].bundleIdentifier?:@"com.demo.PasteboardServer";
    BOOL alreadRunning = NO;
    NSArray *runnings = [NSWorkspace sharedWorkspace].runningApplications;
    for (NSRunningApplication *app in runnings) {
        if ([app.bundleIdentifier isEqualToString:mainAPP]) {
            alreadRunning = YES;
            break;
        }
    }
    
    if (alreadRunning) {
        [[NSDistributedNotificationCenter defaultCenter]postNotificationName:@"killme" object:[NSBundle mainBundle].bundleIdentifier];
    }
}

- (IBAction)restartAction:(id)sender {
    NSInteger portInt = self.portField.integerValue;
    if (portInt > 65535) {
        [self showErrorText:@"Over Port Limit"];
        return;
    }
    if (self.settingBlock) {
        self.settingBlock(portInt);
    }
}

- (void)viewDidDisappear
{
    self.tipLabel.hidden = YES;
}

- (void)showErrorText:(NSString *)errTxt
{
    self.tipLabel.hidden = NO;
    self.tipLabel.stringValue = errTxt;
}
@end
