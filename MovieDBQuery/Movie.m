//
//  Movie.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (void)setTitle:(NSString *)title year:(NSString *)year type:(NSString *)type imdbID:(NSString *)imdbid
{
    self.title = title;
    self.year = year;
    self.type = type;
    self.imdbID = imdbid;
}

- (void)setRating:(NSString *)rating runtime:(NSString *)runtime director:(NSString *)director plot:(NSString *)plot posterURL:(NSString *)posterURL website:(NSString *)website {
    self.rating = rating;
    self.runtime = runtime;
    self.director = director;
    self.plotSummary = plot;
    self.posterURL = posterURL;
    self.website = website;
}

@end
