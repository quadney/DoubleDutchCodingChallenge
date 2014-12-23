//
//  MovieCell.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    [self updateUI];
}

- (void)updateUI {
    [self.movieTitle setText:[NSString stringWithFormat:@"%@ (%@)", self.movie.title, self.movie.year]];
    [self.filmType setText:self.movie.type];
    //[self.tomatoScore setText:tomScore];
}

@end
