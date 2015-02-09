//
//  MovieDetailViewController.h
//  Rotten Tomato
//
//  Created by David Tong on 2/7/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (nonatomic, strong) NSDictionary *movie;
@property (nonatomic, strong) NSString *lowResPoster;

@end
