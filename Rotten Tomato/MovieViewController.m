//
//  MovieViewController.m
//  Rotten Tomato
//
//  Created by David Tong on 2/2/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "MovieDetailViewController.h"

@interface MovieViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedValueChanged:(id)sender;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionCell"];
    
    self.tableView.rowHeight = 180;
    
    [SVProgressHUD showWithStatus:@"Fetching data"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(200, 200)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    */
    
    [self onRefresh];
}

- (void)onRefresh {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&country=us&apikey=awqb7gftz24ejwzprefu96d7"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            self.errorLabel.text = @"! Network Error";
            self.errorLabel.hidden = NO;
            [SVProgressHUD dismiss];
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //NSLog(@"response: %@", responseDictionary);
            self.movies = responseDictionary[@"movies"];
            [self.tableView reloadData];
            [self.collectionView reloadData];
            
            [SVProgressHUD dismiss];
            
            self.title = @"All Movies";
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection methods

-(NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.largePosterView setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
}

#pragma mark - Table methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:url]];
    
    //NSLog(@"%@", [NSString stringWithFormat: @"section %ld %ld", indexPath.section, indexPath.row]);
                           
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    vc.movie = movie;
    vc.lowResPoster = [movie valueForKeyPath:@"posters.thumbnail"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentedValueChanged:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
}
@end
