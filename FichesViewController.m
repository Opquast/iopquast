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
#import "FichesViewController.h"
#import "DetailViewController.h"
#import "Sqlite.h"


@implementation FichesViewController

@synthesize cat, sectionArray, loadedProjectID, statut;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	loadedProjectID = appDelegate.loadedProjectID;
	
	statut = 0;
	
	NSLog(@"%@", loadedProjectID);
	
    [super viewDidLoad];
	
	self.title = cat;
	
	
	Sqlite *sqlite = [[Sqlite alloc] init];
	sectionArray = [[NSMutableArray alloc] init];
	NSString *writableDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"];
	if (![sqlite open:writableDBPath]) return;
	
	NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([preferredLang isEqualToString:@"fr"]) {
	
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM pratiques WHERE THEME = '%@';", cat];
		NSArray *req = [sqlite executeQuery:query];	
		for (NSDictionary *row in req) {
			[sectionArray addObject:[[NSArray alloc] initWithObjects:[row valueForKey:@"ID"],
									 [row valueForKey:@"DESCRIPTION_FR"],
									 [row valueForKey:@"NIVEAU"],
									 [row valueForKey:@"CONTROL_FR"],
									 [row valueForKey:@"GOAL_FR"],
									 [row valueForKey:@"SOLUTION_FR"],
									 nil]];
		}
		
	} else {
		
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM pratiques WHERE THEME_EN = '%@';", cat];
		NSArray *req = [sqlite executeQuery:query];	
		for (NSDictionary *row in req) {
			[sectionArray addObject:[[NSArray alloc] initWithObjects:[row valueForKey:@"ID"],
									 [row valueForKey:@"DESCRIPTION_EN"],
									 [row valueForKey:@"NIVEAU"],
									 [row valueForKey:@"CONTROL_EN"],
									 [row valueForKey:@"GOAL_EN"],
									 [row valueForKey:@"SOLUTION_EN"],
									 nil]];
		}
	}

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
    return [sectionArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [[sectionArray objectAtIndex:indexPath.row] objectAtIndex:1];
	cell.detailTextLabel.text = [[sectionArray objectAtIndex:indexPath.row] objectAtIndex:2];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:12]];
    [[cell detailTextLabel] setFont:[UIFont boldSystemFontOfSize:12]];
	
	
	cell.imageView.image = [UIImage imageNamed:@"notested.png"];
	[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	
	if (loadedProjectID != nil) {
				
		Sqlite *sqlite = [[Sqlite alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
		[sqlite open:writableDBPath];
		
		NSString *query = [NSString stringWithFormat:@"SELECT statut FROM pratiques WHERE project = '%@' AND fiche = '%@';", loadedProjectID, [[sectionArray objectAtIndex:indexPath.row] objectAtIndex:0]];
		NSArray *req = [sqlite executeQuery:query];	
		for (NSDictionary *row in req) {
			if ([row valueForKey:@"statut"] != nil) {
				
				NSLog(@"%@", [row valueForKey:@"statut"]);
				if ([[row valueForKey:@"statut"] isEqualToString:@"1"]) {
					cell.imageView.image = [UIImage imageNamed:@"valid.png"];
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
					statut = 1;
				}
				
				else if ([[row valueForKey:@"statut"] isEqualToString:@"2"]) {
					cell.imageView.image = [UIImage imageNamed:@"novalid.png"];
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
					statut = 2;
				}
				
				else if ([[row valueForKey:@"statut"] isEqualToString:@"3"]) {
					cell.imageView.image = [UIImage imageNamed:@"na.png"];
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
					statut = 3;
				}
				
				else {
					cell.imageView.image = [UIImage imageNamed:@"notested.png"];
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
				}
				
			}
		}
		[sqlite release];
		
	}
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


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
    // Navigation logic may go here. Create and push another view controller.
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];

	detailViewController.ficheID = [[sectionArray objectAtIndex:indexPath.row] objectAtIndex:0];
	//detailViewController.ficheLevel = [[sectionArray objectAtIndex:indexPath.row] objectAtIndex:3];
	detailViewController.ficheArray = [sectionArray objectAtIndex:indexPath.row];
	detailViewController.ctrlStatut = statut;
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
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

