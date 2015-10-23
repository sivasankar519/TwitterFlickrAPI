//
//  TweetsTableViewController.m
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "TweetsTableViewController.h"
#import "TweetTableViewCell.h"
#import "PhotoCollectionViewController.h"
#import "DataManager.h"
@interface TweetsTableViewController (){
   NSArray *results;
    NSString *stateMessage;
}




@end

@implementation TweetsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // To make UITableViewCell height based on UILabel Height
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Set the title for Navigation Bar with Search Key
    self.title = self.searchString;
    
    // Default message before call to network
    stateMessage = @"Loading..";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Request to establish connection from Data manager shared instance
    [[DataManager sharedInstance] twitterConnection:self.searchString completionHandler:^(NSData *data){
        
        // Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithData:data];
        });
        
    }];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//  In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CollectionView"]) {
        
        // Get destination view
        PhotoCollectionViewController *destinationController = [segue destinationViewController];
        // Get selected cell info
        NSIndexPath* indexPath= [self.tableView indexPathForSelectedRow];
        TweetTableViewCell *cell = (TweetTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        destinationController.searchTag = [self getSearchKeyFromTweet:cell.tweetText.text];
       
    }
}

-(NSString*)getSearchKeyFromTweet:(NSString*)tweetString{
    
    // This method will return first word in tweet and remove @ in first word
    NSArray *comps = [tweetString componentsSeparatedByString:@" "];
    NSString * string = [comps objectAtIndex:0];
    return [string stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    
}



#pragma mark- Network Connection  methods

-(void)updateUIWithData:(NSData*)data{
    /*
     Setting different values for status message based on Network data..
     First checking Twitter permission with Bool variable TWITTER_GRANTED
     and then if data ==nil, means No network connection
     if there is error in parsing the data object , i.e No results found from Twitter API with given search key.
     */
    if([DataManager sharedInstance].TWITTER_GRANTED) {
        
        if(!data){
            stateMessage = @"Not Available";
            // no connection
        }else{
            
            NSError *jsonParsingError = nil;
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
            results = jsonResults[@"statuses"];
            
            if ([results count] == 0){
                
                NSArray *errors = jsonResults[@"errors"];
                if ([errors count]){
                    stateMessage = @"Not Available";
                }
                else{
                    stateMessage = @"No results found";
                }
            }else{
                // data found.....
            }
        }
    }else{
        
        stateMessage = @"Twitter Access Refused";
    }
    
    // Reload Table view to update UI and stop showing network indiacator on status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [results count];
    // To display status message if results array is empty
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use LoadCellIdentifier to display Status message while loading
    static NSString *ResultCellIdentifier = @"TweetCell";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [results count];
    
    // To display status message
    if ((count == 0) && (indexPath.row == 0))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        cell.textLabel.text = stateMessage;
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        return cell;
    }
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    
    // Display each tweet from results array
    NSDictionary *tweet = (results)[indexPath.row];
    cell.tweetText.text = tweet[@"text"];
    cell.tweetText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Distinguish Cell back ground colors alternatively
    if (indexPath.row % 2)
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

@end
