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
#import "CatViewController.h"
#import "FichesViewController.h"
#import "Sqlite.h"

@implementation CatViewController

@synthesize sectionArray, infoArray;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	Sqlite *sqlite = [[Sqlite alloc] init];
	sectionArray = [[NSMutableArray alloc] init];
	NSString *writableDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"];
	if (![sqlite open:writableDBPath]) return;
	
	NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
	
	if ([preferredLang isEqualToString:@"fr"]) {
		NSArray *req = [sqlite executeQuery:@"SELECT DISTINCT(THEME) as col FROM pratiques;"];	
		for (NSDictionary *row in req) {
			[sectionArray addObject:[row valueForKey:@"col"]];
		}
	}
	else {
		NSArray *req = [sqlite executeQuery:@"SELECT DISTINCT(THEME_EN) as col FROM pratiques;"];	
		for (NSDictionary *row in req) {
			[sectionArray addObject:[row valueForKey:@"col"]];
		}
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.loadedProjectName == nil) {
		self.title = NSLocalizedString(@"Sheets",@"");
	} else {
		self.title = appDelegate.loadedProjectName;
	}
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	infoArray = [[NSMutableArray alloc] init];
	
	if (appDelegate.loadedProjectID != nil) {
		for (NSString *th in sectionArray) {
			
			Sqlite *sqlite = [[Sqlite alloc] init];
			NSString *writableDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"opquast.sqlite"];
			[sqlite open:writableDBPath];
			NSMutableArray *total = [[NSMutableArray alloc] init];
			
			NSString *preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
			
			if ([preferredLang isEqualToString:@"fr"]) {
				NSArray *req = [sqlite executeQuery:[NSString stringWithFormat:@"SELECT ID FROM pratiques WHERE THEME ='%@';", th]];
				for (NSDictionary *row in req) {
					[total addObject:[row valueForKey:@"ID"]];
				}
			} else {
				NSArray *req = [sqlite executeQuery:[NSString stringWithFormat:@"SELECT ID FROM pratiques WHERE THEME_EN ='%@';", th]];
				for (NSDictionary *row in req) {
					[total addObject:[row valueForKey:@"ID"]];
				}
			}
			
			/*************/
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
			[sqlite open:writableDBPath];
			
			int i = 0;
			for (NSString *ficheID in total) {
				NSString *query = [NSString stringWithFormat:@"SELECT statut FROM pratiques WHERE project = '%@' AND fiche = '%@';", appDelegate.loadedProjectID, ficheID];
				NSArray *req = [sqlite executeQuery:query];
				for (NSDictionary *row in req) {
					if (![[row valueForKey:@"statut"] isEqualToString:@"0"]) {
						i++;
					}
				}
				
			}
			
			int percent = 100 * i / [total count];
			[infoArray addObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%d",[total count]],[NSString stringWithFormat:@"%d",percent],nil]];
			
			[sqlite release];
			[total release];
			
		}
	}
	
	[self.tableView reloadData];
}

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
   
	cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
	if ([infoArray count] > 0) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Competed %@ %%", [[infoArray objectAtIndex:indexPath.row] objectAtIndex:2]];
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
	FichesViewController *fichesViewController = [[FichesViewController alloc] initWithNibName:@"FichesViewController" bundle:nil];
    
	fichesViewController.cat = [sectionArray objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:fichesViewController animated:YES];
	[fichesViewController release];
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

