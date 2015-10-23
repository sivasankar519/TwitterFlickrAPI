//
//  DataManager.m
//  Twitter_FlickrAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/22/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DataManager.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TweetTableViewCell.h"

#define PERPAGE_TWEETS @"100"


typedef void (^completionHandler)(NSData *data);


@interface DataManager () < NSURLSessionDataDelegate >
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@property (nonatomic,strong) ACAccountStore *accountStore;


@end

@implementation DataManager

+ (DataManager *)sharedInstance {
    
    // To create Singleton object.
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        // Intializing
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:self
                                                delegateQueue:nil];
        
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}


# pragma mark - Twitter 


- (ACAccountStore *)accountStore
{
    if (_accountStore == nil)
    {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}



-(void)twitterConnection:(NSString*)searchString completionHandler:(void (^)(NSData *data))completionHandler{
    
    NSString *encodedSearch = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    // Setting AccountType object as Twitter
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // The completion block return Bool variable True if permissions accepted
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error)
     {
        
         self.TWITTER_GRANTED = granted;
         NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
         NSDictionary *parameters = @{@"count" : PERPAGE_TWEETS,
                                      @"q" : encodedSearch};
         
         // Requesting service for Twitter, type GET with url and parameters
         
         SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodGET
                                                             URL:url
                                                      parameters:parameters];
         // accountsWithAccountType will return NSArray, if only one account exists then we can get it index property.
         NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
         slRequest.account = [accounts lastObject];
         
         // Establishing connection with NSURLSessionDataTask
         NSURLRequest *request = [slRequest preparedURLRequest];
         
         NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
         
         // To return the completion block to calling place
         [self.dictionary setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSMutableData data], @"data",
                                     [completionHandler copy], @"completionHandler",
                                     nil]
                             forKey:task];
         [task resume];

     }];
}




- (NSString *)getThumbnailImageURL:(NSDictionary*)currentPhoto {
    
    //https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
    
    static NSString *baseStr = @"static.flickr.com/";
    
    NSMutableString *URLString = [NSMutableString stringWithString:@"https://"];
    [URLString appendFormat:@"farm%@.",currentPhoto[@"farm"]];
    
    
    [URLString appendString:baseStr];
    [URLString appendFormat:@"%@/%@_%@_t.jpg",currentPhoto[@"server"],currentPhoto[@"id"],currentPhoto[@"secret"]];
    
    return URLString;
    
    
}

- (NSString *)getOriginalImageURL:(NSDictionary*)currentPhoto{
    
    //https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
    
    static NSString *baseStr = @"static.flickr.com/";
    
    NSMutableString *URLString = [NSMutableString stringWithString:@"https://"];
    [URLString appendFormat:@"farm%@.",currentPhoto[@"farm"]];
    
    
    [URLString appendString:baseStr];
    
    [URLString appendFormat:@"%@/%@_%@.jpg",currentPhoto[@"server"],currentPhoto[@"id"],currentPhoto[@"secret"]];
    
    return URLString;
    
    
}

- (void)loadURLRequestWithURLString:(NSString *)urlString completionHandler:(void (^)(NSData *data))completionHandler {
    
    // Establishing connection with NSURLSessionDataTask
    // To return the completion block to calling place
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    [self.dictionary setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSMutableData data], @"data",
                                [completionHandler copy], @"completionHandler",
                                nil]
                        forKey:task];
    [task resume];
}

#pragma NSURLSession

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.dictionary[dataTask][@"data"] appendData:data];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    // Handover the completion block of this method to dictionary object with typeDef completion block.
    if (self.dictionary[task]) {
        completionHandler completionHandler = self.dictionary[task][@"completionHandler"];
        
        if (completionHandler) {
            completionHandler(self.dictionary[task][@"data"]);
        }
    }
}
@end
