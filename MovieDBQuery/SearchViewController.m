//
//  SearchViewController.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "SearchViewController.h"
#import "MovieCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

static const NSString *movieReuseIdentifier = @"MovieCell";
const NSString *omdbRequest = @"http://www.omdbapi.com/?v=1&";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - querying OMDB
- (void)searchForMovie:(NSString *)movie {
    // encapsulates the process of requesting the json from the server
    
    // generate url
    NSURL *url = [NSURL URLWithString:[self requestString:movie]];
    
    // generate request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // TODO add in an activity spinner
                               // dismiss the keyboard
                               
                               NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:0
                                                                                              error:nil];
                               NSLog(@"JSON objects: %i", [jsonResponse count]);
                               
                               self.searchResults = [jsonResponse objectForKey:@"Search"];
                               
                               NSLog(@"Number search results: %i", [self.searchResults count]);
                               
                               [self.tableView reloadData];
                               
    }];
}

- (NSString *)requestString:(NSString *)search {
    return [NSString stringWithFormat:@"%@s=%@&r=json", omdbRequest, search];
}

#pragma mark - JSON Parsing

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"TExt field should return");
    //[self.searchField endEditing:YES];
    [self searchForMovie:textField.text];
    
    return YES;
}

#pragma mark - UITableviewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"
                                                           forIndexPath:indexPath];
    
    NSDictionary *movie = [self.searchResults objectAtIndex:indexPath.item];
    
    [cell updateUIWithTitle:[movie objectForKey:@"Title"] year:[movie objectForKey:@"Year"] filmType:[movie objectForKey:@"Type"] tScore:0];
    
    return cell;
}

@end
