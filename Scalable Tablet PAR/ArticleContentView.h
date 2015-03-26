//
//  ArticleContentView.h
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/25/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleContentView : UIView

@property (nonatomic, copy) NSAttributedString *articleMarkup;

- (void)buildFrames;

@end
