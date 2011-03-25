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

#import "AddViewController.h"
#import "AppDelegate_iPhone.h"
#import "LoadProjectViewController.h"
#import "Sqlite.h"


@implementation LoadProjectViewController

@synthesize projectSaved;

#pragma mark -
#pragma mark View lifecycle

- (BOOL)isIPad {
	if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"]) {
		return TRUE;
	} else {
		return FALSE;
	}
	
}

- (void)AddButtonAction:(id)sender {
	
	if (![self isIPad]) {
		AddViewController *controller = [[AddViewController alloc] initWithNibName:@"AddViewController_iPhone" bundle:nil];
		[[self navigationController] presentModalViewController:controller animated:YES];
		[controller release];
	} else {
		AddViewController *controller = [[AddViewController alloc] initWithNibName:@"AddViewController_iPad" bundle:nil];
		[[self navigationController] presentModalViewController:controller animated:YES];
		[controller release];
	}

    
    //UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:controller];
  //  [controller release];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	projectSaved = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(AddButtonAction:)];
	[self.navigationItem setRightBarButtonItem:addButton];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.title = @"Projects";
}

- (void)removeProject:(NSString *)key {
		
	Sqlite *sqlite = [[Sqlite alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
	[sqlite open:writableDBPath];
	
	NSString *query = [NSString stringWithFormat:@"DELETE FROM project WHERE key = %@", key];
	NSString *query2 = [NSString stringWithFormat:@"DELETE FROM pratiques WHERE project = %@", key];
	
	[sqlite executeNonQuery:query];
	[sqlite executeNonQuery:query2];
	
	[sqlite release];
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//Load existing project from dataBase
	[projectSaved removeAllObjects];
	Sqlite *sqlite = [[Sqlite alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
	
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:writableDBPath];
	
	
	if (!fileExists) {
		
		if (![sqlite open:writableDBPath]) return;
		
		[sqlite executeNonQuery:@"CREATE TABLE project (key INTEGER PRIMARY KEY, name TEXT, url TEXT);"];
		[sqlite executeNonQuery:@"CREATE TABLE pratiques (key INTEGER PRIMARY KEY, fiche TEXT, project TEXT, statut TEXT);"];
		
	} else {
		
		//Load existing project in dataBase
		
		if (![sqlite open:writableDBPath]) return;
		NSArray *req = [sqlite executeQuery:@"SELECT key, name FROM project;"];	
		for (NSDictionary *row in req) {
			//[projectSaved addObject:[row valueForKey:@"col"]];
			[projectSaved addObject:[NSArray arrayWithObjects:[row valueForKey:@"key"], [row valueForKey:@"name"], nil]];
		}
		
	}
	
	[sqlite release];
	
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [projectSaved count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	cell.textLabel.text = [[projectSaved objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		NSLog(@"Delete");
		
		NSString *removeKey = [[projectSaved objectAtIndex:indexPath.row] objectAtIndex:0];
		[self removeProject:removeKey];
		
		[projectSaved removeObjectAtIndex:indexPath.row];
		
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	appDelegate.loadedProjectID = [[projectSaved objectAtIndex:indexPath.row] objectAtIndex:0];
	appDelegate.loadedProjectName = [[projectSaved objectAtIndex:indexPath.row] objectAtIndex:1];
	
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

