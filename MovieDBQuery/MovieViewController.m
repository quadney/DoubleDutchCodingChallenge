//
//  MovieViewController.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *yearRatingRuntimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UITextView *plotSummaryTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@end

@implementation MovieViewController

const NSString *omdbRequestString = @"http://www.omdbapi.com/?v=1&";

- (void)viewWillAppear:(BOOL)animated {
    if (self.movie) {
        [self searchForMovieWithImdbId:self.movie.imdbID];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.movie) {
        self.movieTitle.text = self.movie.title;
        self.yearRatingRuntimeLabel.text = self.movie.year;
    }
}

- (void)updateUI {
    self.yearRatingRuntimeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", self.movie.year, self.movie.rating, self.movie.runtime];
    self.directorLabel.text = [NSString stringWithFormat:@"Directed by %@", self.movie.director];
    self.plotSummaryTextView.text = self.movie.plotSummary;
    //TODO website
    //TODO image
}

- (void)parseMovieJSONData:(NSDictionary *)json {
    [self.movie setRating:[json objectForKey:@"Rated"]
             runtime:[json objectForKey:@"Runtime"]
            director:[json objectForKey:@"Director"]
                plot:[json objectForKey:@"Plot"]
           posterURL:[json objectForKey:@"Poster"]
             website:[json objectForKey:@"Website"]];
}

- (NSString *)movieRequestString:(NSString *)imbdID {
    return [NSString stringWithFormat:@"%@i=%@&r=json", omdbRequestString, imbdID];
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

- (void)searchForMovieWithImdbId:(NSString *)imbdid {
    // requests the specific movie from the db
    [NSURLConnection sendAsynchronousRequest:[self generateRequest:[self movieRequestString:imbdid]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:0
                                                                                              error:nil];
                               [self parseMovieJSONData:jsonResponse];
                               
                               [self updateUI];
                               [self.activitySpinner startAnimating];
                               [self retrievePosterImage];
                               [self.activitySpinner stopAnimating];
                           }];
}

- (void)retrievePosterImage {
    self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.movie.posterURL]]];
}

@end
