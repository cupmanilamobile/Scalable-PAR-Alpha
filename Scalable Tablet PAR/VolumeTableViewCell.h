//
//  VolumeTableViewCell.h
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *volumeNumber;
@property (strong, nonatomic) IBOutlet UILabel *volumeYear;
@end
