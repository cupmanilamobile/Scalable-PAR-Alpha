//
//  FullScreenView.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 3/6/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "FullScreenView.h"

@implementation FullScreenView
@synthesize articleTitle;
@synthesize articleAbstract;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)touchCloseButton:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame =  CGRectMake(30, 30, 0, 0);
    }];
    
    [[self.superview viewWithTag:100] removeFromSuperview];
    [self removeFromSuperview];
}

@end
