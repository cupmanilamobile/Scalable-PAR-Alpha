//
//  VolumeCover.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "VolumeCover.h"

@implementation VolumeCover

@synthesize volumeLabel;
@synthesize CoverImage;


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //[self initSubViews];
    
  
    
    
}
-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self initSubViews];
    }
    
    return self;
}

-(void)initSubViews{
    
    
    self.CoverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40)];
    self.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-45, self.frame.size.width,35 ) ];
    self.volumeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.CoverImage];
    [self addSubview:self.volumeLabel];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
