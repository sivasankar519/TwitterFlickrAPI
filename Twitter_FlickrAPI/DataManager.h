//
//  DataManager.h
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *currentPhoto;
@property BOOL TWITTER_GRANTED;

+ (DataManager *)sharedInstance;

- (void)loadURLRequestWithURLString:(NSString *)urlString completionHandler:(void (^)(NSData *data))completionHandler;
-(void)twitterConnection:(NSString*)searchString completionHandler:(void (^)(NSData *data))completionHandler;

- (NSString *)getThumbnailImageURL:(NSDictionary*)currentPhoto;
- (NSString *)getOriginalImageURL:(NSDictionary*)currentPhoto;
@end
