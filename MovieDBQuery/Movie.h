//
//  Movie.h
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *imdbID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *runtime;
@property (strong, nonatomic) NSString *director;
@property (strong, nonatomic) NSString *plotSummary;
@property (strong, nonatomic) NSString *posterURL;
@property (strong, nonatomic) NSString *website;

- (void)setTitle:(NSString *)title year:(NSString *)year type:(NSString *)type imdbID:(NSString *)imdbid;
- (void)setRating:(NSString *)rating runtime:(NSString *)runtime director:(NSString *)director plot:(NSString *)plot posterURL:(NSString *)posterURL website:(NSString *)website;

@end
