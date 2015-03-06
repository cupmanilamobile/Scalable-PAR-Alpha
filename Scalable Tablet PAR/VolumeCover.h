//
//  VolumeCover.h
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeCover : UIView
-(void)initSubViews;
@property (strong, nonatomic) IBOutlet UIImageView *CoverImage;
@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;

@end
