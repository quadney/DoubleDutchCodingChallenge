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
}

#pragma mark - querying OMDB
- (void)searchForMovies:(NSString *)urlString {
    // requests the search results from the db
    [NSURLConnection sendAsynchronousRequest:[self generateRequest:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if(connectionError){
                                   NSLog(@"There was an error \n%@", connectionError);
                                   // ideally let the user know that maybe their internet doesnt work
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:[connectionError localizedDescription]
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Okay"
                                                                         otherButtonTitles: nil];
                                   [alert show];
                               }
                               else {
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:0
                                                                                                  error:nil];
                                   [self parseSearchJSONData:jsonResponse];
                                   [self.tableView reloadData];
                               }
                               
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
    // creates the URL string for searching
    return [NSString stringWithFormat:@"%@s=%@&r=json", omdbRequest, [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - JSON Parsing

- (void)parseSearchJSONData:(NSDictionary *)json {
    // parses the json data
    
    // extract Search json objects into array
    NSArray *rawData = [json objectForKey:@"Search"];
    
    // init search results mutable array
    self.searchResults = [[NSMutableArray alloc] init];
    
    // for each json object in the raw data array,
    // parse the data into Movie object and put into search results array
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
    // dismiss the keyboard
    [self.searchField endEditing:YES];
    
    // searches for movies using the returned url string
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
    // each cell has a corresponding movie, the cell updates it's UI
    cell.movie = movie;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    // check to make sure it's the correct segue
    if ([segue.identifier isEqualToString:@"MovieDetail"]) {
        // Passs the selected object to the new view controller.
        // get the right path
        NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        
        // make the new view controller
        MovieViewController *mVC = (MovieViewController *)[segue destinationViewController];
        // set the movie to the new view controller
        mVC.movie = [self.searchResults objectAtIndex:path.row];
    }
    
}

@end
