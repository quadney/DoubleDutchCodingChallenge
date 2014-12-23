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
@property (strong, nonatomic) NSNumber *year;

- (void)setTitle:(NSString *)title year:(NSNumber *)year imdbID:(NSString *)imdbid;

@end
