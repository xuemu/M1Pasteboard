//
//  AppDelegate.m
//  ZTPasteboardServer
//
//  Created by dhtian on 2022/7/19.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "SettingViewController.h"

#define DefaultPort 8123
// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface AppDelegate ()
{
    HTTPServer *httpServer;
}
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover *popover;
@property (assign, nonatomic) NSInteger port;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    NSApp.activationPolicy = NSApplicationActivationPolicyAccessory;
    self.statusItem.button.target = self;
    self.statusItem.button.action = @selector(handleClick:);
    
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SettingViewController *settingVC = (SettingViewController *)[sb instantiateControllerWithIdentifier:@"SettingViewController"];
    settingVC.settingBlock = ^(NSInteger port) {
        [self startServerWithPort:(UInt16)port];
    };
    self.popover = [[NSPopover alloc]init];
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.contentSize = CGSizeMake(175, 135);
    self.popover.contentViewController = settingVC;
    
    [self startServerWithPort:DefaultPort];
}

- (void)startServerWithPort:(UInt16)port
{
    if (httpServer && [httpServer isRunning]) {
        [httpServer stop];
    }
    // Initalize our http server
    httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [httpServer setPort:port];
    
    // We're going to extend the base HTTPConnection class with our MyHTTPConnection class.
    // This allows us to do all kinds of customizations.
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    DDLogInfo(@"Setting document root: %@", webPath);

    [httpServer setDocumentRoot:webPath];
    
    NSError *error = nil;
    
    if(![httpServer start:&error])
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
        [self addStopStatusMenu];
        if ([self.popover isShown]) {
            SettingViewController *settingVC = (SettingViewController *)self.popover.contentViewController;
            [settingVC showErrorText:[error description]];
        }
    } else {
        self.port = httpServer.port;
        [self addStartStatusMenu];
        if ([self.popover isShown]) {
            [self.popover performClose:nil];
        }
    }

}

- (void)addStartStatusMenu
{
    self.statusItem.button.image = [NSImage imageNamed:@"statusbar_run_icon"];
    NSMenu *menu = [[NSMenu alloc]initWithTitle:@"控制状态"];
    NSMenuItem *portMenuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"port : %ld",self.port] action:nil keyEquivalent:@""];
    portMenuItem.enabled = NO;
    [menu addItem:portMenuItem];
    [menu addItemWithTitle:@"stop" action:@selector(handleItem:) keyEquivalent:@"stop"];
    [menu addItemWithTitle:@"edit" action:@selector(handleEdit:) keyEquivalent:@"edit"];
    [menu addItemWithTitle:@"quit" action:@selector(handleItem:) keyEquivalent:@"quit"];
    self.statusItem.menu = menu;
}

- (void)addStopStatusMenu
{
    self.statusItem.button.image = [NSImage imageNamed:@"statusbar_stop_icon"];
    NSMenu *menu = [[NSMenu alloc]initWithTitle:@"控制状态"];
    NSMenuItem *portMenuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"port : %ld",self.port] action:nil keyEquivalent:@""];
    portMenuItem.enabled = NO;
    [menu addItem:portMenuItem];
    [menu addItemWithTitle:@"start" action:@selector(handleItem:) keyEquivalent:@"start"];
    [menu addItemWithTitle:@"edit" action:@selector(handleEdit:) keyEquivalent:@"edit"];
    [menu addItemWithTitle:@"quit" action:@selector(handleItem:) keyEquivalent:@"quit"];
    self.statusItem.menu = menu;
}

-(void)handleClick:(NSButton *)button {
    NSLog(@"");
}
-(void)handleItem:(NSMenuItem *)item {
    NSLog(@"%@",item.title);
    if ([item.title isEqualToString:@"stop"]) {
        [httpServer stop];
        [self addStopStatusMenu];
    }else if ([item.title isEqualToString:@"start"]) {
        NSError *err = nil;
        [httpServer start:&err];
        if (!err) {
            [self addStartStatusMenu];
        }
    } else {//exit
        [[NSApplication sharedApplication]terminate:nil];
    }
}

- (void)handleEdit:(NSMenuItem *)item {
    [self.popover showRelativeToRect:self.statusItem.button.bounds ofView:self.statusItem.button preferredEdge:NSRectEdgeMaxY];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
