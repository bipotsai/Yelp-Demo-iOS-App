//
//  CollectiveViewController.h
//  Yelp
//
//  Created by Chinmay Kini on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CollectiveViewController;
@protocol CollectiveViewControllerDelegate <NSObject>

-(void) collectiveViewController:(CollectiveViewController *) collectiveViewController didChangeFilter:(NSDictionary *) collectivefilters;


@end

@interface CollectiveViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@property( nonatomic, weak) id<CollectiveViewControllerDelegate> delegate;

@end
