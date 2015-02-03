//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "CollectiveViewController.h"
#import "UIScrollView+InfiniteScroll.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CollectiveViewControllerDelegate>


@property (nonatomic, strong) YelpClient *client;
@property ( nonatomic, strong) NSArray *businesses;
@property ( nonatomic, strong) UISearchBar *searchBar;

-(void) fetchBusinessWithQuery:(NSString *)query offset:(int)offset params:(NSDictionary *)params;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        self.offset = 0;
        [self fetchBusinessWithQuery:@"restaurants" offset:self.offset params:nil]; // search all restaurents by default
        
//        [self.client searchWithTerm:@"Thai" params:nil success:^(AFHTTPRequestOperation *operation, id response) {
////            NSLog(@"response: %@", response);
//            
//            NSArray *businessDictionaries = response[@"businesses"];
//            
//            self.businesses = [Business businessesWithDictionaries:businessDictionaries];
//            [self.tableView reloadData];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error: %@", [error description]);
//        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.offset                 = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    // Color the Nav Bar
    self.navigationController.navigationBar.barTintColor    = [UIColor redColor];
    self.navigationController.navigationBar.tintColor       = [UIColor blackColor];
    self.navigationController.navigationBar.translucent     = YES;

    
    // filter button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    // Search Bar
    self.searchBar                      = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton    = YES;
    self.navigationItem.titleView       = self.searchBar;

    // Infinite Scroll
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    
    // set listner
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Section %ld Row %ld", indexPath.section, indexPath.row);
    
    BusinessCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business       = self.businesses[indexPath.row];
    
    if(indexPath.row == 19){
        // setup infinite scroll
        [self.tableView addInfiniteScrollWithHandler:^(UIScrollView* scrollView) {
            self.offset = self.offset + 20;
            [self fetchBusinessWithQuery:@"restaurants" offset:self.offset params:self.params];
            // finish infinite scroll animation
            [scrollView finishInfiniteScroll];
        }];
    }
    
    return cell;
    
}

#pragma mark - searchbar delegate mothods

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Search text  : %@",searchText );
    self.offset = 0;
    [self fetchBusinessWithQuery:searchText offset:self.offset params:nil];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    searchBar.text = nil;
    [searchBar resignFirstResponder];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [searchBar resignFirstResponder];
}


#pragma mark - Filter delegate methods

-(void) collectiveViewController:(CollectiveViewController *)collectiveViewController didChangeFilter:(NSDictionary *)collectivefilters{
    // when the event happens what to do?
    // fire new network event
    self.searchBar.text = nil;
    self.params = collectivefilters;
    NSLog(@"Fire new Network Event : %@", collectivefilters);
    self.offset = 0;
    [self fetchBusinessWithQuery:@"restaurants" offset:self.offset params:collectivefilters];
}

#pragma mark - Private Methods

-(void)fetchBusinessWithQuery:(NSString *)query offset:(int)offset params:(NSDictionary *)params{
    
    [self.client searchWithTerm:query offset:offset params:params success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"REsponse :  %@", response);

        NSLog(@"query: %@ , params %@", query, params);
        
        NSArray *businessDictionaries = response[@"businesses"];
        
//        NSLog(@"Result Set Found :  %ld items", businessDictionaries.count);
        
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void) onFilterButton {
    
    CollectiveViewController *vc = [[CollectiveViewController alloc] init];
    // When you go to teh next screen. register that to the next screen you will listen to this event
    // listen to the delegate created
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc ];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
    
}


@end
