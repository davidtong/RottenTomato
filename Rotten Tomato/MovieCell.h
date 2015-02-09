//
//  MovieCell.h
//  Rotten Tomato
//
//  Created by David Tong on 2/4/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
