//
//  FilterViewController.h
//  Yelp
//
//  Created by Chinmay Kini on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

-(void) filterViewController:(FilterViewController *) filterViewController didChangeFilter:(NSDictionary *) filters;


@end

@interface FilterViewController : UIViewController

@property( nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
