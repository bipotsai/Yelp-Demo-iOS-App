//
//  CollectiveViewController.m
//  Yelp
//
//  Created by Chinmay Kini on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "CollectiveViewController.h"
#import "SwitchCell.h"

@interface CollectiveViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property( nonatomic, strong) NSArray *categories;
@property( nonatomic, strong) NSArray *distanceCategories;
@property( nonatomic, strong) NSArray *sortCategories;
@property( nonatomic, strong) NSMutableSet *selectedCategories; // to hold the selected categories that were switch on
@property( nonatomic, strong) NSMutableSet *selectedDistances; // to hold the selected categories that were switch on
@property( nonatomic, strong) NSMutableSet *selectedSorts; // to hold the selected categories that were switch on
@property( nonatomic, assign) BOOL *isDealSelected; // to hold the selected categories that were switch on

@property( nonatomic, readonly) NSDictionary *filters;      // this is passed back from the view, whihc is used to fire the next rest call



-(void)initCategories;

@end

@implementation CollectiveViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        
        self.selectedCategories = [NSMutableSet set];
        self.selectedDistances  = [NSMutableSet set];
        self.selectedSorts      = [NSMutableSet set];
        
        [self initCategories];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Filters";
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(onApplyButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButton)];
    
     [self.filterTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
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

#pragma mark - table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }else if(section==1){
        return self.distanceCategories.count;
    }else if(section==2){
        return self.sortCategories.count;
    }else{
        return self.categories.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    if(indexPath.section == 0){
        cell.titleField.text = @"Deals";
        cell.on = self.isDealSelected;
    } else if( indexPath.section == 1){
        cell.titleField.text = self.distanceCategories[indexPath.row][@"name"];
        // to make sure the cells state is synchronised with the slected value.
        cell.on = [self.selectedDistances containsObject:self.distanceCategories[indexPath.row]];
    } else if( indexPath.section == 2){
        cell.titleField.text = self.sortCategories[indexPath.row][@"name"];
        // to make sure the cells state is synchronised with the slected value.
        cell.on = [self.selectedSorts containsObject:self.sortCategories[indexPath.row]];
    } else{
        cell.titleField.text = self.categories[indexPath.row][@"name"];
        // to make sure the cells state is synchronised with the slected value.
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    }

    // listen to the switch cell event
    cell.delegate = self;
    
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Deals";
    if(section == 1)
        return @"Distance";
    if(section == 2)
        return @"Sort By";
    if(section == 3)
        return @"Categories";
    return @"Title";
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 50;
//}

#pragma mark - Switch Cell delegate methods

-(void)switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value{
    
    //How did you get the index path from here??
    NSIndexPath *indexPath = [self.filterTableView indexPathForCell:switchCell];
    
     NSLog(@"%@", [NSString stringWithFormat:@"Check this Section :%ld Row : %ld", indexPath.section, indexPath.row ]);
    
    if(indexPath.section == 0){
        if(value){
            [self setIsDealSelected:YES];
        }else{
            [self setIsDealSelected:NO];
        }

    } else if( indexPath.section == 1){
        if(value){
            [self deSelectSwitchesInSection:switchCell];
            [self.selectedDistances addObject:self.distanceCategories[indexPath.row]];
        }else{
            [self.selectedDistances removeObject:self.distanceCategories[indexPath.row]];
        }
    } else if( indexPath.section == 2 ){
        if(value){
            [self deSelectSwitchesInSection:switchCell];
            [self.selectedSorts addObject:self.sortCategories[indexPath.row]];
        }else{
            [self.selectedSorts removeObject:self.sortCategories[indexPath.row]];
        }
    } else{
        if(value){
//            [self deSelectSwitchesInSection:switchCell];
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        }else{
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }

    }

}


#pragma mark - private methods


// this is called when you di self.filter.. on applybutton pressed
-(NSDictionary *) filters{
    NSMutableDictionary * filters = [NSMutableDictionary dictionary];
    
    // build the filters if there are selected categories
    if(self.selectedCategories.count>0){
        
        //To hold CAtegory names
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories){
            [names addObject:category[@"code"]];
        }
        NSString *categoryNames = [names componentsJoinedByString:@","];
        
        // set this as category filter which is the key for the new search with selected categories
        [filters setObject:categoryNames forKey:@"category_filter"];
        
    }
    
    if(self.selectedDistances.count>0){
        
        NSInteger distance = 0;
//        NSLog(@"Distances %@", self.selectedDistances);
        for(NSDictionary *category in self.selectedDistances){
            distance = [category[@"code"] integerValue] * 1609;     // converting to meters
        }
//        NSLog(@"Distance %ld", (long)distance);
        [filters setObject:[NSNumber numberWithInteger:distance] forKey:@"radius_filter"];
        
    }
    
    if(self.selectedSorts.count>0){
        NSInteger sortType = 0;
        for(NSDictionary *category in self.selectedSorts){
            sortType = [category[@"code"] integerValue];
        }
        [filters setObject:[NSNumber numberWithInteger:sortType] forKey:@"sort"];
        
    }
    
    if(self.isDealSelected){
        [filters setObject:[NSNumber numberWithBool:self.isDealSelected] forKey:@"deals_filter"];
    }

    
    return filters;
    
}

- (void)deSelectSwitchesInSection:(SwitchCell *)switchCell{
    NSIndexPath *indexPath = [self.filterTableView indexPathForCell:switchCell];
    
    for (int row = 0; row < [self.filterTableView numberOfRowsInSection:indexPath.section]; row++) {
        if(row == indexPath.row){
            continue;
//            NSLog(@"SKipped");
        }
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        SwitchCell* cell = [self.filterTableView cellForRowAtIndexPath:cellPath];
//         NSLog(@"deselect");
        [cell setOn:NO];
    }
    
    
    if(indexPath.section == 1){
        [self.selectedDistances removeAllObjects];
    } else if( indexPath.section == 2){
        [self.selectedSorts removeAllObjects];
    }
}

-(void) onCancelButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) onApplyButton {
    
    // register that event happened and pass back the filter
    [self.delegate collectiveViewController:self didChangeFilter:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initCategories{
    
    self.distanceCategories =
    @[@{@"name" : @"Best Match", @"code": @"0" },
      @{@"name" : @"0.3 miles", @"code": @"0.3" },
      @{@"name" : @"1 mile", @"code": @"1" },
      @{@"name" : @"5 miles", @"code": @"5" },
      @{@"name" : @"20 miles", @"code": @"20" }];
    
    self.sortCategories =
    @[@{@"name" : @"Best Match", @"code": @"0" },
      @{@"name" : @"Distance", @"code": @"1" },
      @{@"name" : @"Rating", @"code": @"2" }];
    
    self.categories =
    @[@{@"name" : @"Afghan", @"code": @"afghani" },
      @{@"name" : @"African", @"code": @"african" },
      @{@"name" : @"American, New", @"code": @"newamerican" },
      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
      @{@"name" : @"Arabian", @"code": @"arabian" },
      @{@"name" : @"Argentine", @"code": @"argentine" },
      @{@"name" : @"Armenian", @"code": @"armenian" },
      @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
      @{@"name" : @"Asturian", @"code": @"asturian" },
      @{@"name" : @"Australian", @"code": @"australian" },
      @{@"name" : @"Austrian", @"code": @"austrian" },
      @{@"name" : @"Baguettes", @"code": @"baguettes" },
      @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
      @{@"name" : @"Barbeque", @"code": @"bbq" },
      @{@"name" : @"Basque", @"code": @"basque" },
      @{@"name" : @"Bavarian", @"code": @"bavarian" },
      @{@"name" : @"Beer Garden", @"code": @"beergarden" },
      @{@"name" : @"Beer Hall", @"code": @"beerhall" },
      @{@"name" : @"Beisl", @"code": @"beisl" },
      @{@"name" : @"Belgian", @"code": @"belgian" },
      @{@"name" : @"Bistros", @"code": @"bistros" },
      @{@"name" : @"Black Sea", @"code": @"blacksea" },
      @{@"name" : @"Brasseries", @"code": @"brasseries" },
      @{@"name" : @"Brazilian", @"code": @"brazilian" },
      @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
      @{@"name" : @"British", @"code": @"british" },
      @{@"name" : @"Buffets", @"code": @"buffets" },
      @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
      @{@"name" : @"Burgers", @"code": @"burgers" },
      @{@"name" : @"Burmese", @"code": @"burmese" },
      @{@"name" : @"Cafes", @"code": @"cafes" },
      @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
      @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
      @{@"name" : @"Cambodian", @"code": @"cambodian" },
      @{@"name" : @"Canadian", @"code": @"New)" },
      @{@"name" : @"Canteen", @"code": @"canteen" },
      @{@"name" : @"Caribbean", @"code": @"caribbean" },
      @{@"name" : @"Catalan", @"code": @"catalan" },
      @{@"name" : @"Chech", @"code": @"chech" },
      @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
      @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
      @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
      @{@"name" : @"Chilean", @"code": @"chilean" },
      @{@"name" : @"Chinese", @"code": @"chinese" },
      @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
      @{@"name" : @"Corsican", @"code": @"corsican" },
      @{@"name" : @"Creperies", @"code": @"creperies" },
      @{@"name" : @"Cuban", @"code": @"cuban" },
      @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
      @{@"name" : @"Cypriot", @"code": @"cypriot" },
      @{@"name" : @"Czech", @"code": @"czech" },
      @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
      @{@"name" : @"Danish", @"code": @"danish" },
      @{@"name" : @"Delis", @"code": @"delis" },
      @{@"name" : @"Diners", @"code": @"diners" },
      @{@"name" : @"Dumplings", @"code": @"dumplings" },
      @{@"name" : @"Eastern European", @"code": @"eastern_european" },
      @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
      @{@"name" : @"Fast Food", @"code": @"hotdogs" },
      @{@"name" : @"Filipino", @"code": @"filipino" },
      @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
      @{@"name" : @"Fondue", @"code": @"fondue" },
      @{@"name" : @"Food Court", @"code": @"food_court" },
      @{@"name" : @"Food Stands", @"code": @"foodstands" },
      @{@"name" : @"French", @"code": @"french" },
      @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
      @{@"name" : @"Galician", @"code": @"galician" },
      @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
      @{@"name" : @"Georgian", @"code": @"georgian" },
      @{@"name" : @"German", @"code": @"german" },
      @{@"name" : @"Giblets", @"code": @"giblets" },
      @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
      @{@"name" : @"Greek", @"code": @"greek" },
      @{@"name" : @"Halal", @"code": @"halal" },
      @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
      @{@"name" : @"Heuriger", @"code": @"heuriger" },
      @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
      @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
      @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
      @{@"name" : @"Hot Pot", @"code": @"hotpot" },
      @{@"name" : @"Hungarian", @"code": @"hungarian" },
      @{@"name" : @"Iberian", @"code": @"iberian" },
      @{@"name" : @"Indian", @"code": @"indpak" },
      @{@"name" : @"Indonesian", @"code": @"indonesian" },
      @{@"name" : @"International", @"code": @"international" },
      @{@"name" : @"Irish", @"code": @"irish" },
      @{@"name" : @"Island Pub", @"code": @"island_pub" },
      @{@"name" : @"Israeli", @"code": @"israeli" },
      @{@"name" : @"Italian", @"code": @"italian" },
      @{@"name" : @"Japanese", @"code": @"japanese" },
      @{@"name" : @"Jewish", @"code": @"jewish" },
      @{@"name" : @"Kebab", @"code": @"kebab" },
      @{@"name" : @"Korean", @"code": @"korean" },
      @{@"name" : @"Kosher", @"code": @"kosher" },
      @{@"name" : @"Kurdish", @"code": @"kurdish" },
      @{@"name" : @"Laos", @"code": @"laos" },
      @{@"name" : @"Laotian", @"code": @"laotian" },
      @{@"name" : @"Latin American", @"code": @"latin" },
      @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
      @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
      @{@"name" : @"Malaysian", @"code": @"malaysian" },
      @{@"name" : @"Meatballs", @"code": @"meatballs" },
      @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
      @{@"name" : @"Mexican", @"code": @"mexican" },
      @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
      @{@"name" : @"Milk Bars", @"code": @"milkbars" },
      @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
      @{@"name" : @"Modern European", @"code": @"modern_european" },
      @{@"name" : @"Mongolian", @"code": @"mongolian" },
      @{@"name" : @"Moroccan", @"code": @"moroccan" },
      @{@"name" : @"New Zealand", @"code": @"newzealand" },
      @{@"name" : @"Night Food", @"code": @"nightfood" },
      @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
      @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
      @{@"name" : @"Oriental", @"code": @"oriental" },
      @{@"name" : @"Pakistani", @"code": @"pakistani" },
      @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
      @{@"name" : @"Parma", @"code": @"parma" },
      @{@"name" : @"Persian/Iranian", @"code": @"persian" },
      @{@"name" : @"Peruvian", @"code": @"peruvian" },
      @{@"name" : @"Pita", @"code": @"pita" },
      @{@"name" : @"Pizza", @"code": @"pizza" },
      @{@"name" : @"Polish", @"code": @"polish" },
      @{@"name" : @"Portuguese", @"code": @"portuguese" },
      @{@"name" : @"Potatoes", @"code": @"potatoes" },
      @{@"name" : @"Poutineries", @"code": @"poutineries" },
      @{@"name" : @"Pub Food", @"code": @"pubfood" },
      @{@"name" : @"Rice", @"code": @"riceshop" },
      @{@"name" : @"Romanian", @"code": @"romanian" },
      @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
      @{@"name" : @"Rumanian", @"code": @"rumanian" },
      @{@"name" : @"Russian", @"code": @"russian" },
      @{@"name" : @"Salad", @"code": @"salad" },
      @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
      @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
      @{@"name" : @"Scottish", @"code": @"scottish" },
      @{@"name" : @"Seafood", @"code": @"seafood" },
      @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
      @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
      @{@"name" : @"Singaporean", @"code": @"singaporean" },
      @{@"name" : @"Slovakian", @"code": @"slovakian" },
      @{@"name" : @"Soul Food", @"code": @"soulfood" },
      @{@"name" : @"Soup", @"code": @"soup" },
      @{@"name" : @"Southern", @"code": @"southern" },
      @{@"name" : @"Spanish", @"code": @"spanish" },
      @{@"name" : @"Steakhouses", @"code": @"steak" },
      @{@"name" : @"Sushi Bars", @"code": @"sushi" },
      @{@"name" : @"Swabian", @"code": @"swabian" },
      @{@"name" : @"Swedish", @"code": @"swedish" },
      @{@"name" : @"Swiss Food", @"code": @"swissfood" },
      @{@"name" : @"Tabernas", @"code": @"tabernas" },
      @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
      @{@"name" : @"Tapas Bars", @"code": @"tapas" },
      @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
      @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
      @{@"name" : @"Thai", @"code": @"thai" },
      @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
      @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
      @{@"name" : @"Trattorie", @"code": @"trattorie" },
      @{@"name" : @"Turkish", @"code": @"turkish" },
      @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
      @{@"name" : @"Uzbek", @"code": @"uzbek" },
      @{@"name" : @"Vegan", @"code": @"vegan" },
      @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
      @{@"name" : @"Venison", @"code": @"venison" },
      @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
      @{@"name" : @"Wok", @"code": @"wok" },
      @{@"name" : @"Wraps", @"code": @"wraps" },
      @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
    
}

@end
