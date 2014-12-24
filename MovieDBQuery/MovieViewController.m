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
@property (weak, nonatomic) IBOutlet UITextView *websiteLabel;
@property (weak, nonatomic) IBOutlet UITextView *plotSummaryTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@end

@implementation MovieViewController

const NSString *omdbRequestString = @"http://www.omdbapi.com/?v=1&";

- (void)viewWillAppear:(BOOL)animated {
    // hide all the potentially null text fields
    [self setEverythingHidden];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    if (self.movie) {
        // if the movie was set properly, get the rest of the data from the db
        self.movieTitle.text = self.movie.title;
        self.yearRatingRuntimeLabel.text = self.movie.year;
        
        [self.activitySpinner startAnimating];
        [self searchForMovieWithImdbId:self.movie.imdbID];
        
    }
}

- (void)updateUI {
    // updates the UI
    
    // if some fields aren't givin, then don't display them
    [self checkIfValidUILabel:self.yearRatingRuntimeLabel
                     ofString:self.movie.rating
             stringWithFormat:[NSString stringWithFormat:@"%@ | %@", self.yearRatingRuntimeLabel.text, self.movie.rating]];
    
    [self checkIfValidUILabel:self.yearRatingRuntimeLabel
                     ofString:self.movie.runtime
             stringWithFormat:[NSString stringWithFormat:@"%@ | %@", self.yearRatingRuntimeLabel.text, self.movie.runtime]];
    
    [self checkIfValidUILabel:self.directorLabel
                     ofString:self.movie.director
             stringWithFormat:[NSString stringWithFormat:@"Directed by %@", self.movie.director]];
    
    [self checkIfValidTextView:self.websiteLabel
                      ofString:self.movie.website
              stringWithFormat:self.movie.website];
    
    [self checkIfValidTextView:self.plotSummaryTextView
                      ofString:self.movie.plotSummary
              stringWithFormat:self.movie.plotSummary];
}

- (void)setEverythingHidden {
    [self.directorLabel setHidden:YES];
    [self.websiteLabel setHidden:YES];
    [self.plotSummaryTextView setHidden:YES];
}

- (void)checkIfValidUILabel:(UILabel *)viewObject ofString:(NSString *)string stringWithFormat:(NSString *)displayString {
    // checks if the data in the movie object is "null" (N/A) if it is NOT, then display it and unhide the object
    if (![string isEqualToString:@"N/A"]) {
        viewObject.text = displayString;
        [viewObject setHidden:NO];
    }
}

- (void)checkIfValidTextView:(UITextView *)viewObject ofString:(NSString *)string stringWithFormat:(NSString *)displayString {
    // because UITextView and UILabel are not of the same parent types #thanksApple
    if (![string isEqualToString:@"N/A"]) {
        viewObject.text = displayString;
        [viewObject setHidden:NO];
    }
}

- (void)parseMovieJSONData:(NSDictionary *)json {
    // set the data member fields that the json data fetched
    [self.movie setRating:[json objectForKey:@"Rated"]
             runtime:[json objectForKey:@"Runtime"]
            director:[json objectForKey:@"Director"]
                plot:[json objectForKey:@"Plot"]
           posterURL:[json objectForKey:@"Poster"]
             website:[json objectForKey:@"Website"]];
}

- (NSString *)movieRequestString:(NSString *)imbdID {
    // creates string for the url to request data
    return [NSString stringWithFormat:@"%@i=%@&r=json&tomatoes=true", omdbRequestString, imbdID];
}

- (NSMutableURLRequest *)generateRequest:(NSString *)urlString {
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
                               
                               [self retrievePosterImage];
                               [self.activitySpinner stopAnimating];
                           }];
}

- (void)retrievePosterImage {
    // gets the image from the URL data
    self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.movie.posterURL]]];
}

@end
