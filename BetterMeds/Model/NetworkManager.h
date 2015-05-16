//
//  NetworkManager.h
//  BetterMeds
//
//  Created by Vinay Jain on 5/14/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NetworkManager;

@protocol NetworkDelegate <NSObject>

-(void)updateDataSourceWith:(id) dataSource;

@end


@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;
-(void)getMedicineDetailsForID:(NSString *)ID;
-(void)getMedicineSuggestionsForID:(NSString *)ID;
@property(weak,nonatomic) id <NetworkDelegate> delegate;

@end
