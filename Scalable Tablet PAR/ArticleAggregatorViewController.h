//
//  ArticleAggregatorViewController.h
//  Scalable Tablet App
//
//  Created by cvflores on 1/23/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFKPageFlipper.h"
#import "AggregatorLayoutView.h"


@interface ArticleAggregatorViewController : UIViewController<AFKPageFlipperDataSource,AggregatorLayoutDelegate>
{
    NSMutableArray* viewControlerStack;
    AFKPageFlipper *flipper;
    UIView* fullScreenBGView;
 //   NSString* wallTitle;
    BOOL isInFullScreenMode;
    NSMutableArray* messageArrayCollection;
}

//-(void)closeFullScreen;
//-(void)buildPages:(NSArray*)messagesArray;
- (id) getData:(AggregatorLayoutView *) aggregatorLayoutView;



@property (nonatomic, assign) NSMutableArray* viewControllerStack;
@property (nonatomic, assign) UIGestureRecognizer* gestureRecognizer;
@property (nonatomic, retain) NSString* wallTitle;
@property (nonatomic, strong) NSArray* articleDetails;
@property (nonatomic, assign) NSInteger volumeId;
@property (nonatomic,assign) NSInteger issueId;




@end
