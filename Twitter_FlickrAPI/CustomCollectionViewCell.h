//
//  CustomCollectionViewCell.h
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) NSString *thumbnailImageURL;
@property (nonatomic, strong) NSString *originalImageURL;

- (void)setUpCollectionCell;
@end
