//
//  BusinessCell.m
//  Yelp
//
//  Created by Chinmay Kini on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"


@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    
    // To make sure the text doesnt run into the next lable. this and implement teh fucntion layoutsubviews
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    // to round the corners
    self.thumbImageView.layer.cornerRadius  = 5;
    self.thumbImageView.clipsToBounds       = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBusiness:(Business *)business{
    
    // why is this required? whats underscoer?
    _business = business;
    
    // set the lables from business object
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    self.nameLabel.text = self.business.name;
    [self.ratingImageLabel setImageWithURL:[NSURL URLWithString:self.business.ratingUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews",self.business.numReviews];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    self.categoryLabel.text = self.business.categories;
    self.dealLabel.text     = self.business.deal;
}

// implemet this fucntion to align stuff properly
-(void) layoutSubviews{
    [super layoutSubviews];
    // To make sure the text doesnt run into the next lable. this and implement teh fucntion layoutsubviews
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}
@end
