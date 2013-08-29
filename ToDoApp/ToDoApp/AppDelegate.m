//
//  AppDelegate.m
//  ToDoApp
//
//  Created by gauravm on 22/08/13.
//  Copyright (c) 2013 thoughtworks. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "CompletedViewController.h"
@implementation AppDelegate
@synthesize viewController;

@synthesize window = _window;
@synthesize navigationController;
@synthesize dbFilePath;
@synthesize completedViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *DATABASE_FILE_NAME = @"todo.db";
    NSString * DATABASE_RESOURCE_NAME = @"todo";
    NSString *DATABASE_RESOURCE_TYPE = @"db";
    NSArray *searcPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentFolderPath = [searcPaths objectAtIndex:0];
    
    dbFilePath = [documentFolderPath stringByAppendingPathComponent:DATABASE_FILE_NAME];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]){
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:DATABASE_RESOURCE_NAME ofType:DATABASE_RESOURCE_TYPE];
        if(backupDbPath == nil){
            NSLog(@"coudnt find db");

        }else{
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
            if(!copiedBackupDb){
                NSLog(@"copying failed");
            }
        }
    }
    
    viewController = [[ViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
