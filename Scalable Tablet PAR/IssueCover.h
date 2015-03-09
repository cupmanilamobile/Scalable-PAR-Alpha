//
//  IssueCover.h
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/8/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueCover : UIView
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *issueLabel;
@property (nonatomic) int volumeId;
@end
