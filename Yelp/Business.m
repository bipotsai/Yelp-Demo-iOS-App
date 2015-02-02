//
//  Business.m
//  Yelp
//
//  Created by Chinmay Kini on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

-(id) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
            
    if(self){
        
        // categories is array of arrays hence pluck out and concatenate by string
        NSArray *categories             = dictionary[@"categories"];
        NSMutableArray *categoryNames   = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories                 = [categoryNames componentsJoinedByString:@","];
        
        // others
        self.name               = dictionary[@"name"];
        self.imageUrl           = dictionary[@"image_url"];
        self.ratingUrl          = dictionary[@"rating_img_url"];
        
        
        NSArray *addresses      = [dictionary valueForKeyPath:@"location.address"];
        NSString *street        = nil;
        if(addresses.count>0){
            street              = addresses[0];
        }
        
        NSArray *neighbourhoods         = [dictionary valueForKeyPath:@"location.neighborhoods"];
        NSString *neighbourhood         = nil;
        if(neighbourhoods.count>0){
            neighbourhood               = neighbourhoods[0];
        }
        
        if(street && neighbourhood){
            self.address            = [NSString stringWithFormat:@"%@, %@", street, neighbourhood];
        } else{
            self.address            = @"";
        }
        
       
        self.numReviews         = [dictionary[@"review_count"] integerValue];
        
        float milesPerMeter     = 0.000621317;
        self.distance           = [dictionary[@"distance"] integerValue] * milesPerMeter;
    }
    return self;
}

+(NSArray *) businessesWithDictionaries:(NSArray *) dictionaries{
    NSMutableArray *businesses = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries){
        
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        
        [businesses addObject:business];
    }
    return businesses;
}

@end
