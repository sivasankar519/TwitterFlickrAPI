//
//  CustomCollectionViewCell.m
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "DataManager.h"
@implementation CustomCollectionViewCell


- (void)setUpCollectionCell {
    
    // Get the Image data specific to Cell,
    // Calling LoadURL mehtod by passing URLstring this will give Data Object on completion block
    [[DataManager sharedInstance] loadURLRequestWithURLString:self.thumbnailImageURL completionHandler:^(NSData *data) {
        if (data) {
            
            // Update UI even its already presented to user,
            // setNeedsDisplay will override the drawRect method in its subviews to make changes on view.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgView.image = [UIImage imageWithData:data];
                [self setNeedsDisplay];
            });
        }
    }];
}

@end
