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

#import "AppDelegate_iPhone.h"
#import "AddViewController.h"
#import "Sqlite.h"

@implementation AddViewController

@synthesize projectName, projectUrl, projectSelectedId, ecommerce, newsletter, feeds;

- (void) setOptions:(NSString *)projet theme:(NSString *)strtheme {
	
	Sqlite *sqlite = [[Sqlite alloc] init];
	[sqlite open:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"]];
	NSString *rq = [NSString stringWithFormat:@"SELECT ID FROM pratiques WHERE THEME = '%@';", strtheme];
	NSArray *req = [sqlite executeQuery:rq];
	
	for (NSDictionary *row in req) {
		NSLog(@"%@", [row valueForKey:@"ID"]);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		[sqlite open:[documentsDirectory stringByAppendingPathComponent:@"data.sqlite"]];
		[sqlite executeNonQuery:@"INSERT INTO pratiques VALUES (null, ?, ?, ?);", [row valueForKey:@"ID"], projet, @"3"];
	}
	[sqlite release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}
/*
- (void) noecommerce:(NSString *)projet {
	Sqlite *sqlite = [[Sqlite alloc] init];
	[sqlite open:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"]];
	NSArray *req = [sqlite executeQuery:@"SELECT ID FROM pratiques WHERE THEME = 'E-Commerce';"];
	for (NSDictionary *row in req) {
		NSLog(@"%@", [row valueForKey:@"ID"]);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		[sqlite open:[documentsDirectory stringByAppendingPathComponent:@"data.sqlite"]];
		[sqlite executeNonQuery:@"INSERT INTO pratiques VALUES (null, ?, ?, ?);", [row valueForKey:@"ID"], projet, @"3"];
	}
	[sqlite release];
}

- (void) nonewsletter:(NSString *)projet {
	Sqlite *sqlite = [[Sqlite alloc] init];
	[sqlite open:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"]];
	NSArray *req = [sqlite executeQuery:@"SELECT ID FROM pratiques WHERE THEME = 'Newsletter';"];	
	for (NSDictionary *row in req) {
		NSLog(@"%@", [row valueForKey:@"ID"]);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		[sqlite open:[documentsDirectory stringByAppendingPathComponent:@"data.sqlite"]];
		[sqlite executeNonQuery:@"INSERT INTO pratiques VALUES (null, ?, ?, ?);", [row valueForKey:@"ID"], projet, @"3"];
	}
	[sqlite release];
}
*/

- (IBAction) save {
	
	if(![projectName.text isEqualToString:@""]) {
		
		Sqlite *sqlite = [[Sqlite alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
		
		if (![sqlite open:writableDBPath]) return;
		
		[sqlite executeNonQuery:@"INSERT INTO project VALUES (null, ?, ?);", projectName.text, projectUrl.text];
		
		
		NSArray *req = [sqlite executeQuery:@"select key from project order by key desc limit 1;"];	
		for (NSDictionary *row in req) {
			projectSelectedId = [row valueForKey:@"key"];
		}
		
		if (ecommerce.selectedSegmentIndex == 1) {
			//[self noecommerce:projectSelectedId];
			[self setOptions:projectSelectedId theme:@"E-Commerce"];
		}
		
		if (newsletter.selectedSegmentIndex == 1) {
			//[self nonewsletter:projectSelectedId];
			[self setOptions:projectSelectedId theme:@"Newsletter"];
		}
		
		if (feeds.selectedSegmentIndex == 1) {
			//[self nonewsletter:projectSelectedId];
			[self setOptions:projectSelectedId theme:@"Syndication"];
		}
		
		[self dismissModalViewControllerAnimated:YES];
		
		/*Opquast_For_iPhoneAppDelegate *appDelegate = (Opquast_For_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.loadedProjectID = projectSelectedId;
		appDelegate.loadedProjectName = projectName.text;*/
		[self dismissModalViewControllerAnimated:YES];
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:NSLocalizedString(@"Error",@"")
							  message:NSLocalizedString(@"Project field may not be empty",@"")
							  delegate:nil
							  cancelButtonTitle:@"Ok"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

- (IBAction) cancel {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.projectName setDelegate:self];
    [self.projectName setReturnKeyType:UIReturnKeyDone];
	[self.projectUrl setDelegate:self];
    [self.projectUrl setReturnKeyType:UIReturnKeyDone];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
