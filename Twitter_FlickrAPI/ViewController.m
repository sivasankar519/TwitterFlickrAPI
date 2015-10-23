//
//  ViewController.m
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "ViewController.h"
#import "TweetsTableViewController.h"

@interface ViewController ()
{
    NSMutableArray *searchArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Intialization and allcate memory for mutable array to store the search words
    searchArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    // Deselect the tableView cell before View appears to user and also update table data if anything changes
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Identify the Segue if there are mutliple ones
    if ([[segue identifier] isEqualToString:@"TweetsTable"]) {
        
        // To dismiss Keyboard
        [self.view endEditing:YES];
        
        // Get destination view
        TweetsTableViewController *destinationController = [segue destinationViewController];
        
        // pass search string to destination controller
        [destinationController setSearchString:[sender text]];
        
        // To avoid duplicates remove search word if already exists in array and then add it at index:0
        
        [searchArray removeObject:[sender text]];
        [searchArray insertObject:[sender text] atIndex:0];
    }
}

#pragma mark - Search Bar Methods

// Delegate method of SearchBar when press on Search button in Keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    // Call Segue with Identifier, this will call the method prepareSegue
    [self performSegueWithIdentifier:@"TweetsTable" sender:searchBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // set Text for cell from Search array with specified index.
    cell.textLabel.text = searchArray [indexPath.row];
    
    // To make cell text appers to be Center with blue color
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blueColor];
    
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    [header.textLabel setTextAlignment:NSTextAlignmentCenter];
   
    // Set header text based on count. 
    searchArray.count ? [header.textLabel setText:@"Previous Searches"] : [header.textLabel setText:@"No Search Found"] ;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

@end
