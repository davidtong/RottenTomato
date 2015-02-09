//
//  MovieDetailViewController.m
//  Rotten Tomato
//
//  Created by David Tong on 2/7/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailPosterImage;
@property (weak, nonatomic) IBOutlet UIScrollView *movieDetailScrollView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.movieDetailTitleLabel.text = self.movie[@"title"];
    self.movieDetailSynopsisLabel.text = self.movie[@"synopsis"];

    [self.movieDetailSynopsisLabel sizeToFit];
    
    [self.movieDetailScrollView setContentSize:CGSizeMake(self.movieDetailScrollView.frame.size.width, self.movieDetailSynopsisLabel.frame.size.height)];
    [self.view addSubview:self.movieDetailScrollView];
    
    /*
    UIScrollView *sv = [[UIScrollView alloc] init];
    
    double height = sv.contentSize.height;
    */
    //double height2 = [self.movieDetailSynopsisLabel sizeThatFits:]
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSMutableString *urlString = [NSMutableString stringWithString:[self.movie valueForKeyPath:@"posters.thumbnail"]];
    [urlString replaceCharactersInRange:[urlString rangeOfString: @"tmb.jpg"] withString: @"ori.jpg"];
    NSString *url = urlString;
    
    [self.movieDetailPosterImage setImageWithURL:[NSURL URLWithString:url]];
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.movieDetailPosterImage setImageWithURL:[NSURL URLWithString:self.lowResPoster]];
    [SVProgressHUD showWithStatus:@"Loading Poster"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
