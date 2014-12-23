//
//  Movie.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (void)setTitle:(NSString *)title year:(NSNumber *)year imdbID:(NSString *)imdbid filmType:(NSString *)type
{
    self.title = title;
    self.year = year;
    self.imdbID = imdbid;
    self.type = type;
}

@end
