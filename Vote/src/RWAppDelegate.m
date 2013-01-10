//
//  RWAppDelegate.m
//  Vote
//
//  Created by Ryan Wang on 12-12-26.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWAppDelegate.h"
#import "RWRootViewController.h"
#import "RWAPI.h"
#import "RWUser.h"
#import "MobClick.h"

static NSInteger const kWXSuccessAlertTag = 1001;

@interface RWAppDelegate ()



@end

@implementation RWAppDelegate

@synthesize objectManager = _objectManager;
@synthesize mainViewController = _mainViewController;


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //向微信注册
    [WXApi registerApp:@"wxb376681694e365cf"];
    
    
    //
    // Umeng Track
    //
    [MobClick startWithAppkey:UMENG_APP_KEY];
    [MobClick setAppVersion:@"20130110"];
    [MobClick setCrashReportEnabled:YES];
    
    [MobClick updateOnlineConfig];

    
    NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
    self.objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    self.objectManager.managedObjectStore = managedObjectStore;

//    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"RWUser" inManagedObjectStore:managedObjectStore];
//    userMapping.identificationAttributes = @[ @"userID" ];
//    [userMapping addAttributeMappingsFromDictionary:@{
//     @"id": @"userID",
////     @"screen_name": @"screenName",
//     }];
//    // If source and destination key path are the same, we can simply add a string to the array
//    [userMapping addAttributeMappingsFromArray:@[ @"name" ]];

    

    
//    /**
//     Complete Core Data stack initialization
//     */
//    [managedObjectStore createPersistentStoreCoordinator];
//    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"RKData.sqlite"];
//    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
//    NSError *error;
//    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
//    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
//    
//    // Create the managed object contexts
//    [managedObjectStore createManagedObjectContexts];
//    
//    // Configure a managed object cache to ensure we do not create duplicate objects
//    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
//
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.mainViewController = [[RWRootViewController alloc] init];
    self.window.rootViewController = self.mainViewController;

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


#pragma mark - WeChat Delegate 
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
//        [self onRequestAppMessage];    
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;

        NSLog(@"%@",temp.message.title);
        NSLog(@"%@",temp.message.description);        
        NSLog(@"%@",temp.message.mediaObject);
        if ([temp.message.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
            WXAppExtendObject *appExtend = (WXAppExtendObject *)temp.message.mediaObject;
            NSLog(@"%@",appExtend.extInfo);
            
            [self.mainViewController joinGameWithGameId:appExtend.extInfo];
            return;
            
        }
        
        
//        [self onShowMediaMessage:temp.message];
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sendSuccess", @"发送成功") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"backToWeChatGetCode",@"返回微信继续游戏")otherButtonTitles:nil];
            alert.tag = kWXSuccessAlertTag;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sendFail", @"发送失败") message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex == buttonIndex && alertView.tag == kWXSuccessAlertTag) {
        [WXApi openWXApp];
    }
}

@end
