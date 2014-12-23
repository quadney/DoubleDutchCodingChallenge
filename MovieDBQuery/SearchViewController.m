//
//  SearchViewController.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "SearchViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

const NSString *movieReuseIdentifier = @"MovieCell";
const NSString *omdbRequest = @"http://www.omdbapi.com/?v=1&";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - querying OMDB
- (void)searchForMovies:(NSString *)urlString {
    // requests the search results from the db
    [NSURLConnection sendAsynchronousRequest:[self generateRequest:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // TODO add in an activity spinner
                               // dismiss the keyboard
                               
                               NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:0
                                                                                              error:nil];
                               [self parseSearchJSONData:jsonResponse];
                               [self.tableView reloadData];
    }];
}

- (NSMutableURLRequest *)generateRequest:(NSString *)urlString
{
    // generate url
    NSURL *url = [NSURL URLWithString:urlString];
    
    // generate request
    return [NSMutableURLRequest requestWithURL:url
                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                               timeoutInterval:60.0];
}

- (NSString *)searchRequestString:(NSString *)search {
    return [NSString stringWithFormat:@"%@s=%@&r=json", omdbRequest, search];
}

#pragma mark - JSON Parsing

- (void)parseSearchJSONData:(NSDictionary *)json {
    NSArray *rawData = [json objectForKey:@"Search"];
    self.searchResults = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [rawData count]; i++) {
        Movie *movie = [[Movie alloc] init];
        [movie setTitle:[[rawData objectAtIndex:i] objectForKey:@"Title"]
                   year:[[rawData objectAtIndex:i] objectForKey:@"Year"]
                   type:[[rawData objectAtIndex:i] objectForKey:@"Type"]
                 imdbID:[[rawData objectAtIndex:i] objectForKey:@"imdbID"]];
        [self.searchResults addObject:movie];
    }
}


#pragma mark - Text/Search Field methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Text field should return");
    //[self.searchField endEditing:YES];
    [self searchForMovies:[self searchRequestString:textField.text]];
    
    return YES;
}

#pragma mark - Table View methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"
                                                           forIndexPath:indexPath];
    
    Movie *movie = [self.searchResults objectAtIndex:indexPath.item];
    cell.movie = movie;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    if ([segue.identifier isEqualToString:@"MovieDetail"]) {
        // Pass the selected object to the new view controller.
        NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        
        MovieViewController *mVC = (MovieViewController *)segue.destinationViewController;
        mVC.movie = [self.searchResults objectAtIndex:path.row];
    }
    
}

@end
