//
//  MovieCell.m
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithTitle:(NSString *)title year:(NSNumber *)year filmType:(NSString *)type tScore:(NSString *)tomScore {
    [self.movieTitle setText:[NSString stringWithFormat:@"%@ (%@)", title, year]];
    [self.filmType setText:type];
    [self.tomatoScore setText:tomScore];
}

@end
