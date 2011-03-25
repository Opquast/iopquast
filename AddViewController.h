/**
 * iOpquast
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to contact@openaccess.fr so we can send you a copy immediately.
 */

#import <UIKit/UIKit.h>


@interface AddViewController : UIViewController <UITextFieldDelegate>{
	
	IBOutlet UITextField *projectName;
	IBOutlet UITextField *projectUrl;
	NSString *projectSelectedId;
	
	IBOutlet UISegmentedControl *ecommerce;
	IBOutlet UISegmentedControl *newsletter;
	IBOutlet UISegmentedControl *feeds;
}

@property (nonatomic, retain) IBOutlet UITextField *projectName;
@property (nonatomic, retain) IBOutlet UITextField *projectUrl;
@property (nonatomic, retain) NSString *projectSelectedId;

@property (nonatomic, retain) IBOutlet UISegmentedControl *ecommerce;
@property (nonatomic, retain) IBOutlet UISegmentedControl *newsletter;
@property (nonatomic, retain) IBOutlet UISegmentedControl *feeds;

-(IBAction)save;
-(IBAction)cancel;

@end
