/**
 * iOpquast
 *
 * This file is part of iOpquast released under the BSD license.
 * See the LICENSE for more information.
 */

#import <UIKit/UIKit.h>

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSString *loadedProjectID;
	NSString *loadedProjectName;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSString *loadedProjectID;
@property (nonatomic, retain) NSString *loadedProjectName;

@end

