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
#import "DetailViewController.h"
#import "Sqlite.h"


@implementation DetailViewController

@synthesize ficheID, ficheLevel, webView, ficheArray, validCtrl, loadedProjectID, ctrlStatut;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (IBAction) changeState:(id)sender {
	
	if (loadedProjectID != nil) {
		
		Sqlite *sqlite = [[Sqlite alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
		[sqlite open:writableDBPath];
		
		NSString *statut = [[NSString alloc] initWithFormat:@"%d", validCtrl.selectedSegmentIndex];
		
		NSString *cleanQuery = [[NSString alloc] initWithFormat:@"DELETE FROM pratiques WHERE fiche = '%@' AND project = '%@';", ficheID, loadedProjectID];
		[sqlite executeNonQuery:cleanQuery];
		[sqlite executeNonQuery:@"INSERT INTO pratiques VALUES (null, ?, ?, ?);", ficheID, loadedProjectID, statut];
		
		[sqlite release];
		
	}
	
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	loadedProjectID = appDelegate.loadedProjectID;
	
	validCtrl.selectedSegmentIndex = ctrlStatut;
	
	[super viewDidLoad];
	
	
	self.title = [NSString stringWithFormat:@"Fiche N° %@", ficheID];
	
	NSString *header = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"fr\" lang=\"fr\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><link href=\"%@\" type=\"text/css\" rel=\"stylesheet\"/></head><body>";
	header = [NSString stringWithFormat:header, [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"]];
	
	NSString *webContent = [NSString stringWithFormat:@"%@", header];
	
	NSString *title = [NSString stringWithFormat:@"<h2>%@</h2>", NSLocalizedString(@"Description", @"")];
	NSString *content = [NSString stringWithFormat:@"<p>%@</p>", [ficheArray objectAtIndex:1]];
	webContent = [NSString stringWithFormat:@"%@%@%@", webContent, title, content];
	
	title = [NSString stringWithFormat:@"<h2>%@</h2>", NSLocalizedString(@"Objectives", @"")];
	content = [NSString stringWithFormat:@"<p>%@</p>", [ficheArray objectAtIndex:4]];
	webContent = [NSString stringWithFormat:@"%@%@%@", webContent, title, content];
	
	title = [NSString stringWithFormat:@"<h2>%@</h2>", NSLocalizedString(@"Control methods", @"")];
	content = [NSString stringWithFormat:@"<p>%@</p>", [ficheArray objectAtIndex:3]];
	webContent = [NSString stringWithFormat:@"%@%@%@", webContent, title, content];
	
	title = [NSString stringWithFormat:@"<h2>%@</h2>", NSLocalizedString(@"Solutions", @"")];
	content = [NSString stringWithFormat:@"<p>%@</p>", [ficheArray objectAtIndex:5]];
	webContent = [NSString stringWithFormat:@"%@%@%@", webContent, title, content];
	
	NSString *footer = @"</body></html>";
	webContent = [NSString stringWithFormat:@"%@%@", webContent, footer];
	[webView loadHTMLString:webContent baseURL:[NSURL URLWithString:@"/"]];
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
