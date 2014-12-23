//
//  MovieCell.h
//  MovieDBQuery
//
//  Created by Sydney Richardson on 12/23/14.
//  Copyright (c) 2014 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *filmType;
@property (weak, nonatomic) IBOutlet UILabel *tomatoScore;

- (void)updateUIWithTitle:(NSString *)title year:(NSNumber *)year filmType:(NSString *)type tScore:(NSString *)tomScore;

@end
