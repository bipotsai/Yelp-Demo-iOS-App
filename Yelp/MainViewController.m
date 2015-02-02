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
#import "FilterViewController.h"
#import "CollectiveViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate, CollectiveViewControllerDelegate>


@property (nonatomic, strong) YelpClient *client;
@property ( nonatomic, strong) NSArray *businesses;

-(void) fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessWithQuery:@"restaurants" params:nil]; // search all restaurents by default
        
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
//    self.title                  = @"Yelp";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // filter button
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(onFilterButton)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;
    
    // set listner
    searchBar.delegate = self;
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
    
    BusinessCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business       = self.businesses[indexPath.row];
    return cell;
    
}

#pragma mark - searchbar delegate mothods

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Search text  : %@",searchText );
    [self fetchBusinessWithQuery:searchText params:nil];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
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

-(void) filterViewController:(FilterViewController *)filterViewController didChangeFilter:(NSDictionary *)filters{
    
    // when the event happens what to do?
    // fire new network event
    NSLog(@"Fire new Network Event : %@", filters);
    [self fetchBusinessWithQuery:@"restaurants" params:filters];
}

-(void) collectiveViewController:(CollectiveViewController *)collectiveViewController didChangeFilter:(NSDictionary *)collectivefilters{
    // when the event happens what to do?
    // fire new network event
    NSLog(@"Fire new Network Event : %@", collectivefilters);
    [self fetchBusinessWithQuery:@"restaurants" params:collectivefilters];
}

#pragma mark - Private Methods

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params{
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"REsponse :  %@", response);

        NSLog(@"query: %@ , params %@", query, params);
        
        NSArray *businessDictionaries = response[@"businesses"];
        
        NSLog(@"Result Set Found :  %ld items", businessDictionaries.count);
        
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void) onFilterButton {
    
    
//    FilterViewController *vc = [[FilterViewController alloc] init];
//    // When you go to teh next screen. register that to the next screen you will listen to this event
//    // listen to the delegate created
//    vc.delegate = self;
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];
    
    
    CollectiveViewController *vc = [[CollectiveViewController alloc] init];
    // When you go to teh next screen. register that to the next screen you will listen to this event
    // listen to the delegate created
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc ];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self presentViewController:nvc animated:YES completion:nil];
    
    
}


@end
