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


@interface FichesViewController : UITableViewController {
	
	NSString *cat;
	NSMutableArray *sectionArray;
	
	NSString *loadedProjectID;
	
	NSInteger statut;

}

@property (nonatomic, retain) NSString *cat;
@property (nonatomic, retain) NSMutableArray *sectionArray;

@property (nonatomic, retain) NSString *loadedProjectID;

@property (nonatomic) NSInteger statut;

@end
