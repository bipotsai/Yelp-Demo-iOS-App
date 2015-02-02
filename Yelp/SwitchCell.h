//
//  SwitchCell.h
//  Yelp
//
//  Created by Chinmay Kini on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

-(void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL) value;

@end


@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property ( nonatomic, assign)  BOOL on;
@property(nonatomic, weak) id<SwitchCellDelegate> delegate;


@end
