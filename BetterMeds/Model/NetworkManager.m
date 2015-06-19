//
//  NetworkManager.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/14/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "NetworkManager.h"

#define BaseURL @"http://www.truemd.in/api/"
#define API_KEY @"fab7267c813d0fe819437deef957ac"

@interface NetworkManager (){
    
    NSString *baseURL;
    NSURLSessionConfiguration *sessionConfiguration;
    
}

@end

@implementation NetworkManager

-(NSURLSession *)session{
    if (!_session) {
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 15.0;
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return _session;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        baseURL =  BaseURL;
    }
    return self;
}

-(void)getMedicineDetailsForID:(NSString *)ID{
    
    NSString *pathComponent = [NSString stringWithFormat:@"medicine_details/?key=%@&id=%@",API_KEY,ID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseURL,pathComponent];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        [self.delegate updateDataSourceWith:[dict valueForKeyPath:@"response"]];
        
    }];
    
    [dataTask resume];
}

-(void)getMedicineSuggestionsForID:(NSString *)ID{
    
    NSString *pathComponent = [NSString stringWithFormat:@"medicine_suggestions/?key=%@&id=%@&limit=200",API_KEY,ID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseURL,pathComponent];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    //request.timeoutInterval = 15.0;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (error) {
            [self.delegate requestFailedWithError:(int)error.code];
            }
        else if (dict){
            [self.delegate updateDataSourceWith:[dict valueForKeyPath:@"response.suggestions"]];
            }
        
    }];
    
    [dataTask resume];
    
}

-(void)getMedicineAlternativesForID:(NSString *)ID{
    
    NSString *pathComponent = [NSString stringWithFormat:@"medicine_alternatives/?key=%@&id=%@&limit=10",API_KEY,ID];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",baseURL,pathComponent];
    
    NSURL *requestURL = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:requestURL  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        [self.delegate updateDataSourceWith:[dict valueForKeyPath:@"response.medicine_alternatives"]];
        
    }];
    
    [dataTask resume];
}


@end
