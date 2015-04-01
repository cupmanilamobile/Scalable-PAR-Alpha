//
//  ArticleContentView.h
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/25/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleContentView : UIScrollView

@property (nonatomic, copy) NSString *articleMarkup;

- (void)buildFrames;

@end