    //
    //  AppDelegate.m
    //  TestProject
    //
    //  Created by Daniel Fredrich on 16.02.21.
    //

#import "AppDelegate.h"
@import CPXResearch;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
    CPXLegacyStyleConfiguration* style =
    [[CPXLegacyStyleConfiguration alloc] initWithPosition:LegacySurveyPositionScreenCenterBottom
                                                     text:@"Verdiene bis zu 3 Coins in<br> 4 Minuten mit Umfragen"
                                                 textSize:20
                                                textColor:@"#ffffff"
                                          backgroundColor:@"#ffaf20"
                                           roundedCorners:YES];

    CPXLegacyConfiguration* config =
    [[CPXLegacyConfiguration alloc] initWithAppId:@""
                                        extUserId:@""
                                       secureHash:@""
                                            email:nil
                                           subId1:nil
                                           subId2:nil
                                        extraInfo:nil
                                            style:style];
    [CPXResearch setupWith:config];

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

@end
