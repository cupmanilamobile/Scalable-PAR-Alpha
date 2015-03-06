//
//  ArticleAggregatorItemView.h
//  Scalable Tablet App
//
//  Created by cvflores on 1/22/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleAggregatorItemView : UIView
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *authors;
@property (strong, nonatomic) IBOutlet UILabel *abstractText;
@property (strong, nonatomic) IBOutlet UIImageView *articleImage;

@end
