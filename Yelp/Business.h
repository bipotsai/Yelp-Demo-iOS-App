//
//  Business.h
//  Yelp
//
//  Created by Chinmay Kini on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject
@property ( nonatomic, strong) NSString *imageUrl;
@property ( nonatomic, strong) NSString *name;
@property ( nonatomic, strong) NSString *ratingUrl;
@property ( nonatomic, assign) NSInteger numReviews;
@property ( nonatomic, strong) NSString *address;
@property ( nonatomic, strong) NSString *categories;
@property ( nonatomic, assign) CGFloat distance;
@property ( nonatomic, strong) NSString *deal;

+(NSArray *) businessesWithDictionaries:(NSArray *) dictionaries;

@end
