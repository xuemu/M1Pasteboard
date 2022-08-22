//
//  AppDelegate.m
//  PasteboardiOS
//
//  Created by dhtian on 2022/7/21.
//

#import "AppDelegate.h"
#import "UIResponder+firstResponder.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - keyCommands
- (NSArray<UIKeyCommand *> *)keyCommands {
    NSArray *a = [super keyCommands];
    if (a) {
        NSMutableArray *commands = [NSMutableArray arrayWithArray:a];
        [commands addObject:[UIKeyCommand keyCommandWithInput:@"v" modifierFlags:UIKeyModifierControl action:@selector(rootVCPerformCommand:)]];
        return commands;
    }
    return @[
             [UIKeyCommand keyCommandWithInput:@"v" modifierFlags:UIKeyModifierControl action:@selector(rootVCPerformCommand:)]
             ];
}

- (void)rootVCPerformCommand:(UIKeyCommand *)command
{
#if TARGET_IPHONE_SIMULATOR
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8123/getPasteboardString"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"读取出错,请检查服务是否打开");
                } else {
                    NSString *pasteString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    UIResponder* aFirstResponder = [UIResponder currentFirstResponder];
                    if ([aFirstResponder isKindOfClass:[UITextField class]]) {
                        [(UITextField *)aFirstResponder setText:pasteString];
                    } else if ([aFirstResponder isKindOfClass:[UITextView class]]) {
                        [(UITextView *)aFirstResponder setText:pasteString];
                    } else {
                        
                    }
                }
            });
            
        }];
        
        [task resume];
#endif
}


@end
