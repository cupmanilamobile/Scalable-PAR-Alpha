//
//  AggregatorLayoutView.h
//  Scalable Tablet App
//
//  Created by cvflores on 1/26/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AggregatorLayoutView;


@protocol AggregatorLayoutDelegate


- (id) getData:(AggregatorLayoutView *) aggregatorLayoutView;
- (NSDictionary*) getArticle;
 -(void)purchaseArticle;



@end



@interface AggregatorLayoutView : UIView

@property (nonatomic,retain) NSObject <AggregatorLayoutDelegate> *dataSource;



-(void)initalizeViews;
-(void)initalizeFrame:(CGRect) parentFrame ;
-(void)initalizeViewsOption2;
-(void)initalizeViewsOption3;
-(void)initalizeViewsOption4;
-(void)setDatasource:(NSObject <AggregatorLayoutDelegate>*) dataSource;
@end
