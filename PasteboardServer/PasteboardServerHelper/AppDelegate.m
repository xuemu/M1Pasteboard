//
//  AppDelegate.m
//  PasteboardServerHelper
//
//  Created by 田东海 on 2022/8/1.
//

#import "AppDelegate.h"

//https://blog.csdn.net/ZhangWangYang/article/details/116699580

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *mainAPP = @"com.demo.PasteboardServer";
        
//    NSArray *runningArray = [NSRunningApplication runningApplicationsWithBundleIdentifier:mainAPP];
    BOOL alreadRunning = NO;
    NSArray *runnings = [NSWorkspace sharedWorkspace].runningApplications;
    for (NSRunningApplication *app in runnings) {
        if ([app.bundleIdentifier isEqualToString:mainAPP]) {
            alreadRunning = YES;
            break;
        }
    }
    
    if (!alreadRunning) {
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(terminate) name:@"killme" object:mainAPP];
        
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
        NSString *path = [NSString pathWithComponents:pathComponents];
 
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            return;
        }
        [[NSWorkspace sharedWorkspace] openApplicationAtURL:[NSURL fileURLWithPath:path] configuration:[NSWorkspaceOpenConfiguration configuration] completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
            
        }];
    }else{
        [self terminate];
    }
}

- (void)terminate{
    [NSApp terminate:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
