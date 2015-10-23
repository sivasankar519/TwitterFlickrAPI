//
//  PhotoCollectionViewController.m
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "DataManager.h"
static NSString * const API_KEY = @"d515b0f9f2c88d498153db3c68649bbe";
static NSString * const recentPhotosURL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&format=json&nojsoncallback=1";

@interface PhotoCollectionViewController ()
{
    CGFloat cellWidth;
    CGFloat cellHeight;
    NSArray *photosInfo;
    NSMutableArray *urlsArray;
}
@end

@implementation PhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Set Cell size,
        To define Cell size with full frame
        width =  self.collectionView.frame.size.width;
        height =  self.collectionView.frame.size.height - self.navigationController.navigationBar.frame.size.height;
     */
    cellWidth = 100;
    cellHeight = 100;
    self.title = self.searchTag;
    
    // Requesting to get Photos based on Search Key
    [self getFlickrPhotos:self.searchTag];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFlickrPhotos:(NSString*)tag{
    
    // Forming URLString from base URL, API_Key and search_tag
    
    NSString *urlString = [NSString stringWithFormat:recentPhotosURL, API_KEY,tag];
    
    // Calling loadURL method  with sharedinstance of Datamanger, this will return Nsdata object once data fetching completed
    [[DataManager sharedInstance] loadURLRequestWithURLString:urlString completionHandler:^(NSData* data){
       
        // Setting required path photos/photo
        photosInfo =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil][@"photos"][@"photo"];
        
        // Update UI on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        
    }];

}



#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [photosInfo count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Setting thumbnail, original Image URLStrings for each Cell
    cell.thumbnailImageURL = [[DataManager sharedInstance] getOriginalImageURL:photosInfo[indexPath.row]];
    cell.originalImageURL = [[DataManager sharedInstance] getOriginalImageURL:photosInfo[indexPath.item]];
    
    // Call this ethod to update Cell
    [cell setUpCollectionCell];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // We can explicitely set the Size of each cell.
    return CGSizeMake(cellWidth, cellHeight);
    
}


@end
