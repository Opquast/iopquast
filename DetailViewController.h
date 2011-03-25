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


@interface DetailViewController : UIViewController {
	
	NSString *ficheID;
	NSString *ficheLevel;
	
	NSArray *ficheArray;
	
	IBOutlet UIWebView *webView;
	
	IBOutlet UISegmentedControl *validCtrl;
	
	NSString *loadedProjectID;
	
	NSInteger ctrlStatut;

}

@property (nonatomic, retain) NSString *ficheID;
@property (nonatomic, retain) NSString *ficheLevel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) NSArray *ficheArray;

@property (nonatomic, retain) IBOutlet UISegmentedControl *validCtrl;

@property (nonatomic, retain) NSString *loadedProjectID;

@property (nonatomic) NSInteger ctrlStatut;

- (IBAction) changeState:(id)sender;

@end
